import CoreGraphics

struct RenderableInfo: Codable {
    let id: String
    let image: ImageAsset
    let position: CGPoint
    let size: CGSize
    let rotation: CGFloat
    let opacity: Double
    let layer: Layer

    init(_ renderableComponent: RenderableComponent) {
        self.id = renderableComponent.id
        self.image = renderableComponent.image
        self.position = renderableComponent.position
        self.size = renderableComponent.size
        self.rotation = renderableComponent.rotation
        self.opacity = renderableComponent.opacity
        self.layer = renderableComponent.layer
    }

    func toRenderableComponent(entity: Entity) -> RenderableComponent {
        let renderableComponent = RenderableComponent(entity: entity,
                                                      image: image,
                                                      position: position,
                                                      size: size,
                                                      rotation: rotation,
                                                      opacity: opacity,
                                                      layer: layer,
                                                      id: id)
        return renderableComponent
    }
}
