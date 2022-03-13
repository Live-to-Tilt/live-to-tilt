import SwiftUI

struct TestView: View {
    @StateObject var viewModel = TestViewModel()

    var body: some View {
        Text("This is a test view")

        // Insert this view into any view to allow player controls
        GameControlView(gameControl: $viewModel.gameControl)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
