protocol MessageRetriever {
    func retrieveMessage() -> Message?

    func skipMessage()
}
