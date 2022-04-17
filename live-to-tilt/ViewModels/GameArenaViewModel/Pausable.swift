protocol Pausable {
    func restart()

    func pause()

    func resume()

    func getGameOverStats() -> [GameOverStat]
}
