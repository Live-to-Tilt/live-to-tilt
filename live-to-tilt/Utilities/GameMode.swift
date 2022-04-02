enum GameMode: String, CaseIterable, Identifiable {
    case survival
    case gauntlet

    var id: Self { self }
}
