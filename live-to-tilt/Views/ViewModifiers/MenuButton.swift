import SwiftUI

struct MenuButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .padding()
            .contentShape(Rectangle())
            .frame(width: 400)
            .background(.black)
            .foregroundColor(.white)
            .border(.white, width: 5)
    }
}
