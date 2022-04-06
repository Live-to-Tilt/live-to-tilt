class ComboExpiredEvent: Event {
    let comboScore: Int

    init(comboScore: Int) {
        self.comboScore = comboScore
    }
}
