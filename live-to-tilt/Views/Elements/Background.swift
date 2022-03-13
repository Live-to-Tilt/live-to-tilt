import SwiftUI

struct Background: View {
    var body: some View {
        Color.LTPrimaryBackground.ignoresSafeArea()
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
