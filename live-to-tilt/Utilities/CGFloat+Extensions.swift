import CoreGraphics

extension CGFloat {
    func square() -> CGFloat {
        self * self
    }

    func normalize(by value: CGFloat) -> CGFloat {
        self / value
    }

    func denormalize(by value: CGFloat) -> CGFloat {
        self * value
    }
}
