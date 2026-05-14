import SwiftUI

struct SizeSelectorView: View {
    let selectedSize: PizzaSize
    let onSelect: (PizzaSize) -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            ForEach(PizzaSize.allCases) { size in
                let selected = size == selectedSize

                Button {
                    withAnimation(reduceMotion ? .none : .snappy(duration: 0.32)) {
                        onSelect(size)
                    }
                } label: {
                    Text(size.rawValue)
                        .font(PizzaTypography.semiBold(18))
                        .tracking(-0.36)
                        .foregroundStyle(selected ? Color.white : Color.black)
                        .frame(width: 48, height: 48)
                        .background(selected ? Color.black : Color.white)
                        .clipShape(Circle())
                        .overlay {
                            if selected {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            }
                        }
                        .shadow(color: selected ? Color.clear : PizzaDesign.shadow, radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .position(x: xPosition(for: size), y: selected ? 40 : 24)
                .zIndex(selected ? 2 : 1)
                .accessibilityLabel("Size \(size.rawValue)")
            }
        }
        .frame(width: 244, height: 64)
        .animation(reduceMotion ? .none : .snappy(duration: 0.32), value: selectedSize)
    }

    private func xPosition(for size: PizzaSize) -> CGFloat {
        switch size {
        case .small:
            24
        case .medium:
            122
        case .large:
            220
        }
    }
}
