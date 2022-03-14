import SwiftUI

struct RootView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.LTPrimaryBackground.ignoresSafeArea()

            content
        }
        .font(.system(size: 24))
        .foregroundColor(.LTForeground)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
