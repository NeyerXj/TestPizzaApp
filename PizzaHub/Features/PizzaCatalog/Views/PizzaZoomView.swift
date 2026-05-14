import SwiftUI

struct PizzaZoomView: View {
    let pizza: Pizza
    let onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var baseScale: CGFloat = 2.25
    @State private var gestureScale: CGFloat = 1
    @State private var baseOffset: CGSize = .zero
    @GestureState private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.white
                .ignoresSafeArea()

            Circle()
                .fill(PizzaDesign.highlight)
                .frame(width: 607, height: 607)
                .position(x: 187.5, y: 220.5)

            CachedRemoteImage(url: pizza.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 310, height: 310)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .scaleEffect(clampedScale)
                    .offset(
                        x: baseOffset.width + dragOffset.width,
                        y: baseOffset.height + dragOffset.height
                    )
                    .position(x: 187.5, y: 315)
                    .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 8)
                    .gesture(zoomGesture)
                    .simultaneousGesture(panGesture)
            }

            CircleIconButton(systemName: "chevron.left", accessibilityLabel: "Close detail", action: onClose)
                .position(x: 48, y: 86)
        }
        .frame(width: 375, height: 812)
        .clipped()
        .onTapGesture(count: 2) {
            withAnimation(reduceMotion ? .none : .snappy(duration: 0.25)) {
                baseScale = baseScale > 2.3 ? 1.35 : 2.6
                baseOffset = .zero
            }
        }
    }

    private var clampedScale: CGFloat {
        min(max(baseScale * gestureScale, 1.15), 4)
    }

    private var zoomGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                gestureScale = value
            }
            .onEnded { value in
                baseScale = min(max(baseScale * value, 1.15), 4)
                gestureScale = 1
            }
    }

    private var panGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .updating($dragOffset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                let nextWidth = baseOffset.width + value.translation.width
                let nextHeight = baseOffset.height + value.translation.height
                baseOffset = CGSize(
                    width: min(max(nextWidth, -160), 160),
                    height: min(max(nextHeight, -220), 220)
                )
            }
    }
}
