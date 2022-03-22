import SwiftUI

struct RootView: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .black, location: 0.28),
                    .init(color: Color(red: 0.25, green: 0.25, blue: 0.25), location: 1)
                ]), startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()

            content
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
