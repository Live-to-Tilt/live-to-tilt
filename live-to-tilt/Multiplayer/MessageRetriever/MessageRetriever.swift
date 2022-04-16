protocol MessageRetriever {
    var messageBuffer: MessageBuffer { get }

    func retrieveMessage() -> Message?

    func skipMessage()
}
