import Foundation

extension UserDefaults {
    func register(defaults: [UserDefaultsKey: Any]) {
        register(defaults: defaults.reduce(into: [:], {result, x in
            result[x.key.rawValue] = x.value
        }))
    }

    func setValue(_ value: Any?, forKey: UserDefaultsKey) {
        setValue(value, forKey: forKey.rawValue)
    }

    func float(forKey: UserDefaultsKey) -> Float {
        float(forKey: forKey.rawValue)
    }
}
