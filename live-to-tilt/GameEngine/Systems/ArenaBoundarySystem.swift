import CoreGraphics

final class ArenaBoundarySystem: System {
    var nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let arenaBoundaryComponents = nexus.getComponents(of: ArenaBoundaryComponent.self)
        arenaBoundaryComponents.forEach { arenaBoundaryComponent in
            despawnIfOutsideArena(arenaBoundaryComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {}

    private func despawnIfOutsideArena(_ arenaBoundaryComponent: ArenaBoundaryComponent) {
        let entity = arenaBoundaryComponent.entity

        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self,
                                                        for: entity) else {
            return
        }

        let position = physicsComponent.physicsBody.position

        if GameUtils.isOutsideArena(position: position) {
            nexus.removeEntity(entity)
        }
    }
}
