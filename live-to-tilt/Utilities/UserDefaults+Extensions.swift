import Foundation

extension UserDefaults {
    func register(defaults: [UserDefaultsKey: Any]) {
        register(defaults: defaults.reduce(into: [:], {result, x in
            result[x.key.rawValue] = x.value
        }))
    }

    func setValue(_ value: Any?, forKey defaultName: UserDefaultsKey) {
        setValue(value, forKey: defaultName.rawValue)
    }

    func integer(forKey defaultName: UserDefaultsKey) -> Int {
        integer(forKey: defaultName.rawValue)
    }

    func float(forKey defaultName: UserDefaultsKey) -> Float {
        float(forKey: defaultName.rawValue)
    }

    func string(forKey defaultName: UserDefaultsKey) -> String? {
        string(forKey: defaultName.rawValue)
    }

    func data(forKey defaultName: UserDefaultsKey) -> Data? {
        data(forKey: defaultName.rawValue)
    }
}
