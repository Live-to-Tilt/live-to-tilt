import CoreGraphics

class RenderableComponent: Component, Identifiable {
    let entity: Entity

    var image: ImageAsset

    var position: CGPoint
    var size: CGSize
    var rotation: CGFloat

    var opacity: Double
    var layer: Layer

    init(entity: Entity,
         image: ImageAsset,
         position: CGPoint,
         size: CGSize,
         rotation: CGFloat = 0.0,
         opacity: Double = 1.0,
         layer: Layer = .base) {
        self.entity = entity
        self.image = image
        self.position = position
        self.size = size
        self.rotation = rotation
        self.opacity = opacity
        self.layer = layer
    }
}
