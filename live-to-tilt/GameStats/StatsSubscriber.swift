protocol StatsSubscriber: AnyObject {
    func update(stat: StatsKey, value: Any) 
}
