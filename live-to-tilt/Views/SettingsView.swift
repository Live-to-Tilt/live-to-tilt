import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        ZStack {
            Background()

            VStack {
                Text("Settings").modifier(TitleText())

                HStack {
                    Text("Volume").modifier(HeadingOneText())

                    Slider(value: $viewModel.soundtrackVolume,
                           in: CGFloat(Constants.minSoundtrackVolume)...CGFloat(Constants.maxSoundtrackVolume),
                           label: { Text("Volume").modifier(HeadingOneText()) },
                           minimumValueLabel: { Text("0").modifier(ParagraphText()) },
                           maximumValueLabel: { Text("100").modifier(ParagraphText()) })
                }
                .frame(width: 500)

                NavigationLink(destination: MainMenuView()) {
                    Text("Back")
                        .modifier(CapsuleText())
                        .padding(.top, 40)
                }
            }
        }
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
