import CoreGraphics

/**
 Encapsulates custom properties and behaviour of the Nuke powerup.
 
 When activated, the Nuke powerup will explode, destroying all nearby Enemies.
 
 See https://tilttolive.fandom.com/wiki/Nuke for more details.
 */
class NukePowerupComponent: Component {
    let entity: Entity
    var currentExplosionRadius: CGFloat = Constants.powerupDiameter / 2

    init(entity: Entity) {
        self.entity = entity
    }

    var hasCompletedExplosion: Bool {
        self.currentExplosionRadius > Constants.nukeExplosionRadius
    }
}
