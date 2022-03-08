import CoreGraphics

class RenderableComponent: Component {
    var imageName: String

    var position: CGPoint
    var size: CGSize
    var rotation: CGFloat

    var opacity: Double

    init(imageName: String,
         position: CGPoint,
         size: CGSize,
         rotation: CGFloat = 0.0,
         opacity: Double = 1.0) {
        self.imageName = imageName
        self.position = position
        self.size = size
        self.rotation = rotation
        self.opacity = opacity
    }
}

extension RenderableComponent: Hashable {
    static func == (lhs: RenderableComponent, rhs: RenderableComponent) -> Bool {
        lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
