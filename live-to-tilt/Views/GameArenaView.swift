import SwiftUI

struct GameArenaView: View {
    @ObservedObject var viewModel: GameArenaViewModel

    // Navigation
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            InfoHStack()
            PlayAreaView()
            GameControlView(gameControl: $viewModel.gameControl)
        }
        .padding()
        .modifier(RootView())
    }

    private func InfoHStack() -> some View {
        HStack {
            Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                Text("Quit")
                    .modifier(CapsuleText())
            }

            HStack {
                Text("Score: 100").modifier(HeadingOneText())
            }
            .modifier(RoundedContainer())

            HStack {
                Text("Combo: 50x12").modifier(HeadingOneText())
            }
            .modifier(RoundedContainer())

            Spacer()

            Text("Achievement")
                .modifier(HeadingOneText())
                .modifier(RoundedContainer())
        }
    }

    private func PlayAreaView() -> some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)

            let normalization = CGAffineTransform(scaleX: 1 / frame.maxY, y: 1 / frame.maxY)
            let denormalization = normalization.inverted()

            ZStack {
                ForEach(viewModel.renderableComponents, id: \.id) { renderableComponent in
                    EntityView(from: renderableComponent, applying: denormalization)
                }
            }
            .background(Color.LTSecondaryBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 5)
            )
            .frame(width: geometry.size.height * Constants.gameArenaAspectRatio, height: geometry.size.height)
            .position(x: frame.midX, y: frame.midY)
        }
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
