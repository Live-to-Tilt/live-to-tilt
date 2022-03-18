/// The Nexus manages all entities and components.
final class Nexus {
    /// - Key: Entity
    /// - Value: Subdictionary where
    ///     - Key: `ComponentIdentifier` (component type)
    ///     - Value: Array of components of that type, belonging to the entity
    private(set) var entities: [Entity: [ComponentIdentifier: [Component]]] = [:]

    /// - Key: `ComponentIdentifier` (component type)
    /// - Value: Set of entities which has components of that type
    private(set) var entitiesByComponent: [ComponentIdentifier: Set<Entity>] = [:]

    /// Returns all entities with components of the given type
    func getEntities<T: Component>(with type: T.Type) -> [Entity] {
        Array(entitiesByComponent[T.identifier, default: []])
    }

    /// Returns all components of a given type
    func getComponents<T: Component>(of type: T.Type) -> [T] {
        var components: [T] = []

        entitiesByComponent[T.identifier, default: []].forEach { entity in
            components.append(contentsOf: getComponents(of: type, for: entity))
        }

        return components
    }

    /// Returns all components of a given type for a given entity
    func getComponents<T: Component>(of type: T.Type, for entity: Entity) -> [T] {
        guard
            let componentsDict = entities[entity],
            let components = componentsDict[T.identifier] as? [T]
        else {
            return []
        }

        return components
    }

    /// Returns the first component of a given type for a given entity
    func getComponent<T: Component>(of type: T.Type, for entity: Entity) -> T? {
        getComponents(of: type, for: entity).first
    }

    /// Adds the given component to the given entity, and adds the entity to the nexus if it is new
    func addComponent<T: Component>(_ component: T, to entity: Entity) {
        entities[entity, default: [:]][T.identifier, default: []].append(component)
        entitiesByComponent[T.identifier, default: []].insert(entity)
    }

    /// Checks whether the given entity contains the given component type
    func hasComponent<T: Component>(_ type: T.Type, in entity: Entity) -> Bool {
        getComponent(of: type, for: entity) != nil
    }

    /// Removes the given entity from the nexus
    func removeEntity(_ entity: Entity) {
        entities.removeValue(forKey: entity)
        for identifier in entitiesByComponent.keys {
            entitiesByComponent[identifier]?.remove(entity)
        }
    }
}
