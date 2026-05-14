import SwiftUI

enum PizzaDesign {
    static let canvasSize = CGSize(width: 375, height: 812)
    static let highlight = Color(hex: 0xF3E3DA)
    static let accent = Color(hex: 0x19C4EA)
    static let active = Color.black
    static let text = Color.black
    static let secondaryText = Color.black.opacity(0.7)
    static let shadow = Color.black.opacity(0.15)
}

enum PizzaTypography {
    static func regular(_ size: CGFloat) -> Font {
        .custom("Figtree", size: size)
    }

    static func semiBold(_ size: CGFloat) -> Font {
        .custom("Figtree", size: size).weight(.semibold)
    }

    static func extraBold(_ size: CGFloat) -> Font {
        .custom("Figtree", size: size).weight(.black)
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
