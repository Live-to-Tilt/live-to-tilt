class Message: Codable {
    let sequenceId: Int

    init(sequenceId: Int) {
        self.sequenceId = sequenceId
    }
}
