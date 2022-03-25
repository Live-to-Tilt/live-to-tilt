//
//  An adapter for NotificationCenter
//  Acts as a mediator between event emitters and event subscribers
//

import NotificationCenter

class EventManager {
    static func postEvent(_ event: Event, frequency: Int) {
        let userInfo = ["frequency": frequency]
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
    }

    static func postEvent(_ event: Event) {
        EventManager.postEvent(event, frequency: 1)
    }

    static func registerCallback(event: Event, observer: AnyObject, selector: Selector) {
        let notificationName = Notification.Name(event: event)
        NotificationCenter.default.addObserver(observer,
                                                 selector: selector,
                                                 name: notificationName,
                                                 object: nil)
    }
}
