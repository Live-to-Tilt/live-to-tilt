import Foundation

class EnemyFreezerComponent: Component {
    let entity: Entity

    init(entity: Entity) {
        self.entity = entity
    }
}

extension EnemyFreezerComponent: Identifiable {}
