import Foundation
import Observation
import UIKit

@MainActor
@Observable
final class RemoteImageLoader {
    private static let memoryCache = NSCache<NSURL, UIImage>()

    private(set) var image: UIImage?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private var loadedURL: URL?

    func load(from url: URL?) async {
        guard let url else {
            image = nil
            errorMessage = nil
            loadedURL = nil
            return
        }

        if loadedURL == url, image != nil {
            return
        }

        let cacheKey = url as NSURL
        if let cachedImage = Self.memoryCache.object(forKey: cacheKey) {
            image = cachedImage
            errorMessage = nil
            loadedURL = url
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
            let (imageBytes, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                throw RemoteImageError.httpStatus(httpResponse.statusCode)
            }

            guard let downloadedImage = UIImage(data: imageBytes) else {
                throw RemoteImageError.invalidImage
            }

            Self.memoryCache.setObject(downloadedImage, forKey: cacheKey)
            image = downloadedImage
            loadedURL = url
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

enum RemoteImageError: LocalizedError {
    case invalidImage
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            "Image data is invalid."
        case .httpStatus(let statusCode):
            "Image request returned status \(statusCode)."
        }
    }
}
