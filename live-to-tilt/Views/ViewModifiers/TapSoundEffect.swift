import SwiftUI

struct TapSoundEffect: ViewModifier {
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                 TapGesture().onEnded {
                     AudioController.shared.play(.pop)
                 }
            )
    }
}
