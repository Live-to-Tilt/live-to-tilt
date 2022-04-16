import Foundation

protocol Wave {
    func coroutine(nexus: Nexus)
}

extension Wave {
    func spawn(nexus: Nexus) {
        DispatchQueue.main.async {
            coroutine(nexus: nexus)
            EventManager.shared.postEvent(WaveSpawnedEvent(wave: self))
        }
    }
}
