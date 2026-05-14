import SwiftUI

@main
struct PizzaHubApp: App {
    init() {
        PizzaFontRegistrar.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
