import SwiftUI
import AlertToast

struct SingleplayerGameArenaView: View {
    @ObservedObject var viewModel: SingleplayerGameArenaViewModel

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
            ToastsView()
        }
    }

    private func TopInfoBar() -> some View {
        HStack {
            Text("wave #\(viewModel.gameEngine.gameStats.wave)").modifier(InfoText())
            Spacer()
            Text("👑 \(AllTimeStats.shared.getHighScore(for: viewModel.gameEngine.gameMode))")
                .modifier(InfoText())
        }

    }

    private func ToastsView() -> some View {
        VStack {
            Rectangle()
                .foregroundColor(Color.black.opacity(0.01))
                .frame(maxWidth: .infinity, maxHeight: 75)
                .toast(isPresenting: $viewModel.showAchievement, duration: 2, alert: {
                    AlertToast(type: .regular,
                               title: "Achievement Unlocked: " +
                               "\(viewModel.achievement?.name ?? "empty")!")
                }, completion: {
                    viewModel.nextAchievement()
                })
            Spacer()
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
        Group {
            switch viewModel.gameEngine.gameMode {
            case .survival:
                Combo()
            case .gauntlet:
                CountdownBar()
            default:
                EmptyView()
            }
        }
    }

    private func Score() -> some View {
        Text("\(viewModel.gameEngine.gameStats.getBackdropValue())")
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

    private func Combo() -> some View {
        let comboBase = viewModel.comboComponent?.base ?? 0
        let comboMultiplier = viewModel.comboComponent?.multiplier ?? 0

        return Text("combo \(comboBase) x \(comboMultiplier)")
            .modifier(InfoText())
            .multilineTextAlignment(.center)
    }

    private func CountdownBar() -> some View {
        let timeLeft = viewModel.countdownComponent?.timeLeft ?? 0
        let maxTime = viewModel.countdownComponent?.maxTime ?? 0

        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: geometry.size.width)

                RoundedRectangle(cornerRadius: 20)
                    .modifier(CountdownInnerBar(size: geometry.size,
                                                timeLeft: timeLeft,
                                                maxTime: maxTime))
            }
        }
        .frame(height: 20)
    }
}

struct GameArenaView_Previews: PreviewProvider {
    static var previews: some View {
        SingleplayerGameArenaView(viewModel: SingleplayerGameArenaViewModel(gameMode: .survival))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
