import SwiftUI

struct DesignedCanvas<Content: View>: View {
    let content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            let scale = min(
                proxy.size.width / PizzaDesign.canvasSize.width,
                proxy.size.height / PizzaDesign.canvasSize.height
            )

            ZStack {
                content()
                    .frame(width: PizzaDesign.canvasSize.width, height: PizzaDesign.canvasSize.height)
                    .scaleEffect(scale)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .background(Color.white)
        }
    }
}
