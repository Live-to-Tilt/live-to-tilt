import CoreGraphics

class RenderableComponent: Component {
    var image: ImageAsset

    var position: CGPoint
    var size: CGSize
    var rotation: CGFloat

    var opacity: Double
    var layer: Layer

    init(image: ImageAsset,
         position: CGPoint,
         size: CGSize,
         rotation: CGFloat = 0.0,
         opacity: Double = 1.0,
         layer: Layer = .base) {
        self.image = image
        self.position = position
        self.size = size
        self.rotation = rotation
        self.opacity = opacity
        self.layer = layer
    }
}

extension RenderableComponent: Hashable {
    static func == (lhs: RenderableComponent, rhs: RenderableComponent) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
