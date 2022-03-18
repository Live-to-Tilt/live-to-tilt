import Foundation

protocol Wave {
    var nexus: Nexus { get }

    func coroutine()
}

extension Wave {
    func start() {
        DispatchQueue.main.async {
            coroutine()
        }
    }
}
