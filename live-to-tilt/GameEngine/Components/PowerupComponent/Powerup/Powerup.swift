import CoreGraphics
import Foundation

protocol Powerup {
    var orbImage: ImageAsset { get }
    var activationScore: Int { get }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint, playerEntity: Entity)
}

extension Powerup {
    func activate(nexus: Nexus, at position: CGPoint, by playerEntity: Entity) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus, powerupPosition: position, playerEntity: playerEntity)
            EventManager.shared.postEvent(PowerupUsedEvent(powerup: self))
        }
    }
}
