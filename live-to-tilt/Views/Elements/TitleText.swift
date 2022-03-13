import SwiftUI

struct TitleText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .padding()
            .font(.system(size: 70, weight: .bold))
            .foregroundColor(.LTForeground)
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        TitleText("Preview Text")
    }
}
