import SwiftUI

struct MainMenuView: View {
    @StateObject var viewModel = MainMenuViewModel()
    @State private var isActive = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                Image("menuBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                Image("menuForeground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()

                Content()
            }
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(.stack)
        .environment(\.rootPresentationMode, self.$isActive)
    }

    private func Content() -> some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()
            Menu()
            Spacer()
        }
        .rotationEffect(.degrees(15))
        .onAppear {
            viewModel.onAppear()
        }
    }

    private func Menu() -> some View {
        VStack(alignment: .trailing) {
            Text("live to tilt")
                .modifier(HeroText())
                .padding(.bottom, 20)

            NavigationLink(destination: LazyView(GameModeSelectionView()),
                           isActive: self.$isActive) {
                Text("start").modifier(MenuItemText())
            }
            .modifier(TapSoundEffect())

            NavigationLink(destination: LazyView(HowToPlayView())) {
                Text("how to play").modifier(MenuItemText())
            }
            .modifier(TapSoundEffect())

            NavigationLink(destination: LazyView(AchievementsView())) {
                Text("achievements").modifier(MenuItemText())
            }
            .modifier(TapSoundEffect())

            NavigationLink(destination: LazyView(SettingsView())) {
                Text("settings").modifier(MenuItemText())
            }
            .modifier(TapSoundEffect())
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
