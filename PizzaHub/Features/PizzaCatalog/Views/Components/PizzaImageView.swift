import SwiftUI

struct PizzaImageView: View {
    let url: URL
    let dimension: CGFloat
    var clipsToCircle = true

    var body: some View {
        CachedRemoteImage(url: url) { image in
            if clipsToCircle {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: dimension, height: dimension)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
            } else {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: dimension, height: dimension)
                    .clipped()
                    .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 2)
            }
        }
        .frame(width: dimension, height: dimension)
    }
}
