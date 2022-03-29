import SwiftUI

struct MenuLayout: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()

            VStack {
                Spacer()

                content

                Spacer()
            }
            .rotationEffect(.degrees(-10))

            Spacer()
        }
        .background(.black.opacity(0.7))
    }
}
