import SwiftUI

struct RootView: ViewModifier {
    func body(content: Content) -> some View {
        NavigationView {
            ZStack {
                Color.LTPrimaryBackground.ignoresSafeArea()

                content
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
