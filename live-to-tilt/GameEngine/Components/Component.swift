/// A component stores data for one aspect of an entity.
protocol Component {
    static var identifier: ComponentIdentifier { get }
    var identifier: ComponentIdentifier { get }
    var entity: Entity { get }
}

extension Component {
    static var identifier: ComponentIdentifier { ComponentIdentifier(Self.self) }
    var identifier: ComponentIdentifier { Self.identifier }
}
