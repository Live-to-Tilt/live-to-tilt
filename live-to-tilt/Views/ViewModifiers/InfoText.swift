import SwiftUI

struct InfoText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 36, weight: .heavy))
            .foregroundColor(.white)
            .padding(0)
    }
}
