import CoreGraphics

protocol PowerupEffect {
    var nexus: Nexus { get }
    var image: ImageAsset { get }

    func activate()
    func update(for deltaTime: CGFloat)
}
