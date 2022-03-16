import SwiftUI

struct CapsuleText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 10,
                                leading: 80,
                                bottom: 10,
                                trailing: 80))
            .font(.system(size: 50))
            .background(Color.LTSecondaryBackground)
            .clipShape(Capsule())
    }
}
