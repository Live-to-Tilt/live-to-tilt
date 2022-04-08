import SwiftUI

struct GameModePicker: View {
    @Binding var selectedGameMode: GameMode

    var body: some View {
        HStack {
            ForEach(GameMode.allCases) { gameMode in
                GameModeButton(gameMode: gameMode)
            }
        }
        .padding(15)
        .border(.white, width: 5)
    }

    private func GameModeButton(gameMode: GameMode) -> some View {
        Button(action: { selectedGameMode = gameMode }) {
            Text(gameMode.emoji)
                .font(.system(size: 48))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(selectedGameMode == gameMode ? Color(red: 0.84, green: 0.24, blue: 0.20) : .clear)
        }
    }
}

struct GameModePicker_Previews: PreviewProvider {
    static var previews: some View {
        GameModePicker(selectedGameMode: .constant(.survival))
    }
}
