import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    // Navigation
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Settings").modifier(TitleText())

            VolumeSettingHStack()

            ControlsSettingHStack()

            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Back")
                    .modifier(CapsuleText())
                    .padding(.top, 40)
            }
            .modifier(RootView())
            .onAppear {
                viewModel.onAppear()
            }
        }
    }

    private func VolumeSettingHStack() -> some View {
        HStack {
            VStack {
                Text("Volume")
                    .modifier(HeadingOneText())
                    .padding(.bottom, -25)

                Text("\(Int(viewModel.soundtrackVolume))")
                    .padding(.bottom, 10)
            }

            Slider(value: $viewModel.soundtrackVolume,
                   in: CGFloat(Constants.minSoundtrackVolume)...CGFloat(Constants.maxSoundtrackVolume),
                   step: 1,
                   label: { Text("Volume") },
                   minimumValueLabel: { Text("\(Int(Constants.minSoundtrackVolume))") },
                   maximumValueLabel: { Text("\(Int(Constants.maxSoundtrackVolume))") })
                .padding()
        }
        .modifier(RoundedContainer())
        .frame(width: 500)
    }

    private func ControlsSettingHStack() -> some View {
        HStack {
            VStack {
                Text("Controls")
                    .modifier(HeadingOneText())
            }

            Picker("Controls", selection: $viewModel.gameControlType) {
                ForEach(GameControlManager.GameControlType.allCases) { gameControlType in
                    Text(gameControlType.rawValue)
                }
            }
            .pickerStyle(.segmented)
        }
        .modifier(RoundedContainer())
        .frame(width: 500)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
