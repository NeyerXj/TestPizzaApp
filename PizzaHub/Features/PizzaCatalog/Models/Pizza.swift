import CoreGraphics
import Foundation

enum PizzaSize: String, CaseIterable, Codable, Identifiable, Sendable {
    case small = "S"
    case medium = "M"
    case large = "L"

    var id: String {
        rawValue
    }

    var imageDimension: CGFloat {
        switch self {
        case .small:
            196
        case .medium:
            244
        case .large:
            274
        }
    }
}

struct PizzaVariant: Codable, Identifiable, Sendable {
    let size: PizzaSize
    let price: Decimal

    var id: PizzaSize {
        size
    }
}

struct Pizza: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    let imageURL: URL
    let variants: [PizzaVariant]
    let defaultSize: PizzaSize

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
        case variants
        case defaultSize = "default_size"
    }

    func variant(for size: PizzaSize) -> PizzaVariant {
        variants.first { $0.size == size } ?? variants.first ?? PizzaVariant(size: .medium, price: 0)
    }

    var initialSize: PizzaSize {
        variants.contains { $0.size == defaultSize } ? defaultSize : variants.first?.size ?? .medium
    }
}

struct PizzaResponse: Codable, Sendable {
    let pizzas: [Pizza]
}
