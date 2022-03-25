import CoreGraphics
import NotificationCenter

protocol System {
    var nexus: Nexus { get }

    func update(deltaTime: CGFloat)
}
