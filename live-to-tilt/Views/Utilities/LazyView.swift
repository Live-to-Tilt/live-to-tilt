import SwiftUI

// https://gist.github.com/chriseidhof/d2fcafb53843df343fe07f3c0dac41d5
struct LazyView<Content: View>: View {
    let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
