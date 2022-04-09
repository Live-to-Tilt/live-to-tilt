import SwiftUI

struct CountdownInnerBar: ViewModifier {
    var timeLeft: CGFloat
    var maxTime: CGFloat

    func body(content: Content) -> some View {
        content
            .foregroundColor(getColor(timeLeft: timeLeft,
                                      maxTime: maxTime))
            .frame(width: getWidth(timeLeft: timeLeft,
                                   maxTime: maxTime),
                   height: 12)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
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

    private func getWidth(timeLeft: CGFloat, maxTime: CGFloat) -> CGFloat {
        492 * timeLeft / maxTime
    }
}
