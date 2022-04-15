import CoreGraphics
import Foundation

class RenderableComponent: Component, Identifiable, Codable {
    let id: String
    let entity: Entity
    var image: ImageAsset
    var position: CGPoint
    var size: CGSize
    var rotation: CGFloat
    var opacity: Double
    var layer: Layer

    init(entity: Entity,
         image: ImageAsset,
         position: CGPoint,
         size: CGSize,
         rotation: CGFloat = 0.0,
         opacity: Double = 1.0,
         layer: Layer = .base) {
        self.id = UUID().uuidString
        self.entity = entity
        self.image = image
        self.position = position
        self.size = size
        self.rotation = rotation
        self.opacity = opacity
        self.layer = layer
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case image
        case position
        case size
        case rotation
        case opacity
        case layer
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.entity = Entity()
        self.image = try container.decode(ImageAsset.self, forKey: .image)
        self.position = try container.decode(CGPoint.self, forKey: .position)
        self.size = try container.decode(CGSize.self, forKey: .size)
        self.rotation = try container.decode(CGFloat.self, forKey: .rotation)
        self.opacity = try container.decode(Double.self, forKey: .opacity)
        self.layer = try container.decode(Layer.self, forKey: .layer)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(image, forKey: .image)
        try container.encode(position, forKey: .position)
        try container.encode(size, forKey: .size)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(opacity, forKey: .opacity)
        try container.encode(layer, forKey: .layer)
    }
}
