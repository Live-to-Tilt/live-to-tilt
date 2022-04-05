import Foundation

extension Float {
    private static var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()

    func toTimeString() -> String {
        Float.timeFormatter.string(from: TimeInterval(self)) ?? "0:00"
    }
}
