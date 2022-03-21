protocol StatsObservable: AnyObject {
    var subscribers: [StatsSubscriber] { get set }

    func notifySubscribers()
}

extension StatsObservable {
    func subscribe(_ subscriber: StatsSubscriber) {
        subscribers.append(subscriber)
    }

    func unsubscribe(_ subscriber: StatsSubscriber) {
        subscribers.removeAll(where: {$0 === subscriber})
    }

}
