import Foundation

extension Int {
    private static var commaFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    func withCommas() -> String {
        Int.commaFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
