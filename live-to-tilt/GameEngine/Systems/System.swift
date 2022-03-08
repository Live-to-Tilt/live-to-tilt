import CoreGraphics

protocol System {
    var nexus: Nexus { get }

    func update(deltaTime: CGFloat)
}
