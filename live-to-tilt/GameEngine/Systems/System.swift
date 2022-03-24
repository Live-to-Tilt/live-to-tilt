import CoreGraphics
import NotificationCenter

protocol System {
    var nexus: Nexus { get }
    var events: [Event: Int] { get set }

    var identifier: SystemIdentifier { get }

    func update(deltaTime: CGFloat)
    func postEvents()
}

extension System {
    static var identifier: SystemIdentifier { SystemIdentifier(Self.self) }
    var identifier: SystemIdentifier { Self.identifier }
}


extension System {
    mutating func postEvents() {
        let notificationName = Notification.Name(systemId: self.identifier)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: self.events)
        self.events = [:]
    }
}
