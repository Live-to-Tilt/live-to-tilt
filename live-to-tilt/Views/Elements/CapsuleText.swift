import SwiftUI

struct CapsuleText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .padding([.leading, .trailing], 80)
            .padding([.top, .bottom], 10)
            .font(.system(size: 50))
            .foregroundColor(.LTForeground)
            .background(Color.LTSecondaryBackground)
            .clipShape(Capsule())
    }
}

struct CapsuleText_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleText("Preview Text")
    }
}
