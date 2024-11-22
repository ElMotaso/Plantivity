import SwiftUI

struct StatsListView: View {
    @EnvironmentObject var themeData: ThemeData
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.state, ascending: true), NSSortDescriptor(keyPath: \Project.name, ascending: true)]
    ) var projects: FetchedResults<Project>
    
    @State var searchString = ""
    @State var selectedStatesFilter: [Int] = []
    @State var selectedIconsFilter: [Int] = []
    
    @State var showFilter = false
    
    var body: some View {

            VStack {
                SearchBar(text: $searchString)
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                if(projects.count > 0) {
                    let filteredProjects = projects.compactMap({project in project}).filter { project in applyFilter(project: project)}
                    if(filteredProjects.count > 0){
                        List (filteredProjects,
                            children: \.subprojectsArray){ project in
                                ProjectStatsListItem(project: project)
                        }
                        .listStyle(PlainListStyle())
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
                            Text("here.")
                                .underline()
                                .foregroundColor(themeData.theme.accentColor)
                        }
                        .padding(.leading, -2)
                        Spacer()
                    }
                    Spacer()
                }
            }
            if showFilter {
                GeometryReader{ geometry in
                    ProjectFilter(selectedStatesFilter: $selectedStatesFilter, selectedIconsFilter: $selectedIconsFilter)
                        .padding(.top, geometry.size.height/3)
                        .padding(.horizontal)
                }
                .background(Color(themeData.theme.isDark ? .gray : .black).opacity(0.5))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation{
                        showFilter.toggle()
                    }
                }
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
