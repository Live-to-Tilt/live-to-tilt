import CoreGraphics

struct ComboInfo: Codable {
    private let base: Int
    private let multiplier: Int

    init?(comboComponent: ComboComponent?) {
        guard let comboComponent = comboComponent else {
            return nil
        }

        self.base = comboComponent.base
        self.multiplier = comboComponent.multiplier
    }

    func toComboComponent(entity: Entity) -> ComboComponent {
        let comboComponent = ComboComponent(entity: entity,
                                            base: base,
                                            multiplier: multiplier)
        return comboComponent
    }
}
