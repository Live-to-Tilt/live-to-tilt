import CoreGraphics

extension CGSize {
    static func += (lhs: inout CGSize, rhs: CGFloat) {
        lhs = CGSize(width: lhs.width + rhs, height: lhs.height + rhs)
    }

    func normalize(frame: CGRect) -> CGSize {
        let transform = CGAffineTransform(scaleX: 1 / frame.maxX, y: 1 / frame.maxY)
        return self.applying(transform)
    }

    func denormalize(frame: CGRect) -> CGSize {
        let transform = CGAffineTransform(scaleX: frame.maxX, y: frame.maxY)
        return self.applying(transform)
    }
}
