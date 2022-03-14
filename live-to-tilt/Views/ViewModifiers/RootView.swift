import SwiftUI

struct RootView: ViewModifier {
    func body(content: Content) -> some View {
        NavigationView {
            ZStack {
                Color.LTPrimaryBackground.ignoresSafeArea()

                content
            }
        }
        .font(.system(size: 24))
        .foregroundColor(.LTForeground)
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
