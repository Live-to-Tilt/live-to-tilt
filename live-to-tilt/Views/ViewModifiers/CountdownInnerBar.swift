import SwiftUI

struct CountdownInnerBar: ViewModifier {
    var size: CGSize
    var timeLeft: CGFloat
    var maxTime: CGFloat

    private let padding: CGFloat = 4

    func body(content: Content) -> some View {
        content
            .foregroundColor(getColor(timeLeft: timeLeft,
                                      maxTime: maxTime))
            .frame(width: max(.zero, (size.width - padding * 2) * timeLeft / maxTime),
                   height: size.height - padding * 2)
            .padding(padding)
    }

    private func getColor(timeLeft: CGFloat, maxTime: CGFloat) -> Color {
        if timeLeft > maxTime / 2 {
            return .white
        } else if timeLeft > maxTime / 4 {
            return .orange
        } else {
            return .red
        }
    }
}
