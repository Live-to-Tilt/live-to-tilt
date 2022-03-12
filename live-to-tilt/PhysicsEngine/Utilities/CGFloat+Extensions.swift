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

    func clamped(_ vec1: CGFloat, _ vec2: CGFloat) -> CGFloat {
        let min = vec1 < vec2 ? vec1 : vec2
        let max = vec1 > vec2 ? vec1 : vec2
        return self < min ? min : (self > max ? max : self)
    }
}
