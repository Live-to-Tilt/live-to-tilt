import SwiftUI

struct FirstAppear: ViewModifier {
    let perform:() -> Void
    @State private var isFirst = true

    func body(content: Content) -> some View {
        content
            .onAppear {
                if isFirst {
                    isFirst = false
                    self.perform()
                }
            }
        }
}

extension View {
    func onFirstAppear (perform: @escaping () -> Void) -> some View {
        modifier(FirstAppear(perform: perform))
    }
}
