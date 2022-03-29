import SwiftUI

struct MenuIcon: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 250, weight: .bold))
            .foregroundColor(Color(red: 0.84, green: 0.24, blue: 0.20, opacity: 0.7))
    }
}
