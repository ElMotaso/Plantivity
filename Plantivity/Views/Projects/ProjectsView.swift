import SwiftUI

struct ProjectsView: View {
    @EnvironmentObject var themeData: ThemeData
    
    @State var pickedView = "Plants"
    @State var showFilter = false
    
    @State var selectedStatesFilter: [Int] = []
    @State var selectedIconsFilter: [Int] = []
    
    @State var selectedProject: Project? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                (themeData.theme.isDark ? Color.black : Color.white)
                    .ignoresSafeArea()
                VStack{
                    Picker(selection: $pickedView, label: Text("")){
                        Text("Plants")
                            .foregroundColor(pickedView == "Plant" ? themeData.theme.invertedTextColor : themeData.theme.textColor)
                            .tag("Plants")
                        Text("Projects")
                            .foregroundColor(pickedView == "Projects" ? themeData.theme.invertedTextColor : themeData.theme.textColor)
                            .tag("Projects")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top)
                    .padding(.horizontal)
                    if pickedView == "Plants" {
                        ProjectsPlantView(selectedProject: $selectedProject, selectedStatesFilter: $selectedStatesFilter, selectedIconsFilter: $selectedIconsFilter, showFilter: $showFilter)
                    } else if pickedView == "Projects" {
                        ProjectsListView(selectedStatesFilter: $selectedStatesFilter, selectedIconsFilter: $selectedIconsFilter, showFilter: $showFilter)
                    }
                    Spacer()
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
                            showFilter.toggle()
                    }
                }
                if selectedProject != nil {
                    GeometryReader{ geometry in
                        ProjectPlantView(project: selectedProject!)
                            .padding(.top, geometry.size.height/7)
                            .padding(.horizontal)
                    }
                    .background(Color(themeData.theme.isDark ? .gray : .black).opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        selectedProject = nil
                    }
                }
            }
            .navigationBarTitle(Text("Projects"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            .navigationBarItems(
                trailing: HStack {
                    Button(action: {
                            showFilter.toggle()
                        },
                        label: {
                            Image(systemName: selectedIconsFilter.count != 0 || selectedStatesFilter.count != 0 ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        }
                    )
                    .padding()
                    NavigationLink(destination: AddProjectView()){
                        Image(systemName:"plus")
                    }
                }
            )
        }
        .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}
