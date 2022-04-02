enum GameMode: String, CaseIterable, Identifiable {
    case survival = "Survival"
    case gauntlet = "Gauntlet"

    var id: Self { self }
}

extension GameMode {
    var emoji: String {
        switch self {
        case .survival:
            return "☠️"
        case .gauntlet:
            return "⚔️"
        }
    }

    var description: String {
        switch self {
        case .survival:
            return """
                Use flashy powerups to defeat endless waves of enemies. \
                How long can you survive?
                """
        case .gauntlet:
            return """
                Think Flappy Bird, but Live to Tilt. Put your fine control skills \
                to the test as you weave through complex enemy formations!
                """
        }
    }
}
