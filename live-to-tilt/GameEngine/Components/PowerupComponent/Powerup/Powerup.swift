import Foundation

protocol Powerup {
    var orbImage: ImageAsset { get }

    func coroutine(nexus: Nexus)
}

extension Powerup {
    func activate(nexus: Nexus) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus)
        }
    }
}
