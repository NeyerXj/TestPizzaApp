import Foundation

struct PizzaAPIClient: Sendable {
    nonisolated static let endpoint = URL(string: "https://oursongapp.com/api/pizzas")!
    nonisolated static let splashImageURL = URL(string: "https://oursongapp.com/images/pizzas/pizza_pepperoni_blast.png")!

    let endpoint: URL

    nonisolated init(endpoint: URL = PizzaAPIClient.endpoint) {
        self.endpoint = endpoint
    }

    func fetchPizzas() async throws -> [Pizza] {
        let (responseBytes, urlResponse) = try await URLSession.shared.data(from: endpoint)

        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw PizzaAPIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw PizzaAPIError.httpStatus(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(PizzaResponse.self, from: responseBytes).pizzas
    }
}

enum PizzaAPIError: LocalizedError, Equatable {
    case invalidResponse
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid server response."
        case .httpStatus(let statusCode):
            "Server returned status \(statusCode)."
        }
    }
}
