import SwiftUI

struct ProjectsPlantView: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var plantsData: PlantsData
    
    @Binding var selectedProject: Project?
    
    var gridItemLayout: [GridItem] = [GridItem(.adaptive(minimum: 100))]
    

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.state, ascending: true), NSSortDescriptor(keyPath: \Project.name, ascending: true)]
    ) var projects: FetchedResults<Project>
    
    @State var searchString = ""
    @Binding var selectedStatesFilter: [Int]
    @Binding var selectedIconsFilter: [Int]
    
    @Binding var showFilter: Bool
    
    var body: some View {
        if(projects.count > 0) {
            let filteredProjects = projects.compactMap({project in project}).filter { project in applyFilter(project: project)}
            if !filteredProjects.isEmpty {
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: gridItemLayout, spacing: 15) {
                        ForEach(filteredProjects, id: \.id){ project in
                            ProjectPlantItem(selectedProject: $selectedProject, project: project)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding(.top)
                }
                .padding()
            } else if (selectedIconsFilter.count != 0 || selectedStatesFilter.count != 0) {
                Spacer()
                ColoredText(text: "No projects availible.", bold: false, spacer: false)
                    .opacity(0.6)
                HStack {
                    Spacer()
                    ColoredText(text: "Check your filter", bold: false, spacer: false)
                        .opacity(0.6)
                    Button (
                        action: {
                            showFilter.toggle()
                        },
                        label: {
                            Image(systemName:selectedIconsFilter.count != 0 || selectedStatesFilter.count != 0 ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                .foregroundColor(themeData.theme.accentColor)
                        }
                    )
                    .padding(.leading, -3)
                    .padding(.bottom, -1)
                    Spacer()
                }
                Spacer()

            }
        } else {
            Spacer()
            ColoredText(text: "No projects availible.", bold: false, spacer: false)
                .opacity(0.6)
            HStack {
                Spacer()
                ColoredText(text: "To add projects click", bold: false, spacer: false)
                    .opacity(0.6)
                NavigationLink(destination: AddProjectView()){
                    Image(systemName: "plus")
                        .foregroundColor(themeData.theme.accentColor)
                }
                .padding(.leading, -3)
                .padding(.bottom, -1)
                Spacer()
            }
            Spacer()
        }
    }
    
    func applyFilter(project: Project) -> Bool {
        var filterEnabled = false
        if(searchString.count != 0){
            if(!project.name!.contains(searchString)){
                return false
            }
            filterEnabled = true
        }
        if(selectedStatesFilter.count != 0){
            if(!selectedStatesFilter.contains(Int(project.state))){
                return false
            }
            filterEnabled = true
        }
        if(selectedIconsFilter.count != 0){
            if(!selectedIconsFilter.contains(Int(project.icon))){
                return false
            }
            filterEnabled = true
        }
        if(!filterEnabled){
            return project.level == 0
        }
        return true
    }
}
