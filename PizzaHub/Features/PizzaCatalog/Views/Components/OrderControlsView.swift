import SwiftUI

struct OrderControlsView: View {
    let quantity: Int
    let totalPrice: String
    let onDecrease: () -> Void
    let onIncrease: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                quantityButton(systemName: "minus", action: onDecrease)
                    .opacity(quantity == 1 ? 0.55 : 1)

                Text("\(quantity)")
                    .font(PizzaTypography.extraBold(24))
                    .foregroundStyle(Color.black)
                    .frame(width: 47, height: 48)
                    .contentTransition(.numericText())
                    .animation(reduceMotion ? .none : .snappy(duration: 0.22), value: quantity)

                quantityButton(systemName: "plus", action: onIncrease)
            }
            .frame(width: 143, height: 48)
            .background(PizzaDesign.highlight)
            .clipShape(Capsule())

            Text(totalPrice)
                .font(PizzaTypography.extraBold(24))
                .foregroundStyle(Color.black)
                .frame(width: 100, height: 44)
                .lineLimit(1)
                .minimumScaleFactor(0.76)
                .contentTransition(.numericText())
                .animation(reduceMotion ? .none : .snappy(duration: 0.24), value: totalPrice)

            Button { } label: {
                Text("Add")
                    .font(PizzaTypography.extraBold(24))
                    .foregroundStyle(Color.white)
                    .frame(width: 83, height: 48)
                    .background(PizzaDesign.accent)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Add")
        }
        .frame(width: 326, height: 48)
    }

    private func quantityButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 22, weight: .regular))
                .foregroundStyle(Color.black)
                .frame(width: 48, height: 48)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: PizzaDesign.shadow, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(systemName == "plus" ? "Increase quantity" : "Decrease quantity")
    }
}
