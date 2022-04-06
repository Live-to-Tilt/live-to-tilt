import Foundation

protocol Powerup {
    var orbImage: ImageAsset { get }
    var activationScore: Int { get }

    func coroutine(nexus: Nexus)
}

extension Powerup {
    func activate(nexus: Nexus) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus)
            EventManager.shared.postEvent(PowerupUsedEvent(powerup: self))
        }
    }
}
