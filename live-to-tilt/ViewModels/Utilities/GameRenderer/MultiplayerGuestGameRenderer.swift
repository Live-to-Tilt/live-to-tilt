import Combine
import QuartzCore

class MultiplayerGuestGameRenderer: GameRenderer {
    private let messageRetriever: MessageRetriever
    private let roomManager: RoomManager
    private let gameControl: GameControl
    private var displayLink: CADisplayLink!
    private var hasStarted: Bool

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    init(roomManager: RoomManager, gameControl: GameControl) {
        self.messageRetriever = SequentialMessageRetriever()
        self.roomManager = roomManager
        self.gameControl = gameControl
        self.hasStarted = false
    }

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.guestRenderDelay) {
            self.displayLink = CADisplayLink(target: self, selector: #selector(self.step))
            self.displayLink.preferredFramesPerSecond = Constants.framesPerSecond
            self.displayLink.add(to: .main, forMode: .default)

            self.gameControl.start()

            self.hasStarted = true

            self.attachSubscribers()
        }
    }

    func stop() {
        guard hasStarted else {
            return
        }
        hasStarted = false

        gameControl.stop()

        displayLink.remove(from: .main, forMode: .default)
        displayLink.invalidate()
        displayLink = nil
    }

    func pause() {
        let guestMessage = GuestMessage(pauseSignal: true)
        roomManager.send(message: guestMessage)
    }

    func unpause() {
        let guestMessage = GuestMessage(unpauseSignal: true)
        roomManager.send(message: guestMessage)
    }

    @objc
    func step() {
        sendInputForce()
        processMessage()
    }

    private func processMessage() {
        while true {
            if CACurrentMediaTime() >= displayLink.targetTimestamp {
                messageRetriever.skipMessage()
                break
            }

            guard
                let message = messageRetriever.retrieveMessage(),
                let hostMessage = message as? HostMessage else {
                continue
            }

            process(hostMessage)
            break
        }
    }

    private func process(_ hostMessage: HostMessage) {
        let renderableComponents = hostMessage.renderableComponents
        renderableSubject.send(renderableComponents)
    }

    private func sendInputForce() {
        let inputForce = gameControl.getInputForce()
        let guestMessage = GuestMessage(inputForce: inputForce)
        roomManager.send(message: guestMessage)
    }

    private func attachSubscribers() {
        let messageBuffer = messageRetriever.messageBuffer
        let messageDelegate = HostMessageDelegate(messageBuffer: messageBuffer)
        roomManager.subscribe(messageDelegate: messageDelegate)
    }
}
