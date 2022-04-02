import CoreGraphics

protocol PowerupEffect {
    var orbImage: ImageAsset { get }

    func activate()
    func update(for deltaTime: CGFloat)
}
