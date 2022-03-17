class PowerupComponent: Component {
    let entity: Entity
    private var isActive = false
    
    init(entity: Entity) {
        self.entity = entity
    }
    
    func activate() {
        self.isActive = true
    }
}
