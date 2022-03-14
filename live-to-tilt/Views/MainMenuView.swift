import SwiftUI

struct MainMenuView: View {
    var body: some View {
        ZStack {
            Background()

            VStack {
                Text("Live to Tilt").modifier(TitleText())

                NavigationLink(destination: GameArenaView()) {
                    Text("Play").modifier(CapsuleText())
                }

                NavigationLink(destination: SettingsView()) {
                    Text("Settings").modifier(CapsuleText())
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
