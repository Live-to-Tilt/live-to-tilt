import SwiftUI

extension Text {
    func styleAsTitle() -> some View {
        self
            .padding()
            .font(.system(size: 70, weight: .bold))
            .foregroundColor(.LTForeground)
    }

    func styleAsCapsule() -> some View {
        self
            .padding(EdgeInsets(top: 10,
                                leading: 80,
                                bottom: 10,
                                trailing: 80))
            .font(.system(size: 50))
            .foregroundColor(.LTForeground)
            .background(Color.LTSecondaryBackground)
            .clipShape(Capsule())
    }
}
