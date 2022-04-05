import Foundation

extension Float {
    func toTimeString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter.string(from: TimeInterval(self)) ?? "0:00"
    }
}
