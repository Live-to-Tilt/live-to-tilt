import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    var body: some View {
        VStack {
            Text("Settings")
            Slider(value: $viewModel.soundtrackVolume,
                   in: CGFloat(Constants.minSoundtrackVolume)...CGFloat(Constants.maxSoundtrackVolume))
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
