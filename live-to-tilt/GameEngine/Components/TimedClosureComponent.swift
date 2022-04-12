import CoreGraphics

class TimedClosureComponent: Component {
    let entity: Entity
    var timeLeft: CGFloat
    let closure: () -> Void

    init(entity: Entity, timeLeft: CGFloat, closure: @escaping () -> Void) {
        self.entity = entity
        self.timeLeft = timeLeft
        self.closure = closure
    }
}
