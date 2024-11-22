import SwiftUI

struct ProjectPlantItem: View {
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var themeData: ThemeData
    
    @Binding var selectedProject: Project?
    let project: Project
    
    var body: some View {
        ZStack {
            Button(action: {
                selectedProject = project
            }) {
                ZStack{
                    if plantsData.getImageOfProject(project: project).hasPrefix("P") {
                        Text(plantsData.getImageOfProject(project: project))
                            .frame(maxWidth: .infinity)
                            .frame(height: (200))
                            .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                            .foregroundColor(themeData.theme.accentColor)
                    } else {
                        Image(plantsData.getImageOfProject(project: project))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: (200))
                            .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                            .foregroundColor(themeData.theme.accentColor)
                    }
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeData.theme.textColor, lineWidth: 1)
                        .frame(maxWidth: .infinity)
                        .frame(height: (25))
                        .foregroundColor(themeData.theme.textColor)
                        .offset(y: 100)
                        .padding(.horizontal, 15)
                }
            }
            ColoredText(text: project.name ?? "Unknown Project", bold: true, spacer: false)
                .frame(maxWidth: .infinity)
                .frame(height: (24))
                .foregroundColor(themeData.theme.textColor)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(Color(themeData.theme.isDark ? .black : .white))
                )
                .offset(y: 100)
                .padding(.horizontal, 16)
        }
    }
}
