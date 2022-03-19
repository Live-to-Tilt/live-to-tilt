import Combine

class MainMenuViewModel: ObservableObject {
    func onAppear() {
        AudioController.shared.play(.theme)
    }
}
