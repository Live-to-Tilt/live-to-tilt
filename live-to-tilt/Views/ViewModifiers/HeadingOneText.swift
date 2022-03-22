import SwiftUI

struct HeadingOneText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 32, weight: .bold))
            .foregroundColor(.white)
    }
}
