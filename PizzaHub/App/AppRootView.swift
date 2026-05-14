import SwiftUI

struct AppRootView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel = PizzaCatalogViewModel()
    @State private var showsSplash = true
    @State private var catalogLoaded = false
    @State private var splashCompleted = false

    var body: some View {
        ZStack {
            if showsSplash {
                SplashView(imageURL: PizzaAPIClient.splashImageURL) {
                    splashCompleted = true
                    finishLaunchIfReady()
                }
                    .transition(.opacity)
            } else {
                PizzaCatalogView(viewModel: viewModel)
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
        .statusBarHidden(true)
        .task {
            await loadCatalogue()
        }
    }

    private func loadCatalogue() async {
        await viewModel.load()
        catalogLoaded = true
        finishLaunchIfReady()
    }

    private func finishLaunchIfReady() {
        guard catalogLoaded, splashCompleted, showsSplash else {
            return
        }

        withAnimation(reduceMotion ? .none : .smooth(duration: 0.45)) {
            showsSplash = false
        }
    }
}

#Preview {
    AppRootView()
}
