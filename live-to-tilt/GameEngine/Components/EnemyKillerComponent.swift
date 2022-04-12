class EnemyKillerComponent: Component {
    let entity: Entity
    let soundEffect: SoundEffect?

    init(entity: Entity, soundEffect: SoundEffect? = nil) {
        self.entity = entity
        self.soundEffect = soundEffect
    }
}
