import CoreGraphics

final class ArenaBoundarySystem: System {
    var nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let arenaRestrictionComponents = nexus.getComponents(of: ArenaBoundaryComponent.self)
        arenaRestrictionComponents.forEach { arenaRestrictionComponent in
            despawnIfOutsideArena(arenaRestrictionComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {

    }

    private func despawnIfOutsideArena(_ arenaRestrictionComponent: ArenaBoundaryComponent) {
        let entity = arenaRestrictionComponent.entity

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
