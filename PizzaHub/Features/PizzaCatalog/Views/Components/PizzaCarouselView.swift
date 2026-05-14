import SwiftUI

struct PizzaCarouselView: View {
    let pizzas: [Pizza]
    let selectedIndex: Int
    let selectedSize: PizzaSize
    let onSelectIndex: (Int) -> Void
    let onZoom: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @GestureState private var dragTranslation: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(Array(pizzas.enumerated()), id: \.element.id) { index, pizza in
                let relativeIndex = index - selectedIndex
                let isSelected = index == selectedIndex
                let dimension = isSelected ? selectedSize.imageDimension : 80

                PizzaImageView(url: pizza.imageURL, dimension: dimension)
                    .opacity(abs(relativeIndex) > 2 ? 0 : 1)
                    .position(
                        x: 187.5 + CGFloat(relativeIndex) * 187.5 + dragTranslation * 0.45,
                        y: 158
                    )
                    .zIndex(isSelected ? 2 : 1)
                    .animation(reduceMotion ? .none : .snappy(duration: 0.35), value: selectedIndex)
                    .animation(reduceMotion ? .none : .snappy(duration: 0.35), value: selectedSize)
            }

            Button(action: onZoom) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 26, height: 26)

                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color.white)
                }
                .frame(width: 88, height: 88)
                .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .position(x: 187.5, y: 158)
            .zIndex(4)
            .accessibilityLabel("Inspect ingredients")
        }
        .frame(width: 375, height: 320)
        .contentShape(Rectangle())
        .gesture(carouselDrag)
    }

    private var carouselDrag: some Gesture {
        DragGesture(minimumDistance: 12)
            .updating($dragTranslation) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                let threshold: CGFloat = 58

                if value.translation.width < -threshold {
                    moveSelection(by: 1)
                } else if value.translation.width > threshold {
                    moveSelection(by: -1)
                }
            }
    }

    private func moveSelection(by step: Int) {
        let nextIndex = min(max(selectedIndex + step, 0), pizzas.count - 1)

        guard nextIndex != selectedIndex else {
            return
        }

        withAnimation(reduceMotion ? .none : .snappy(duration: 0.35)) {
            onSelectIndex(nextIndex)
        }
    }
}
