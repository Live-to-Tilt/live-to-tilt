import CoreGraphics

class ConnectedMovement: Movement {
    private let movementA: Movement
    private let duration: CGFloat
    private let movementB: Movement
    private var elapsedTime: CGFloat

    init(_ movementA: Movement, for duration: CGFloat, then movementB: Movement) {
        self.movementA = movementA
        self.duration = duration
        self.movementB = movementB
        self.elapsedTime = .zero
    }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat) {
        if elapsedTime + deltaTime > duration {
            movementB.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
            return
        }

        elapsedTime += deltaTime
        movementA.update(nexus: nexus, entity: entity, deltaTime: deltaTime)
    }
}
