import Foundation

extension UserDefaults {
    func register(defaults: [Keys: Any]) {
        register(defaults: defaults.reduce(into: [:], {result, x in
            result[x.key.rawValue] = x.value
        }))
    }

    func setValue(_ value: Any?, forKey: Keys) {
        setValue(value, forKey: forKey.rawValue)
    }

    func float(forKey: Keys) -> Float {
        float(forKey: forKey.rawValue)
    }
}
