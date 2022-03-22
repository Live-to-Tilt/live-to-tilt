import SwiftUI

struct MenuItemText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 2)
            .font(.system(size: 48, weight: .bold))
            .foregroundColor(.white)
    }
}
