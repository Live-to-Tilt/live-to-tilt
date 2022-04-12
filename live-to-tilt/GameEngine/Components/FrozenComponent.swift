import CoreGraphics

class FrozenComponent: Component {
    let entity: Entity
    var timeLeft: CGFloat
    let initialRenderables: [RenderableComponent]
    var frozenBy: Set<ObjectIdentifier>

    init(entity: Entity,
         timeLeft: CGFloat,
         initialRenderables: [RenderableComponent],
         frozenBy id: ObjectIdentifier) {
        self.entity = entity
        self.timeLeft = timeLeft
        self.initialRenderables = initialRenderables
        self.frozenBy = [id]
    }
}
