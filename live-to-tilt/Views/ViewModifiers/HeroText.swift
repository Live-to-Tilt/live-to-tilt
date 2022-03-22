import SwiftUI

struct HeroText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 120, weight: .heavy))
            .foregroundColor(.white)
            .shadow(color: .white.opacity(0.25), radius: 20, x: 0, y: 1)
    }
}
