import Foundation

extension Bundle {
    func secret(secretsKey: SecretsKey) -> String? {
        object(forInfoDictionaryKey: secretsKey.rawValue) as? String
    }
}
