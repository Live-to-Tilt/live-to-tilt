class AnimationComponent: Component {
    var entity: Entity
    let animation: Animation

    init(entity: Entity, animation: Animation) {
        self.entity = entity
        self.animation = animation
    }
}
