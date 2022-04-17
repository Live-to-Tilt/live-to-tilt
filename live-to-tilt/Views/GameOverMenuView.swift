import SwiftUI

struct GameOverMenuView: View {
    var viewModel: Pausable
    @Environment(\.rootPresentationMode) private var rootPresentationMode

    var body: some View {
        Group {
            ZStack {
                Image(systemName: "xmark.circle.fill")
                    .modifier(MenuIcon())

                Text("Game Over").modifier(HeroText())
            }

            Stats()

            Button(action: { viewModel.restart() }) {
                Text("Restart").modifier(MenuButton())
            }
            .modifier(TapSoundEffect())

            Button(action: { self.rootPresentationMode.wrappedValue.dismiss() }) {
                Text("Main Menu").modifier(MenuButton())
            }
            .modifier(TapSoundEffect())
        }.modifier(MenuLayout())
    }

    private func Stats() -> some View {
        let stats = viewModel.getGameOverStats()
        return VStack {
            ForEach(stats, id: \.self) { stat in
                HStack {
                    Text(stat.label)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .frame(width: 190, alignment: .trailing)
                    Text(stat.value)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Color(red: 0.84, green: 0.24, blue: 0.20))
                        .frame(width: 200, alignment: .leading)
                }
            }
        }
        .padding()
        .offset(x: 0, y: -20)
    }
}

struct GameOverMenuView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverMenuView(viewModel: SingleplayerGameArenaViewModel(gameMode: .survival))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
