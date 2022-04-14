import Combine
import Foundation

class HostMessageHandlerDelegate: MessageHandlerDelegate, ObservableObject {
    @Published var renderableComponents: [RenderableComponent]

    // Publishers
    let renderableSubject = PassthroughSubject<[RenderableComponent], Never>()
    var renderablePublisher: AnyPublisher<[RenderableComponent], Never> {
        renderableSubject.eraseToAnyPublisher()
    }

    init() {
        self.renderableComponents = []
    }

    func onReceive(data: Data) {
        do {
            let hostMessage = try JSONDecoder().decode(HostMessage.self, from: data)
            let renderableComponents = hostMessage.renderableComponents
            renderableSubject.send(renderableComponents)
        } catch {
            print(error.localizedDescription)
        }
    }
}
