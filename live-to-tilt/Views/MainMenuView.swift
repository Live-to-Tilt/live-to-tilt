import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Background()

            VStack {
                Text("Live to Tilt")
                    .styleAsTitle()

                NavigationLink(destination: GameArenaView()) {
                    Text("Play")
                        .styleAsCapsule()
                }

                NavigationLink(destination: SettingsView()) {
                    Text("Settings")
                        .styleAsCapsule()
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
