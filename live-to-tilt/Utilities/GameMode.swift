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
            return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec venenatis semper dolor, ut ultricies enim gravida laoreet."
        case .gauntlet:
            return "Quisque posuere, orci at gravida tincidunt, tellus ligula ornare justo, id pharetra nisl erat et sapien."
        }
    }
}
