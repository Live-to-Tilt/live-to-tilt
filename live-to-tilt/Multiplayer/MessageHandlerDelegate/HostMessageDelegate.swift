import Combine
import Foundation

class HostMessageDelegate: MessageDelegate, ObservableObject {
    @Published var renderableComponents: [RenderableComponent]

    // TODO: publish host message instead
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
