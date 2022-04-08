import SwiftUI

struct HowToPlayView: View {
    @State var selectedGameMode: GameMode = .survival
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            HStack {
                Text("How to Play")
                    .modifier(TitleText())

                Spacer()

                CloseButton(action: { self.presentationMode.wrappedValue.dismiss() })
            }

            GameModePicker(selectedGameMode: $selectedGameMode)

            Text(selectedGameMode.rawValue).modifier(HeadingOneText())

            Instructions()

        }
        .frame(width: 700)
        .modifier(RootView())
    }

    private func Instructions() -> some View {
        VStack(alignment: .leading) {
            ForEach(selectedGameMode.instructions, id: \.self) { instruction in
                HStack {
                    Image(instruction.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75)
                        .background(.brown)

                    Text(instruction.text)
                        .font(.system(size: 24))
                        .padding(.leading, 10)
                }
            }
        }
        .frame(width: 600, alignment: .leading)
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
