import SwiftUI

struct CachedRemoteImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    @State private var loader = RemoteImageLoader()

    var body: some View {
        Group {
            if let downloadedImage = loader.image {
                content(Image(uiImage: downloadedImage))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loader.load(from: url)
        }
    }
}

extension CachedRemoteImage where Placeholder == Color {
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content) {
        self.url = url
        self.content = content
        self.placeholder = {
            Color.white.opacity(0.001)
        }
    }
}
