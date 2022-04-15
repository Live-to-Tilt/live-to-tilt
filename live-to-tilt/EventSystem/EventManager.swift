//
//  An adapter for NotificationCenter
//  Acts as a mediator between event emitters and event subscribers
//

import NotificationCenter

typealias EventClosure = (Event) -> Void

class EventManager {
    static let shared = EventManager()
    private var observerClosures: [EventIdentifier: [EventClosure]]

    private init() {
        observerClosures = [:]
    }

    func postEvent(_ event: Event) {
        NotificationCenter.default.post(event.toNotification())
    }

    func reinit() {
        for eventIdentifier in observerClosures.keys {
            observerClosures[eventIdentifier] = nil
            NotificationCenter.default.removeObserver(self, name: eventIdentifier.notificationName, object: nil)
        }
        observerClosures = [:]
    }

    func registerClosure<T: Event>(for event: T.Type, closure: @escaping EventClosure) {
        if observerClosures[T.identifier] == nil {
            createObserver(for: event, observer: self, selector: #selector(executeObserverClosures))
        }
        observerClosures[T.identifier, default: []].append(closure)
    }

    private func createObserver<T: Event>(for event: T.Type, observer: AnyObject, selector: Selector) {
        let notificationName = T.identifier.notificationName
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: notificationName,
                                               object: nil)
    }

    @objc
    private func executeObserverClosures(_ notification: Notification) {
        guard
            let event = notification.userInfo?["event"] as? Event,
            let closures = observerClosures[event.identifier]
        else {
            return
        }

        for closure in closures {
            closure(event)
        }
    }
}
