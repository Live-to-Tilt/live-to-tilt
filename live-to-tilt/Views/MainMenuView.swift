import SwiftUI

struct MainMenuView: View {
    @StateObject var viewModel = MainMenuViewModel()

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
    }

    private func Content() -> some View {
        HStack {
            Spacer()
            Spacer()
            Spacer()

            VStack(alignment: .trailing) {
                Text("live to tilt")
                    .modifier(HeroText())
                    .padding(.bottom, 40)

                NavigationLink(destination: LazyView(
                    GameModeSelectionView()
                )) {
                    Text("start").modifier(MenuItemText())
                }

                // TODO: Link to how to play screen
                Text("how to play").modifier(MenuItemText())

                NavigationLink(destination: LazyView(
                    SettingsView()
                )) {
                    Text("settings").modifier(MenuItemText())
                }
            }

            Spacer()
        }
        .rotationEffect(.degrees(15))
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
