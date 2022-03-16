extension Nexus {
    func createPlayer() {
        let entity = Entity()

        addComponent(PlayerComponent(), to: entity)
        addComponent(RenderableComponent(image: .player,
                                         position: Constants.playerSpawnPosition,
                                         size: Constants.playerSize),
                     to: entity)
    }
}
