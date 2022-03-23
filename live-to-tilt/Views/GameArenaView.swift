import SwiftUI

struct GameArenaView: View {
    @ObservedObject var viewModel: GameArenaViewModel

    // Navigation
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                InfoHStack()
                PlayAreaView()
                GameControlView(gameControl: $viewModel.gameControl)
            }
            .padding()
            .modifier(RootView())

            if viewModel.gameStateComponent?.state == .gameOver {
                Button(action: { viewModel.restart() }) {
                    Text("Restart")
                }
            }
        }
    }

    private func InfoHStack() -> some View {
        HStack {
            // TODO: Remove later
            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Quit")
            }

            Text("wave 10").modifier(InfoText())
            Spacer()
            Text("combo x234").modifier(InfoText())
        }
    }

    private func PlayAreaView() -> some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)

            let normalization = CGAffineTransform(scaleX: 1 / frame.maxY, y: 1 / frame.maxY)
            let denormalization = normalization.inverted()

            ZStack {
                Score()

                ForEach(viewModel.renderableComponents, id: \.id) { renderableComponent in
                    EntityView(from: renderableComponent, applying: denormalization)
                }
            }
            .frame(width: geometry.size.height * Constants.gameArenaAspectRatio, height: geometry.size.height)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 5)
            )
            .position(x: frame.midX, y: frame.midY)
        }
    }

    private func Score() -> some View {
        let score = 12_345
        return Text("\(score)")
            .font(.system(size: 200, weight: .heavy))
            .monospacedDigit()
            .opacity(0.15)
    }

    // Creates a view that represents an Entity using the Entity's RenderableComponent
    private func EntityView(
        from renderable: RenderableComponent,
        applying denormalization: CGAffineTransform) -> some View {
        let actualSize = renderable.size.applying(denormalization)
        let actualPosition = renderable.position.applying(denormalization)

        return Image(renderable.image.rawValue)
            .resizable()
            .frame(width: actualSize.width, height: actualSize.height)
            .rotationEffect(.radians(renderable.rotation))
            .position(actualPosition)
            .opacity(renderable.opacity)
            .zIndex(renderable.layer.rawValue)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.2)))
    }
}

struct GameArenaView_Previews: PreviewProvider {
    static var previews: some View {
        GameArenaView(viewModel: GameArenaViewModel())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
