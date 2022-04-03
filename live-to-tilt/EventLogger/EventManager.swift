//
//  An adapter for NotificationCenter
//  Acts as a mediator between event emitters and event subscribers
//

import NotificationCenter

class EventManager {
    static let shared = EventManager()
    private var observerClosures: [Event: [(Event, [EventInfo: Float]?) -> Void]]

    private init() {
        observerClosures = [:]
    }

    func postEvent(_ event: Event, eventInfo: [EventInfo: Float]) {
        var userInfo: [String: Float] = [:]
        for eventInfoPair in eventInfo {
            userInfo[eventInfoPair.key.rawValue] = eventInfoPair.value
        }
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
    }

    func postEvent(_ event: Event) {
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    func reinit() {
        for event in observerClosures.keys {
            observerClosures[event] = nil
            NotificationCenter.default.removeObserver(self, name: Notification.Name(event: event), object: nil)
        }
        observerClosures = [:]
    }

    func registerClosure(event: Event, closure: @escaping (Event, [EventInfo: Float]?) -> Void) {
        if observerClosures[event] == nil {
            registerClosure(event: event, observer: self, selector: #selector(executeObserverClosures))
        }
        observerClosures[event, default: []].append(closure)
    }

    private func registerClosure(event: Event, observer: AnyObject, selector: Selector) {
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.addObserver(observer,
                                               selector: selector,
                                               name: notificationName,
                                               object: nil)
    }

    @objc
    private func executeObserverClosures(_ notification: Notification) {
        guard
            let event = Event(rawValue: notification.name.rawValue),
            let closures = observerClosures[event]
        else {
            return
        }
        var eventInfoDict: [EventInfo: Float] = [:]
        if let eventInfoRaw = notification.userInfo as? [String: Float] {
            for (key, value) in eventInfoRaw {
                if let eventInfo = EventInfo(rawValue: key) {
                    eventInfoDict[eventInfo] = value
                }
            }
        }

        for closure in closures {
            closure(event, eventInfoDict)
        }
    }
}
