import SwiftUI

struct MultiplayerGameArenaView: View {
    @ObservedObject var viewModel: MultiplayerGameArenaViewModel

    var body: some View {
        ZStack {
            GameControlView(gameControl: $viewModel.gameControl)

            VStack {
                TopInfoBar()
                PlayAreaView()
                BottomInfoBar()
            }
            .padding()
            .modifier(RootView())
            .onTapGesture {
                viewModel.pause()
            }

            if viewModel.gameStateComponent?.state == .gameOver {
                GameOverMenuView(viewModel: viewModel)
            } else if viewModel.gameStateComponent?.state == .pause {
                PauseMenuView(viewModel: viewModel)
            }
        }
    }

    private func TopInfoBar() -> some View {
        HStack {
            Text("wave #\(viewModel.getWaveNumber())").modifier(InfoText())
            Spacer()
            Text("👑 \(AllTimeStats.shared.getHighScore(for: .coop))")
                .modifier(InfoText())
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

    private func BottomInfoBar() -> some View {
        Combo()
    }

    private func Score() -> some View {
        Text("\(viewModel.getScore())")
            .font(.system(size: 200, weight: .heavy))
            .monospacedDigit()
            .opacity(0.15)
    }

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

    private func Combo() -> some View {
        let comboBase = viewModel.comboComponent?.base ?? 0
        let comboMultiplier = viewModel.comboComponent?.multiplier ?? 0

        return Text("combo \(comboBase) x \(comboMultiplier)")
            .modifier(InfoText())
            .multilineTextAlignment(.center)
    }
}

struct MultiplayerGameArenaView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerGameArenaView(viewModel: MultiplayerGameArenaViewModel(roomManager: FirebaseRoomManager(),
                                                                          messageManager: PubNubMessageManager()))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
