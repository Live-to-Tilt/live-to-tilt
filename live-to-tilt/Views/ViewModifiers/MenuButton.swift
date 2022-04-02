import SwiftUI

struct MenuButton: ViewModifier {
    var width: CGFloat = 400

    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .padding()
            .contentShape(Rectangle())
            .frame(width: width)
            .background(.black)
            .foregroundColor(.white)
            .border(.white, width: 5)
    }
}
