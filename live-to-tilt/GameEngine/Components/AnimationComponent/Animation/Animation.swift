import CoreGraphics

protocol Animation {
    var active: Bool { get set }

    func update(nexus: Nexus, entity: Entity, deltaTime: CGFloat)
}
