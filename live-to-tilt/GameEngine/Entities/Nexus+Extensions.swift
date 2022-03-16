import CoreGraphics

extension Nexus {
    func createPlayer() {
        let entity = Entity()

        addComponent(PlayerComponent(), to: entity)
        addComponent(RenderableComponent(image: .player,
                                         position: Constants.playerSpawnPosition,
                                         size: Constants.playerSize),
                     to: entity)
    }

    func createEnemy(position: CGPoint) {
        let entity = Entity()
        let transform = CGAffineTransform(scaleX: Constants.enemyFrontToBackRatio, y: Constants.enemyFrontToBackRatio)
        let enemyFrontSize = Constants.enemySize.applying(transform)

        addComponent(EnemyComponent(), to: entity)
        addComponent(RenderableComponent(image: .enemyFront,
                                         position: position,
                                         size: enemyFrontSize,
                                         layer: .enemyFront),
                     to: entity)
        addComponent(RenderableComponent(image: .enemyBack,
                                         position: position,
                                         size: Constants.enemySize,
                                         layer: .enemyBack),
                     to: entity)
    }
}
