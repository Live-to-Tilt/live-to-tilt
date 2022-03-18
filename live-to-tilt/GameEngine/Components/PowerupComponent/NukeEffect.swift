import CoreGraphics

/**
 Encapsulates the effects of the Nuke powerup.
 
 When activated, the Nuke powerup will explode, destroying all nearby Enemies.
 
 See https://tilttolive.fandom.com/wiki/Nuke for more details.
 */
class NukeEffect: PowerupEffect {
    let nexus: Nexus
    let entity: Entity
    let image: ImageAsset = .nuke
    private var currentExplosionRadius: CGFloat = Constants.powerupDiameter / 2
    private var hasCompletedExplosion: Bool {
        self.currentExplosionRadius > Constants.nukeExplosionRadius
    }

    init(nexus: Nexus, entity: Entity) {
        self.nexus = nexus
        self.entity = entity
    }

    func update(for deltaTime: CGFloat) {
        guard let physicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: entity),
              let renderableComponent = nexus.getComponent(of: RenderableComponent.self, for: entity) else {
            return
        }

        if self.hasCompletedExplosion {
            nexus.removeEntity(entity)
        } else {
            let timeFraction = deltaTime / Constants.nukeExplosionDuration
            let deltaRadius = (Constants.nukeExplosionRadius - (Constants.powerupDiameter / 2)) * timeFraction

            self.currentExplosionRadius += deltaRadius
            physicsComponent.physicsBody.size += deltaRadius
            renderableComponent.size += deltaRadius
            renderableComponent.opacity -= timeFraction
        }
    }
}
