import SwiftUI

struct PickerOption: ViewModifier {
    var isSelected: Bool

    func body(content: Content) -> some View {
        content
            .background(isSelected ? Color(red: 0.84, green: 0.24, blue: 0.20) : .clear)
    }
}
