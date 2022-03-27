import CoreGraphics

protocol Movement {
    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat)
}
