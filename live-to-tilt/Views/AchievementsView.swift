import SwiftUI

struct AchievementsView: View {
    var viewModel = AchievementsViewModel()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .local)
            VStack {
                SubViewHeader(title: "Achievements",
                              closeButtonAction: { self.presentationMode.wrappedValue.dismiss() })
                    .frame(width: 0.8 * frame.maxX)
                AchievementsTable(viewModel.achievements)
                    .frame(width: 0.6 * frame.maxX)
            }
            .modifier(RootView())
        }
    }

    private func AchievementsTable(_ achievements: [AchievementDisplay]) -> some View {
        ScrollView {
            ForEach(achievements, id: \.name) { achievement in
                AchievementRow(achievement)
            }
        }
    }

    private func AchievementRow(_ achievement: AchievementDisplay) -> some View {
        HStack {
            Text(achievement.name)
                .modifier(InfoText())
            Spacer()
            if achievement.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.red)
            }
        }
    }
}

struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
.previewInterfaceOrientation(.landscapeRight)
    }
}
