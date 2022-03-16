import SwiftUI

struct RoundedContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.LTSecondaryBackground)
            .cornerRadius(10)
    }
}
