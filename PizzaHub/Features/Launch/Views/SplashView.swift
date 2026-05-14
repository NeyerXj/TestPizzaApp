import SwiftUI
import UIKit

struct SplashView: View {
    let imageURL: URL
    let onCompleted: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var imageLoader = RemoteImageLoader()
    @State private var visibleSliceCount = 0
    @State private var pulse = false
    @State private var didComplete = false

    private let sliceCount = 8

    var body: some View {
        DesignedCanvas {
            ZStack {
                Color.white

                ZStack {
                    if let splashImage {
                        ForEach(0..<sliceCount, id: \.self) { sliceIndex in
                            SplashPizzaSlice(
                                image: Image(uiImage: splashImage),
                                sliceIndex: sliceIndex,
                                sliceCount: sliceCount,
                                isVisible: sliceIndex < visibleSliceCount
                            )
                        }
                    } else {
                        ProgressView()
                            .tint(PizzaDesign.accent)
                    }
                }
                .frame(width: 270, height: 270)
                .scaleEffect(pulse ? 1.02 : 1)
                .position(x: 187.5, y: 407)
                .shadow(color: Color.black.opacity(0.12), radius: 14, x: 0, y: 8)
            }
            .frame(width: 375, height: 812)
            .task {
                await runPreloader()
            }
        }
    }

    private func runPreloader() async {
        visibleSliceCount = 0
        pulse = false
        didComplete = false

        if UIImage(named: "SplashPizza") == nil {
            await imageLoader.load(from: imageURL)
        }

        guard splashImage != nil else {
            completeOnce()
            return
        }

        await animateSlices()
        completeOnce()
    }

    private func animateSlices() async {
        if reduceMotion {
            visibleSliceCount = sliceCount
            try? await Task.sleep(for: .milliseconds(700))
            return
        }

        visibleSliceCount = 0

        withAnimation(.snappy(duration: 0.28)) {
            visibleSliceCount = 1
        }

        for sliceNumber in 2...sliceCount {
            try? await Task.sleep(for: .milliseconds(145))

            withAnimation(.snappy(duration: 0.32)) {
                visibleSliceCount = sliceNumber
            }
        }

        withAnimation(.smooth(duration: 0.65).repeatForever(autoreverses: true)) {
            pulse = true
        }

        try? await Task.sleep(for: .milliseconds(450))
    }

    private func completeOnce() {
        guard !didComplete else {
            return
        }

        didComplete = true
        onCompleted()
    }

    private var splashImage: UIImage? {
        UIImage(named: "SplashPizza") ?? imageLoader.image
    }
}

private struct SplashPizzaSlice: View {
    let image: Image
    let sliceIndex: Int
    let sliceCount: Int
    let isVisible: Bool

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 270, height: 270)
            .clipShape(PizzaSliceShape(index: sliceIndex, total: sliceCount, gapDegrees: 2.6))
            .offset(isVisible ? .zero : entryOffset)
            .opacity(isVisible ? 1 : 0)
            .rotationEffect(.degrees(isVisible ? 0 : entryRotation))
        .frame(width: 270, height: 270)
    }

    private var entryOffset: CGSize {
        let angle = (Double(sliceIndex) + 0.5) * 360 / Double(sliceCount) - 90
        let radians = angle * .pi / 180
        return CGSize(width: cos(radians) * 28, height: sin(radians) * 28)
    }

    private var entryRotation: Double {
        sliceIndex.isMultiple(of: 2) ? -8 : 8
    }
}

private struct PizzaSliceShape: Shape {
    let index: Int
    let total: Int
    let gapDegrees: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let segment = 360 / Double(total)
        let start = -90 + Double(index) * segment + gapDegrees
        let end = -90 + Double(index + 1) * segment - gapDegrees

        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(start),
            endAngle: .degrees(end),
            clockwise: false
        )
        path.closeSubpath()

        return path
    }
}
