class NukePowerup: Powerup {
    let orbImage: ImageAsset

    init() {
        self.orbImage = .nukeOrb
    }

    func coroutine(nexus: Nexus) {
        guard
            let playerEntity = nexus.getEntity(with: PlayerComponent.self),
            let playerPhysicsComponent = nexus.getComponent(of: PhysicsComponent.self, for: playerEntity) else {
                return
            }

        let playerPhysicsBody = playerPhysicsComponent.physicsBody
        let playerPosition = playerPhysicsBody.position
        nexus.createNukeExplosion(position: playerPosition)
    }
}
