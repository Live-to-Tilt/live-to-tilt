import CoreGraphics

protocol PowerupEffect {
    var nexus: Nexus { get }
    var orbImage: ImageAsset { get }

    func activate()
    func update(for deltaTime: CGFloat)
}
