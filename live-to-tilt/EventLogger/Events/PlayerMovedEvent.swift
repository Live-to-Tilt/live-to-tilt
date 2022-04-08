class PlayerMovedEvent: Event {
    let deltaDistance: Float

    init(deltaDistance: Float) {
        self.deltaDistance = deltaDistance
    }
}
