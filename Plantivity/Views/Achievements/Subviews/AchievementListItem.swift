import SwiftUI

struct AchievementListItemView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    var achievement: Achievement
    
    var body: some View {
        HStack{
            Image(achievement.isAchieved ? achievement.image : "unknown")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(themeData.theme.accentColor)
                .opacity(achievement.isAchieved ? 1 : 0.5)
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: settings.size, height: settings.size)
                .shadow(radius: 10)
                .overlay(Circle().stroke(themeData.theme.textColor.opacity(achievement.isAchieved ? 1 : 0.5), lineWidth: 3))
            VStack{
                ColoredText(text: achievement.isAchieved ? achievement.name : "???")
                    .font(.headline)
                    .padding(.leading)
                    .opacity(achievement.isAchieved ? 1 : 0.5)
                Divider()
                    .padding(.horizontal)
                    .padding(.top, -5)
                ColoredText(text: achievement.isAchieved ? achievement.description : "???")
                    .font(.caption)
                    .padding(.leading)
                    .opacity(achievement.isAchieved ? 1 : 0.5)
                if achievement.isAchieved {
                    HStack{
                        ColoredText(text: "Reward:", spacer: false)
                            .font(.caption)
                            .padding(.leading)
                        Image(systemName: "dollarsign.circle")
                            .font(.caption)
                            .foregroundColor(themeData.theme.textColor)
                        ColoredText(text: String(achievement.reward), spacer: false)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(.top, 2)

                }
            }
        }
//        ZStack {
//            NavigationLink(destination:
//                ProjectView(project: project, parent: project.parent)
//            ) {
//                EmptyView()
//            }
//            .opacity(0)
//            .buttonStyle(PlainButtonStyle())
//
//            ColoredText(text: project.name ?? "Unknown")
//        }
    }
}


