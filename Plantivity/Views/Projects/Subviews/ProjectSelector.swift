import SwiftUI

struct ProjectSelector: View {
    @EnvironmentObject var achievementsData: AchievementsData
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var storeData: StoreData
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.start, ascending: false)]
    )var projects: FetchedResults<Project>
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.start, ascending: false)],
        predicate: NSPredicate(format: "state == 0")
    ) var activeProjects: FetchedResults<Project>
    
    var defaultTitle = "No Parent Project"
    
    @State var searchString = ""
    @Binding var selectedProject: Project?
    
    var onlyActiveProjects = false
    var changingProject: Project? = nil
    var mergeProject: Project? = nil
    
    var body: some View {
        VStack {
            SearchBar(text: $searchString)
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 5)
            if(mergeProject == nil){
                HStack {
                    ColoredText(text: selectedProject?.name ?? defaultTitle)
                    if(selectedProject != nil){
                        Button(action: {
                            selectedProject = nil
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 10)
                    }
                }
                .contentShape(Rectangle())
                .padding(.horizontal, 20)
                .padding(.top, 5)
            }
            Divider()
            .padding(.bottom, 0)
            if(onlyActiveProjects){
                if(activeProjects.count > 0){
                List (activeProjects.compactMap({project in project})
                    .filter {
                        project in applySearch(project: project)
                    }, children: \.subprojectsArray){ project in
                        ProjectListItem(project: project)
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture(){
                                selectedProject = project
                                presentationMode.wrappedValue.dismiss()
                            }
                }
                .listStyle(GroupedListStyle())
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        ColoredText(text: "No active", bold: false, spacer: false)
                        Image(systemName: "play")
                            .foregroundColor(themeData.theme.textColor)
                        ColoredText(text: "projects availible.", bold: false, spacer: false)
                        Spacer()
                    }
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
            } else {
                if(projects.count > 0){
                    List (projects.compactMap({project in project})
                        .filter {
                            project in applySearch(project: project)
                        },
                          children: \.subprojectsArray){ project in
                        if(!isInvalid(project: project)){
                            ProjectListItem(project: project)
                                .ignoresSafeArea()
                                .contentShape(Rectangle())
                                .onTapGesture(){
                                    if(mergeProject != nil){
                                        for subproject in project.subprojectsArray ?? []{
                                            subproject.parent = mergeProject!
                                        }
                                        for session in project.sessionsArray ?? [] {
                                            session.project = mergeProject!
                                        }
                                        mergeProject!.state = min(project.state, mergeProject!.state)
                                        mergeProject!.time += project.time
                                        addTimeToParent(project: mergeProject!, time: project.time)
                                        removeTimeFromParent(project: project, time: project.time)
                                        
                                        managedObjectContext.delete(project)
                                        PersistenceController.shared.save()
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        selectedProject = project
                                        presentationMode.wrappedValue.dismiss()
                                    }
                            }
                        } else {
                            ProjectListItem(project: project)
                                .ignoresSafeArea()
                                .disabled(true)
                                .opacity(0.4)
                        }
                    }
                    .listStyle(GroupedListStyle())
                } else {
                    Spacer()
                    ColoredText(text: "No projects availible.", bold: false, spacer: false)
                        .opacity(0.6)
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
        .navigationBarTitle(Text("Select Project"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
    }

    func isInvalid(project: Project) -> Bool {
        if(mergeProject != nil){
            var currentParent: Project? = mergeProject!
            while (currentParent != nil) {
                if(project == currentParent){
                    return true
                }
                currentParent = currentParent?.parent
            }
        }
        if(changingProject != nil){
            var currentParent: Project? = project
            while (currentParent != nil) {
                if(changingProject == currentParent){
                    return true
                }
                currentParent = currentParent?.parent
            }
        }
        return false
    }
    
    func addTimeToParent(project: Project?, time: Int64) -> Void{
        if(Int(project?.level ?? 0) > 0){
            if(project != nil){
                if(project?.parent != nil){
                    project?.parent?.time += Int64(time)
                    addTimeToParent(project: project?.parent, time: time)
                }
            }
        } else {
            if (project?.level == 0){
                if(project?.time ?? 0 >= 8 * 60 * 60){
                    achievementsData.newAchievement(id: 4)
                    storeData.addCoins(coins: achievementsData.achievements[4].reward)
                }
                if (project?.time ?? 0 >= 80 * 60 * 60){
                    achievementsData.newAchievement(id: 5)
                    storeData.addCoins(coins: achievementsData.achievements[5].reward)
                }
                if (project?.time ?? 0 >= 800 * 60 * 60){
                    achievementsData.newAchievement(id: 6)
                    storeData.addCoins(coins: achievementsData.achievements[6].reward)

                }
            }
        }
    }
    
    func removeTimeFromParent(project: Project?, time: Int64){
        if(Int(project?.level ?? 0) > 0){
            if(project != nil){
                if(project?.parent != nil){
                    project?.parent?.time -= Int64(time)
                    removeTimeFromParent(project: project?.parent, time: time)
                }
            }
        }
    }
    
    func applySearch(project: Project) -> Bool{
        return (
            (
                (project.name != nil)
                && (project.name!.contains(searchString))
                || (searchString == "" && project.level == 0)
            )
        )
    }
}
