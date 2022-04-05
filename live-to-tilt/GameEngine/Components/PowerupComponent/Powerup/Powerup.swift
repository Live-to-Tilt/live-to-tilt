import Foundation

protocol Powerup {
    var image: ImageAsset { get }

    func coroutine(nexus: Nexus)
}

extension Powerup {
    func activate(nexus: Nexus) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus)
        }
    }
}
