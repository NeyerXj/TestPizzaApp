import SwiftUI

struct CircleIconButton: View {
    let systemName: String
    let accessibilityLabel: String
    let action: () -> Void

    init(systemName: String, accessibilityLabel: String? = nil, action: @escaping () -> Void) {
        self.systemName = systemName
        self.accessibilityLabel = accessibilityLabel ?? (systemName == "heart" ? "Like" : "Back")
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 21, weight: .medium))
                .foregroundStyle(Color.black)
                .frame(width: 48, height: 48)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: PizzaDesign.shadow, radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

struct StatusBarReplica: View {
    var body: some View {
        HStack {
            Text("9:41")
                .font(PizzaTypography.regular(15))
                .foregroundStyle(Color.white)
                .tracking(-0.24)

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "cellularbars")
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(Color.white)
        }
        .padding(.horizontal, 21)
        .frame(width: 375, height: 44)
    }
}

struct TopNavigationBar: View {
    let title: String

    var body: some View {
        ZStack(alignment: .top) {
            StatusBarReplica()

            VStack(spacing: 0) {
                Text("Pizzas")
                    .font(PizzaTypography.regular(10))
                    .foregroundStyle(PizzaDesign.secondaryText)
                    .frame(height: 20)

                Text(title)
                    .font(PizzaTypography.semiBold(24))
                    .foregroundStyle(PizzaDesign.text)
                    .tracking(-0.48)
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                    .frame(width: 220, height: 24)
            }
            .position(x: 187.5, y: 82)

            CircleIconButton(systemName: "chevron.left") { }
                .position(x: 48, y: 86)

            CircleIconButton(systemName: "heart") { }
                .position(x: 327, y: 86)
        }
        .frame(width: 375, height: 128)
    }
}
