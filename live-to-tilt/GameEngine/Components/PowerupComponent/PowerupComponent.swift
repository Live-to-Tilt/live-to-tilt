class PowerupComponent: Component {
    let entity: Entity
    private(set) var isActive = false

    init(entity: Entity) {
        self.entity = entity
    }

    func activate() {
        self.isActive = true
    }
}
