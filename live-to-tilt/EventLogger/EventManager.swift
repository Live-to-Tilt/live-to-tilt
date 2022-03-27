//
//  An adapter for NotificationCenter
//  Acts as a mediator between event emitters and event subscribers
//

import NotificationCenter

class EventManager {
    static var observerClosures: [Event: [(Event, [EventInfo: Int]?) -> Void]] = [:]

    static func postEvent(_ event: Event, eventInfo: [EventInfo: Int]) {
        var userInfo: [String: Int] = [:]
        for eventInfoPair in eventInfo {
            userInfo[eventInfoPair.key.rawValue] = eventInfoPair.value
        }
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
    }

    static func postEvent(_ event: Event) {
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    private static func registerClosure(event: Event, observer: AnyObject, selector: Selector) {
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: notificationName,
                                               object: nil)
    }

    static func registerClosure(event: Event, closure: @escaping (Event, [EventInfo: Int]?) -> Void) {
        if observerClosures[event] == nil {
            registerClosure(event: event, observer: self, selector: #selector(executeObserverClosures))
        }
        guard var closureList = observerClosures[event] else {
            observerClosures[event] = [closure]
            return
        }
        closureList.append(closure)
    }

    static func removeObservers() {
        observerClosures = [:]
    }

    @objc
    static func executeObserverClosures(_ notification: Notification) {
        guard let event = Event(rawValue: notification.name.rawValue) else {
            return
        }
        guard let closureList = observerClosures[event] else {
            return
        }
        for closure in closureList {
            if let eventsInfo = notification.userInfo as? [EventInfo: Int] {
                closure(event, eventsInfo)
            } else {
                closure(event, nil)
            }
        }
    }
}
