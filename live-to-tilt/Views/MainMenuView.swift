import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Background()

            VStack {
                TitleText("Live to Tilt")

                NavigationLink(destination: GameArenaView()) {
                    CapsuleText("Play")
                }

                NavigationLink(destination: SettingsView()) {
                    CapsuleText("Settings")
                }
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
