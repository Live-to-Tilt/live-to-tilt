import CoreGraphics

protocol Interval {
    var duration: CGFloat { get }

    func next()
}
