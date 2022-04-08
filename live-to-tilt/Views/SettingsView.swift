import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            SubViewHeader(title: "Settings", closeButtonAction: { self.presentationMode.wrappedValue.dismiss() })

            VolumeSettingHStack()

            SensitivitySettingHStack()

            ControlsSettingHStack()
        }
        .frame(width: 500)
        .modifier(RootView())
    }

    private func VolumeSettingHStack() -> some View {
        HStack {
            Text("Volume").modifier(HeadingOneText())

            Slider(value: $viewModel.soundtrackVolume,
                   in: CGFloat(Constants.minSoundtrackVolume)...CGFloat(Constants.maxSoundtrackVolume))
                .padding()
        }
    }

    private func SensitivitySettingHStack() -> some View {
        HStack {
            Text("Sensitivity").modifier(HeadingOneText())

            Slider(value: $viewModel.sensitivity,
                   in: CGFloat(Constants.minSensitivity)...CGFloat(Constants.maxSensitivity))
                .padding()
        }
    }

    private func ControlsSettingHStack() -> some View {
        HStack {
            VStack {
                Text("Controls").modifier(HeadingOneText())
            }

            Picker("Controls", selection: $viewModel.gameControlType) {
                ForEach(GameControlManager.GameControlType.allCases) { gameControlType in
                    Text(gameControlType.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.trailing, 10)
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
