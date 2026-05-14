import SwiftUI

struct BananaHintView: View {
    var body: some View {
        ZStack {
            Text("B a n a n a   f o r   s c a l e")
                .font(PizzaTypography.regular(7))
                .foregroundStyle(Color.black)
                .rotationEffect(.degrees(-28))
                .offset(y: -29)

            BananaShape()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: 0xF9DB48), Color(hex: 0xF2B720)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 88, height: 46)
                .overlay {
                    BananaShape()
                        .stroke(Color.black.opacity(0.25), lineWidth: 1)
                }
                .rotationEffect(.degrees(8))

            Circle()
                .fill(Color(hex: 0x5D7D20))
                .frame(width: 8, height: 8)
                .offset(x: 35, y: 8)
        }
        .frame(width: 97, height: 63)
    }
}

struct BananaShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: width * 0.05, y: height * 0.52))
        path.addCurve(
            to: CGPoint(x: width * 0.9, y: height * 0.33),
            control1: CGPoint(x: width * 0.28, y: height * 1.02),
            control2: CGPoint(x: width * 0.72, y: height * 0.88)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.1, y: height * 0.24),
            control1: CGPoint(x: width * 0.66, y: height * 0.58),
            control2: CGPoint(x: width * 0.34, y: height * 0.48)
        )
        path.closeSubpath()

        return path
    }
}
