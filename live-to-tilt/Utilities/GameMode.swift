enum GameMode: String, CaseIterable, Identifiable {
    case survival = "Survival"
    case gauntlet = "Gauntlet"
    case coop = "Co-op"

    var id: Self { self }
}

extension GameMode {
    var emoji: String {
        switch self {
        case .survival:
            return "☠️"
        case .gauntlet:
            return "⚔️"
        case .coop:
            return "👥"
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
        case .coop:
            return """
                Survival mode, but with a friend!
                """
        }
    }

    var instructions: [Instruction] {
        switch self {
        case .survival:
            return [
                Instruction(image: "playerInstruction",
                            text: "This is You, the hero of the game. Tilt to move You."),
                Instruction(image: "enemyInstruction",
                            text: "The only good red dot is a dead one."),
                Instruction(image: "powerupInstruction",
                            text: "Orbs are weapons. Use them to express yourself."),
                Instruction(image: "comboInstruction",
                            text: "Kill dots back-to-back to multiply your score.")
            ]
        case .gauntlet:
            return [
                Instruction(image: "playerInstruction",
                            text: "This is You, the hero of the game. Tilt to move You."),
                Instruction(image: "enemyInstruction",
                            text: "Hit a dot, lose your life. You can't kill dots in this mode."),
                Instruction(image: "timerInstruction",
                            text: "Orbs will extend your life bar at the bottom."),
                Instruction(image: "lifebarInstruction",
                            text: "If your life bar runs out, it's game over.")
            ]
        case .coop:
            return []
        }
    }

    struct Instruction: Hashable {
        let image: String
        let text: String
    }
}
