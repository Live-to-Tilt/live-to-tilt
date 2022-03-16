import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        VStack {
            Text("Settings")

            Text("Volume")
            Slider(value: $viewModel.soundtrackVolume,
                   in: CGFloat(Constants.minSoundtrackVolume)...CGFloat(Constants.maxSoundtrackVolume))

            Text("Controls")
            Picker("Controls", selection: $viewModel.gameControlType) {
                ForEach(GameControlManager.GameControlType.allCases) { gameControlType in
                    Text(gameControlType.rawValue)
                }
            }
            .pickerStyle(.segmented)
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
