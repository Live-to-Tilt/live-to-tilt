import CoreGraphics

class FrozenComponent: Component {
    let entity: Entity
    var timeLeft: CGFloat
    let initialRenderables: [RenderableComponent]

    init(entity: Entity, timeLeft: CGFloat, initialRenderables: [RenderableComponent]) {
        self.entity = entity
        self.timeLeft = timeLeft
        self.initialRenderables = initialRenderables
    }
}
