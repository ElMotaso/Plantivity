import SwiftUI

struct ProjectStatsListItem: View {
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var stats: Stats
    @ObservedObject var project: Project
    
    var body: some View {
        VStack {
            HStack{
                ZStack{
                    Image(systemName: iconData.icons[Int(project.icon)].image)
                        .foregroundColor(themeData.theme.accentColor)
                        .frame(width: 20)
                    Image(systemName: /*Int(project.state) < 2 ? settings.states[Int(project.state)] + ".fill" :*/ settings.states[Int(project.state)])
                        .foregroundColor(themeData.theme.textColor)
                        .frame(width: 5)
                        .offset(x: 15, y: 7)
                }
                .padding(.trailing)
                ColoredText(text: project.name ?? "Unknown")
            }
            HStack{
                ColoredText(text: "Time: " + stats.secondsToHoursMinutesSeconds(seconds: Int(project.time)), bold: false, spacer: false)
                    .padding(.trailing)
                ColoredText(text: "Started: " + formatDate(date: project.start ?? Date()), bold: false, spacer: false)
                Spacer()
            }
            .font(.caption)
        }
    }
}
