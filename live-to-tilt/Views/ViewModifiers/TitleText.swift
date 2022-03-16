import SwiftUI

struct TitleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 70, weight: .bold))
    }
}
