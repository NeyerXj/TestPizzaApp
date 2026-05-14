import SwiftUI

struct PizzaCatalogView: View {
    @Bindable var viewModel: PizzaCatalogViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var showsZoom = false

    var body: some View {
        DesignedCanvas {
            ZStack {
                switch viewModel.loadState {
                case .loaded:
                    if let pizza = viewModel.selectedPizza {
                        catalogContent(for: pizza)
                            .accessibilityHidden(showsZoom)
                    } else {
                        retryContent(message: "No pizzas available.")
                    }
                case .failed(let message):
                    retryContent(message: message)
                case .idle, .loading:
                    ProgressView()
                        .tint(PizzaDesign.accent)
                }

                if let pizza = viewModel.selectedPizza, showsZoom {
                    PizzaZoomView(pizza: pizza) {
                        withAnimation(reduceMotion ? .none : .smooth(duration: 0.28)) {
                            showsZoom = false
                        }
                    }
                    .transition(.opacity.combined(with: .scale(scale: 1.03)))
                    .zIndex(10)
                }
            }
            .frame(width: 375, height: 812)
            .background(Color.white)
            .clipped()
        }
    }

    private func catalogContent(for pizza: Pizza) -> some View {
        ZStack(alignment: .topLeading) {
            Circle()
                .fill(PizzaDesign.highlight)
                .frame(width: 607, height: 607)
                .position(x: 187.5, y: 220.5)

            TopNavigationBar(title: pizza.name)
                .position(x: 187.5, y: 64)

            PizzaCarouselView(
                pizzas: viewModel.pizzas,
                selectedIndex: viewModel.selectedPizzaIndex,
                selectedSize: viewModel.selectedSize,
                onSelectIndex: { index in
                    viewModel.selectPizza(at: index)
                },
                onZoom: {
                    withAnimation(reduceMotion ? .none : .smooth(duration: 0.28)) {
                        showsZoom = true
                    }
                }
            )
            .position(x: 187.5, y: 286)

            BananaHintView()
                .position(x: 187.5, y: 480.5)

            SizeSelectorView(selectedSize: viewModel.selectedSize) { size in
                viewModel.selectSize(size)
            }
            .position(x: 187, y: 516)

            Text(pizza.description)
                .font(PizzaTypography.regular(14))
                .foregroundStyle(Color.black)
                .lineSpacing(5)
                .frame(width: 314, height: 98, alignment: .topLeading)
                .fixedSize(horizontal: false, vertical: true)
                .position(x: 197, y: 618)

            OrderControlsView(
                quantity: viewModel.quantity,
                totalPrice: viewModel.formattedTotalPrice,
                onDecrease: {
                    withAnimation(reduceMotion ? .none : .snappy(duration: 0.22)) {
                        viewModel.decreaseQuantity()
                    }
                },
                onIncrease: {
                    withAnimation(reduceMotion ? .none : .snappy(duration: 0.22)) {
                        viewModel.increaseQuantity()
                    }
                }
            )
            .position(x: 188, y: 731)
        }
        .frame(width: 375, height: 812)
    }

    private func retryContent(message: String) -> some View {
        VStack(spacing: 18) {
            Text("Pizza catalogue is unavailable")
                .font(PizzaTypography.semiBold(24))
                .foregroundStyle(Color.black)

            Text(message)
                .font(PizzaTypography.regular(14))
                .foregroundStyle(PizzaDesign.secondaryText)
                .multilineTextAlignment(.center)
                .frame(width: 280)

            Button {
                Task {
                    await viewModel.retry()
                }
            } label: {
                Text("Retry")
                    .font(PizzaTypography.extraBold(20))
                    .foregroundStyle(Color.white)
                    .frame(width: 140, height: 48)
                    .background(PizzaDesign.accent)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .frame(width: 375, height: 812)
        .background(Color.white)
    }
}
