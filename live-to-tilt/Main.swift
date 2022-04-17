import SwiftUI
import Firebase

@main
struct Main: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MainMenuView()
        }
    }
}
