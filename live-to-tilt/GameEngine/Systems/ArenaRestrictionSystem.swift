import CoreGraphics

final class ArenaRestrictionSystem: System {
    var nexus: Nexus

    init(nexus: Nexus) {
        self.nexus = nexus
    }

    func update(deltaTime: CGFloat) {
        let arenaRestrictionComponents = nexus.getComponents(of: ArenaRestrictionComponent.self)
        arenaRestrictionComponents.forEach { arenaRestrictionComponent in
            despawnIfOutsideArena(arenaRestrictionComponent)
        }
    }

    func lateUpdate(deltaTime: CGFloat) {

    }

    private func despawnIfOutsideArena(_ arenaRestrictionComponent: ArenaRestrictionComponent) {
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
