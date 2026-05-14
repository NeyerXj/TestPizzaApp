import CoreText
import Foundation

enum PizzaFontRegistrar {
    static func registerFonts() {
        guard let fontURL = Bundle.main.url(forResource: "Figtree", withExtension: "ttf") else {
            return
        }

        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
    }
}
