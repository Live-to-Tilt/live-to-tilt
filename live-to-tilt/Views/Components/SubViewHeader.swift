import SwiftUI

struct SubViewHeader: View {
    var title: String
    var closeButtonAction: () -> Void

    var body: some View {
        HStack {
            Text(title).modifier(TitleText())

            Spacer()

            CloseButton(action: closeButtonAction)
        }
    }
}

struct SubViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        SubViewHeader(title: "Sample Title", closeButtonAction: {})
    }
}
