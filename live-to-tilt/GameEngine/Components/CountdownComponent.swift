import CoreGraphics

class CountdownComponent: Component {
    let entity: Entity
    let maxTime: CGFloat
    var timeLeft: CGFloat

    init(entity: Entity, maxTime: CGFloat) {
        self.entity = entity
        self.maxTime = maxTime
        self.timeLeft = maxTime
    }
}
