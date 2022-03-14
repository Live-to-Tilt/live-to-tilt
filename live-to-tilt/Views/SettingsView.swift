import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    // Navigation
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Settings").modifier(TitleText())

            HStack {
                Text("Volume").modifier(HeadingOneText())

                Slider(value: $viewModel.soundtrackVolume,
                       in: CGFloat(Constants.minSoundtrackVolume)...CGFloat(Constants.maxSoundtrackVolume),
                       label: { Text("Volume") },
                       minimumValueLabel: { Text("0") },
                       maximumValueLabel: { Text("100") })
                    .padding()
            }
            .modifier(RoundedContainer())
            .frame(width: 500)

            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Back")
                    .modifier(CapsuleText())
                    .padding(.top, 40)
            }
        }
        .modifier(RootView())
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
