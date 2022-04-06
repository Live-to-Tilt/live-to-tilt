class ScoreChangedEvent: Event {
    let deltaScore: Int

    init(deltaScore: Int) {
        self.deltaScore = deltaScore
    }
}
