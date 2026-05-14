import Foundation
import Observation

@MainActor
@Observable
final class PizzaCatalogViewModel {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var loadState: LoadState = .idle
    private(set) var pizzas: [Pizza] = []

    var selectedPizzaIndex = 0
    var selectedSize: PizzaSize = .medium
    var quantity = 1

    private let apiClient: PizzaAPIClient

    init(apiClient: PizzaAPIClient = PizzaAPIClient()) {
        self.apiClient = apiClient
    }

    var selectedPizza: Pizza? {
        guard pizzas.indices.contains(selectedPizzaIndex) else {
            return nil
        }

        return pizzas[selectedPizzaIndex]
    }

    var selectedVariant: PizzaVariant? {
        selectedPizza?.variant(for: selectedSize)
    }

    var totalPrice: Decimal {
        guard let selectedVariant else {
            return 0
        }

        return selectedVariant.price * Decimal(quantity)
    }

    var formattedTotalPrice: String {
        PriceFormatter.usd.string(from: totalPrice)
    }

    func load() async {
        guard loadState != .loading else {
            return
        }

        loadState = .loading

        do {
            let fetchedPizzas = try await apiClient.fetchPizzas()
            pizzas = fetchedPizzas
            selectedPizzaIndex = 0
            selectedSize = fetchedPizzas.first?.initialSize ?? .medium
            quantity = 1
            loadState = .loaded
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }

    func retry() async {
        await load()
    }

    func selectPizza(at index: Int) {
        guard pizzas.indices.contains(index), index != selectedPizzaIndex else {
            return
        }

        selectedPizzaIndex = index
        selectedSize = pizzas[index].initialSize
        quantity = 1
    }

    func selectSize(_ size: PizzaSize) {
        guard selectedPizza?.variants.contains(where: { $0.size == size }) == true else {
            return
        }

        selectedSize = size
    }

    func increaseQuantity() {
        quantity += 1
    }

    func decreaseQuantity() {
        quantity = max(1, quantity - 1)
    }
}

enum PriceFormatter {
    static let usd: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.positiveFormat = "$#,##0.00"
        formatter.negativeFormat = "-$#,##0.00"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension NumberFormatter {
    func string(from decimal: Decimal) -> String {
        string(from: NSDecimalNumber(decimal: decimal)) ?? "$0.00"
    }
}
