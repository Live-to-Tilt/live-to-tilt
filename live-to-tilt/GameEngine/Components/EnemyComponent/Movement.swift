import CoreGraphics

protocol Movement {
    var nexus: Nexus { get }

    func update(entity: Entity, deltaTime: CGFloat)
}
