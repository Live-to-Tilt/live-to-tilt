import QuartzCore

class MultiplayerHostGameRenderer: GameRenderer {
    private let messageRetriever: MessageRetriever
    private let messageManager: MessageManager
    private let gameEngine: GameEngine
    private let gameControl: GameControl
    private var displayLink: CADisplayLink!
    private var hasStarted: Bool

    init(messageManager: MessageManager,
         gameEngine: GameEngine,
         gameControl: GameControl) {
        self.messageRetriever = SequentialMessageRetriever()
        self.messageManager = messageManager
        self.gameEngine = gameEngine
        self.gameControl = gameControl
        self.hasStarted = false
    }

    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.preferredFramesPerSecond = Constants.framesPerSecond
        displayLink.add(to: .main, forMode: .default)

        gameControl.start()

        hasStarted = true

        attachSubscribers()
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
        gameEngine.pause()
    }

    func unpause() {
        gameEngine.unpause()
    }

    @objc
    func step() {
        let elapsedTime = displayLink.targetTimestamp - displayLink.timestamp
        let inputForce = gameControl.getInputForce()

        gameEngine.update(deltaTime: CGFloat(elapsedTime), inputForce: inputForce)
        gameEngine.lateUpdate(deltaTime: CGFloat(elapsedTime))
    }

    func processMessage() {
        while true {
            if CACurrentMediaTime() >= displayLink.targetTimestamp {
                messageRetriever.skipMessage()
                break
            }

            guard
                let message = messageRetriever.retrieveMessage(),
                let guestMessage = message as? GuestMessage else {
                continue
            }

            process(guestMessage)
            break
        }
    }

    private func process(_ guestMessage: GuestMessage) {
        if let inputForce = guestMessage.inputForce {
            print(inputForce)
        }

        if guestMessage.pauseSignal {
            pause()
        }

        if guestMessage.unpauseSignal {
            unpause()
        }
    }

    private func attachSubscribers() {
        let messageBuffer = messageRetriever.messageBuffer
        let messageDelegate = GuestMessageDelegate(messageBuffer: messageBuffer)
        messageManager.subscribe(messageDelegate: messageDelegate)
    }
}
