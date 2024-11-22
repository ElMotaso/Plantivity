import SwiftUI

struct ProjectView: View {
    @EnvironmentObject var achievementsData: AchievementsData
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var storeData: StoreData
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var themeData: ThemeData
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var project: Project

    @State var name = ""
    @State var parent: Project?
    
    @State var state: Int16
    @State var oldState = 0

    
    @State var selectedIcon: Int16

    
    @State var showMergeButton = false
    @State var showDeleteButton = false
    
    @State var show = false
    @State var popupText = ""
    @State var color = Color.blue
        
    var body: some View {
        Popup (backgroundColor: color, textColor: .black, text: popupText, show: $show, doublePadding: true) {
            VStack {
                HStack {
                    ColoredText(text: "Change Name: ")
                    TextField(project.name ?? "Unknown Project", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing)
                }
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    ColoredText(text: "Change Parent Project: ")
                    NavigationLink(destination: ProjectSelector(selectedProject: $parent, changingProject: project)){
                        ZStack {
                            RoundedRectangle(cornerRadius: 8).fill(themeData.theme.textColor)
                                .frame(maxWidth: .infinity)
                                .frame(height: (2/3 * settings.size))
                                .padding(.horizontal, 5)
                            Text(parent?.name ?? "No Parent")
                                .frame(maxWidth: .infinity)
                                .frame(height: (2/3 * settings.size))
                                .foregroundColor(themeData.theme.invertedTextColor)
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 5)
                
                StateSelector(state: $state/*, displayState: project.state*/)
                
                ColoredText(text: "Icon:")
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                HStack{
                    ForEach(0..<iconData.icons.count/2, id: \.self){ i in
                        Button {
                            selectedIcon = Int16(iconData.icons[i].id)
                        } label: {
                            Image(systemName: iconData.icons[i].image)
                                .foregroundColor(themeData.theme.accentColor.opacity((iconData.icons[i].id == selectedIcon) ? 1 : 0.3))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
                HStack{
                    ForEach(iconData.icons.count/2..<iconData.icons.count, id: \.self){ i in
                        Button {
                            selectedIcon = Int16(iconData.icons[i].id)
                        } label: {
                            Image(systemName: iconData.icons[i].image)
                                .foregroundColor(themeData.theme.accentColor.opacity((iconData.icons[i].id == selectedIcon) ? 1 : 0.3))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                WideButton(text: "Save Changes", action: {save()})
                    .opacity((project.name == "") ? 0.6 : 1)
                    .disabled((project.name == ""))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                
                if(!showMergeButton){
                    WideButton(text: "Merge", action: {
                        showMergeButton = true
                    })
                    .padding(.horizontal)
                    .padding(.top, 5)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1.8 * settings.size)
                            .padding(.horizontal)
                            .padding(.top, 5)
                        Text("Merging removes the upcoming selected project.")
                            .foregroundColor(themeData.theme.invertedTextColor)
                            .padding(.bottom, 48)
                        HStack{
                            NavigationLink(destination: ProjectSelector(defaultTitle: "Select Merge", selectedProject: $parent, mergeProject: project)){
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8).fill(Color(red: 0.60, green: 0.10, blue: 0.10))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: (2/3 * settings.size))
                                    Text("Merge")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: (2/3 * settings.size))
                                        .foregroundColor(themeData.theme.invertedTextColor)
                                }
                            }
                            
                            .padding(.leading, 30)
                            .padding(.trailing, 5)
                            .padding(.top, 5)
                            .padding(.bottom, -30)
                            NavigationLink(destination: EmptyView()){
                                EmptyView()
                            }
                            .frame(width: 0, height: 0)
                            WideButton(text: "Cancel", action: {
                                showMergeButton = false
                            }, color: Color(red: 0.70, green: 0.60, blue: 0.60))
                                .padding(.trailing, 30)
                                .padding(.leading, 5)
                                .padding(.top, 5)
                                .padding(.bottom, -30)
                        }
                    }
                    .animation(.none)
                }
                
                if(!showDeleteButton){
                    WideButton(text: "Delete", action: {
                        showDeleteButton = true
                    })
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom)
                    .padding(.bottom, 60)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red)
                            .frame(maxWidth: .infinity)
                            .frame(height: 1.8 * settings.size)
                            .padding(.horizontal)
                            .padding(.top, 5)
                            .padding(.bottom)
                        Text("All subprojects will be deleted.")
                            .foregroundColor(themeData.theme.invertedTextColor)
                            .padding(.bottom, 60)
                        HStack{
                            WideButton(text: "Delete", action: {
                                delete(project: project)
                                presentationMode.wrappedValue.dismiss()
                            }, color: Color(red: 0.60, green: 0.10, blue: 0.10))
                                .padding(.leading, 30)
                                .padding(.trailing, 5)
                                .padding(.top, 5)
                                .padding(.bottom, -20)
                            WideButton(text: "Cancel", action: {
                                showDeleteButton = false
                            }, color: Color(red: 0.70, green: 0.60, blue: 0.60))
                                .padding(.trailing, 30)
                                .padding(.leading, 5)
                                .padding(.top, 5)
                                .padding(.bottom, -20)
                        }
                    }
                    .padding(.bottom, 60)
                    .animation(.none)
                }
            }
        }
        .onAppear(){
            showMergeButton = false
            oldState = Int(state)
        }
        .onChange(of: state){ state in
            if(state == 1 && oldState != state){
                if(storeData.items[2].count <= 0){
                    popupText = "You don't have enough Freeze Items"
                    color = Color.red
                } else {
                    popupText = "This will use one of your Freeze Items"
                    color = Color.blue
                }
                show = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    show = false
                }
            }
        }
    }
    
    
    
    func delete(project: Project){
        for subproject in project.subprojectsArray ?? [] {
            delete(project: subproject)
        }
        for session in project.sessionsArray ?? [] {
            managedObjectContext.delete(session)
        }
        managedObjectContext.delete(project)
        PersistenceController.shared.save()
    }
    
    func save(){
        if(state == 1 && oldState != state){
            if(storeData.items[2].count <= 0){
                popupText = "You don't have enough Freeze Items"
                color = Color.red
                show = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    show = false
                }
                return
            } else {
                storeData.useItem(id: 2, project: project)
            }
        }
        if(state == 2) {
            storeData.addCoins(coins: Int(
                Float(plantsData.getRewardOfProject(project: project) *
                      plantsData.plants[Int(project.plant)].intervall *
                      plantsData.plants[Int(project.plant)].work[Int(project.tier)])
                / 3600))
        }
        if(state == 3) {
            project.tier = 0
        }
        
        if(name != ""){
            project.name = name
        }
        if(parent != nil){
            project.parent = parent
            project.level = parent!.level + Int16(1)
        } else {
            project.parent = nil
            project.level = Int16(0)
        }
    
        
        if(state == 2){
            achievementsData.newAchievement(id: 7)
            storeData.addCoins(coins: achievementsData.achievements[7].reward)
        }
        if(state == 3){
            achievementsData.newAchievement(id: 8)
            storeData.addCoins(coins: achievementsData.achievements[8].reward)
        }
        if(project.state == 1 && state != 1){
            project.lastTierUpdate = Date()
            achievementsData.newAchievement(id: 9)
            storeData.addCoins(coins: achievementsData.achievements[9].reward)
        }
        project.state = state
        
        project.icon = Int16(selectedIcon)
        
        PersistenceController.shared.save()
        presentationMode.wrappedValue.dismiss()
    }
}
