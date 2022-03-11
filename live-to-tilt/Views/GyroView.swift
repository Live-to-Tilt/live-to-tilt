import SwiftUI

struct GyroView: View {
    @StateObject var viewModel = GyroViewModel()

    var body: some View {
        Text("x: \(viewModel.x)")
        Text("y: \(viewModel.y)")
    }
}

struct GyroView_Previews: PreviewProvider {
    static var previews: some View {
        GyroView()
    }
}
