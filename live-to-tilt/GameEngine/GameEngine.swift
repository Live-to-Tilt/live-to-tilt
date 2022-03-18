import CoreGraphics
import Combine

class GameEngine {
    // ECS
    let nexus = Nexus()
    let systems: [System]

    // Physics Engine
    let physicsWorld = PhysicsWorld()

    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    init() {
        systems = [
            PhysicsSystem(nexus: nexus),
            PlayerSystem(nexus: nexus),
            WaveSystem(nexus: nexus),
            EnemySystem(nexus: nexus)
        ]

        setUpEntities()
    }

    func update(deltaTime: CGFloat, inputForce: CGVector) {
        updatePhysicsBodies(deltaTime: deltaTime)
        updatePlayer(inputForce: inputForce)
        updateSystems(deltaTime: deltaTime)
        publishRenderables()
    }

    private func setUpEntities() {
        nexus.createPlayer()
    }

    private func updatePhysicsBodies(deltaTime: CGFloat) {
        let physicsBodies = nexus.getComponents(of: PhysicsComponent.self).map { $0.physicsBody }
        physicsWorld.update(physicsBodies, deltaTime: deltaTime)
    }

    private func updatePlayer(inputForce: CGVector) {
        guard let playerComponent = nexus.getComponents(of: PlayerComponent.self).first else {
            return
        }
        playerComponent.inputForce = inputForce
    }

    private func updateSystems(deltaTime: CGFloat) {
        systems.forEach { $0.update(deltaTime: deltaTime) }
    }

    private func publishRenderables() {
        renderableSubject.send(nexus.getComponents(of: RenderableComponent.self))
    }
}

// MARK: PhysicsCollisionDelegate
// `GameEngine` is a `PhysicsCollisionDelegate` since it implements custom game logic when a collision is detected
// in the Physics Engine.
extension GameEngine: PhysicsCollisionDelegate {
    func didBegin(_ collision: Collision) {
        guard let entityA = getEntity(from: collision.bodyA),
                let entityB = getEntity(from: collision.bodyB) else {
            return
        }

        if isCollisionBetweenPlayerAndPowerup(entityA: entityA, entityB: entityB) {
            respondToCollisionBetweenPlayerAndPowerup(entityA: entityA, entityB: entityB)
        }
    }

    func didEnd(_ collision: Collision) {
        }

    private func getEntity(from physicsBody: PhysicsBody) -> Entity? {
        let physicsComponents = nexus.getComponents(of: PhysicsComponent.self)

        guard let physicsComponent = physicsComponents.first(where: { $0.physicsBody === physicsBody }) else {
            return nil
        }

        return physicsComponent.entity
    }

    private func isCollisionBetweenPlayerAndPowerup(entityA: Entity, entityB: Entity) -> Bool {
        let isPowerupPlayerCollision = nexus.hasComponent(PowerupComponent.self, in: entityA)
            && nexus.hasComponent(PlayerComponent.self, in: entityB)

        let isPlayerPowerupCollision = nexus.hasComponent(PlayerComponent.self, in: entityA)
            && nexus.hasComponent(PowerupComponent.self, in: entityB)

        return isPowerupPlayerCollision || isPlayerPowerupCollision
    }

    private func respondToCollisionBetweenPlayerAndPowerup(entityA: Entity, entityB: Entity) {
        let entityWithPowerupComponent = nexus.hasComponent(PowerupComponent.self, in: entityA) ? entityA : entityB

        guard let powerupComponent = nexus.getComponent(of: PowerupComponent.self,
                                                        for: entityWithPowerupComponent) else {
            return
        }

        powerupComponent.activate()
    }
}
