import SwiftUI

struct ParagraphText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 24, weight: .bold))
            .foregroundColor(.LTForeground)
    }
}
