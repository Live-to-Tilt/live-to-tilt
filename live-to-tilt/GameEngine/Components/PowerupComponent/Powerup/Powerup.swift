import CoreGraphics
import Foundation

protocol Powerup {
    var orbImage: ImageAsset { get }
    var activationScore: Int { get }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint, playerComponent: PlayerComponent)
}

extension Powerup {
    func activate(nexus: Nexus, at position: CGPoint, by playerComponent: PlayerComponent) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus, powerupPosition: position, playerComponent: playerComponent)
            EventManager.shared.postEvent(PowerupUsedEvent(powerup: self))
        }
    }
}
