import CoreGraphics

extension CGSize {
    static func += (lhs: inout CGSize, rhs: CGFloat) {
        lhs = CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }

    static func -= (lhs: inout CGSize, rhs: CGFloat) {
        lhs = CGSize(width: lhs.width - rhs, height: lhs.height - rhs)
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }

    func normalize(frame: CGRect) -> CGSize {
        let transform = CGAffineTransform(scaleX: 1 / frame.maxY, y: 1 / frame.maxY)
        return self.applying(transform)
    }

    func denormalize(frame: CGRect) -> CGSize {
        let transform = CGAffineTransform(scaleX: frame.maxY, y: frame.maxY)
        return self.applying(transform)
    }
}
