class SequentialMessageRetriever: MessageRetriever {
    let messageBuffer: MessageBuffer
    private var expectedMessageSequenceId: Int

    init() {
        self.expectedMessageSequenceId = .zero
        self.messageBuffer = MessageBuffer()
    }

    func retrieveMessage() -> Message? {
        if messageBuffer.isEmpty() {
            return nil
        }

        guard let message = messageBuffer.peek() else {
            return nil
        }

        if message.sequenceId < expectedMessageSequenceId {
            expectedMessageSequenceId = message.sequenceId
            return nil
        }

        if message.sequenceId > expectedMessageSequenceId {
            return nil
        }

        messageBuffer.remove()
        expectedMessageSequenceId += 1
        return message
    }

    func skipMessage() {
        expectedMessageSequenceId += 1
    }
}
