import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var plantsData: PlantsData
    @State var project: Project? = nil

    var body: some View {
        VStack{
            ThemeSelector()
                .padding()
            IconSelector()
            Spacer()
            /*
            NavigationLink(destination: ProjectSelector(selectedProject: $project, onlyActiveProjects: true)){
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(themeData.theme.textColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .padding(.horizontal, 5)
                    Text(project?.name ?? "No Project")
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .foregroundColor(themeData.theme.invertedTextColor)
                        .padding(.horizontal)
                }
            }
            .padding()
            Text("Tier: " + String(project?.tier ?? -999))
            Spacer()
             */
        }
        .navigationBarTitle(Text("Settings"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
    }
}
