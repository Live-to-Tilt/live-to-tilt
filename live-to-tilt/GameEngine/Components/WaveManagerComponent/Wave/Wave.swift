import Foundation

protocol Wave {
    func coroutine(nexus: Nexus)
}

extension Wave {
    func start(nexus: Nexus) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus)
        }
    }
}
