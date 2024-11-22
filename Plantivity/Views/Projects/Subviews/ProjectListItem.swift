import SwiftUI

struct ProjectListItem: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var themeData: ThemeData
    @ObservedObject var project: Project
    
    var body: some View {
        ZStack {
            if project.state == 0 || project.state == 1 {
                NavigationLink(destination:
                                ProjectView(project: project, parent: project.parent, state: project.state, selectedIcon: project.icon)
                ) {
                    EmptyView()
                }
                .opacity(0)
                .buttonStyle(PlainButtonStyle())
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
            } else if project.state == 3 {
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
                    
                    ColoredText(text: (project.name ?? "Unknown"))
                }
            } else if project.state == 2 {
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
                    
                    ColoredText(text: (project.name ?? "Unknown"))
                }
            }
        }
    }
}
