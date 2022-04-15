import Combine
import QuartzCore

class MultiplayerGuestGameRenderer: GameRenderer {
    private let messageBuffer: MessageBuffer
    private let gameControl: GameControl
    private var displayLink: CADisplayLink!
    private var hasStarted: Bool
    private var expectedMessageSequenceId: Int

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    init(roomManager: RoomManager, messageBuffer: MessageBuffer, gameControl: GameControl) {
        self.messageBuffer = messageBuffer
        self.gameControl = gameControl
        self.hasStarted = false
        self.expectedMessageSequenceId = .zero
    }

    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.guestRenderDelay) {
            self.displayLink = CADisplayLink(target: self, selector: #selector(self.step))
            self.displayLink.preferredFramesPerSecond = Constants.framesPerSecond
            self.displayLink.add(to: .main, forMode: .default)

            self.gameControl.start()

            self.hasStarted = true
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

    }

    func unpause() {

    }

    @objc
    func step() {
        // TODO: Send input force to gameManager

        while true {
            if CACurrentMediaTime() >= displayLink.targetTimestamp {
                expectedMessageSequenceId += 1
                break
            }

            if messageBuffer.isEmpty() {
                continue
            }

            guard
                let message = messageBuffer.peek(),
                let hostMessage = message as? HostMessage else {
                continue
            }

            if hostMessage.sequenceId < expectedMessageSequenceId {
                expectedMessageSequenceId = hostMessage.sequenceId
                continue
            }

            if hostMessage.sequenceId > expectedMessageSequenceId {
                continue
            }

            messageBuffer.remove()
            expectedMessageSequenceId += 1
            let renderableComponents = hostMessage.renderableComponents
            renderableSubject.send(renderableComponents)
            break
        }
    }
}
