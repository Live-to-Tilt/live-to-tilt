import CoreGraphics

import Foundation

protocol Powerup {
    var orbImage: ImageAsset { get }
    var activationScore: Int { get }

    func coroutine(nexus: Nexus, powerupPosition: CGPoint)
}

extension Powerup {
    func activate(nexus: Nexus, at position: CGPoint) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus, powerupPosition: position)
            EventManager.shared.postEvent(PowerupUsedEvent(powerup: self))
        }
    }
}
