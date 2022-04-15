class MessageBuffer {
    private var messages: Heap<Message>

    init() {
        self.messages = .init(sort: { $0.sequenceId <= $1.sequenceId })
    }

    func insert(message: Message) {
        messages.insert(message)
    }

    @discardableResult
    func remove() -> Message? {
        messages.remove()
    }

    func peek() -> Message? {
        messages.peek()
    }

    func isEmpty() -> Bool {
        messages.isEmpty
    }
}
