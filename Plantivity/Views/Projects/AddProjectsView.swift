import SwiftUI
import AVFoundation

struct AddProjectView: View {
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var storeData: StoreData
    @EnvironmentObject var plantData: PlantsData

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.start, ascending: false)]
    ) var projects: FetchedResults<Project>
    
    @State var name = ""
    @State private var isPresented = false
    @State var parent: Project? = nil
    @State var selectedPlant: Int16? = nil
    @State var selectedIcon: Int16? = nil
    
    @State var popupText = "Select a project name and an icon."
    @State var show = false
    
    var body: some View {
        GeometryReader{ _ in
            Popup (backgroundColor: .red, textColor: .black, text: popupText, show: $show, doublePadding: true) {
                VStack {
                    HStack {
                        ColoredText(text: "Name: ", spacer: false)
                        TextField("", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                    HStack {
                        ColoredText(text: "Parent Project: ", spacer: false)
                        NavigationLink(destination: ProjectSelector(selectedProject: $parent)){
                            ZStack {
                                RoundedRectangle(cornerRadius: 8).fill(themeData.theme.textColor)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 30)
                                    .padding(.horizontal, 5)
                                Text(parent?.name ?? "No Parent")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 30)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .padding(.horizontal)
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    if (parent == nil){
                    ColoredText(text: "Plant:")
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                        NavigationLink(destination: PlantSelector(selectedPlant: $selectedPlant)){
                            if (selectedPlant == nil){
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: (200))
                                    .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                    .foregroundColor(themeData.theme.accentColor)
                            } else {
                                HStack{
                                    if(plantData.plants[Int(selectedPlant!)].images[1].hasPrefix("P")){
                                        Text(plantData.plants[Int(selectedPlant!)].images[1])
                                                .frame(maxWidth: .infinity)
                                                .frame(maxHeight: .infinity)
                                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                                .foregroundColor(themeData.theme.accentColor)
                                                .padding()

                                    } else{
                                        Image(plantData.plants[Int(selectedPlant!)].images[1])
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .frame(maxHeight: .infinity)
                                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                                .foregroundColor(themeData.theme.accentColor)
                                                .padding()
                                    }
                                    VStack{
                                        ColoredText(text: plantData.plants[Int(selectedPlant!)].name)
                                        ColoredText(text: "Update Interval:")
                                            .padding(.top, 5)
                                        if(plantData.plants[Int(selectedPlant!)].intervall <= 7){
                                            ColoredText(text: "\tVery Short", bold: false)
                                        }else if(plantData.plants[Int(selectedPlant!)].intervall <= 7){
                                            ColoredText(text: "\tShort", bold: false)
                                        }else if(plantData.plants[Int(selectedPlant!)].intervall <= 30){
                                            ColoredText(text: "\tMedium", bold: false)
                                        }else if(plantData.plants[Int(selectedPlant!)].intervall < 183){
                                            ColoredText(text: "\tLong", bold: false)
                                        }else{
                                            ColoredText(text: "\tVery Long", bold: false)
                                        }
                                        
                                        ColoredText(text: "Session Reward:")
                                        if(plantData.plants[Int(selectedPlant!)].reward[1] < 5){
                                            ColoredText(text: "\tLittle", bold: false)
                                        }else if(plantData.plants[Int(selectedPlant!)].reward[1] < 10){
                                            ColoredText(text: "\tMedium", bold: false)
                                        }else{
                                            ColoredText(text: "\tLarge", bold: false)
                                        }
                                        
                                        ColoredText(text: "Required Work:")
                                        if(plantData.plants[Int(selectedPlant!)].work[1] < 900){
                                            ColoredText(text: "\tVery Little", bold: false)
                                        }else if(plantData.plants[Int(selectedPlant!)].work[1] < 1800){
                                            ColoredText(text: "\tLittle", bold: false)
                                        }else if(plantData.plants[Int(selectedPlant!)].work[1] < 3600){
                                            ColoredText(text: "\tMedium", bold: false)
                                        }else{
                                            ColoredText(text: "\tMuch", bold: false)
                                        }
                                    }
                                Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: (200))
                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                .foregroundColor(themeData.theme.accentColor)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    ColoredText(text: "Category:")
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                    HStack{
                        ForEach(0..<iconData.icons.count/2, id: \.self){ i in
                            Button {
                                selectedIcon = Int16(iconData.icons[i].id)
                            } label: {
                                Image(systemName: iconData.icons[i].image)
                                    .foregroundColor(themeData.theme.accentColor.opacity((iconData.icons[i].id == selectedIcon ?? -1) ? 1 : 0.3))
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
                                    .foregroundColor(themeData.theme.accentColor.opacity((iconData.icons[i].id == selectedIcon ?? -1) ? 1 : 0.3))
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    
                    WideButton(text: "Save",
                        action: {
                            if((name == "") || (selectedIcon == nil) || (parent == nil && selectedPlant == nil)){
                                show = true
                                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                                if(name == "" && selectedIcon == nil){
                                    popupText = "Select a project name and an icon."
                                } else if (name == ""){
                                    popupText = "Select a project name."
                                } else if (selectedIcon == nil){
                                    popupText = "Select a project icon."
                                } else if (parent == nil && selectedPlant == nil){
                                    popupText = "Select a plant."
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                                    show = false
                                }
                            } else {
                                save()
                                presentationMode.wrappedValue.dismiss()                        }
                        }
                    )
                    .opacity((name == "") || (selectedIcon == nil) || (parent == nil && selectedPlant == nil) ? 0.3 : 1)
                    .padding()
                    .padding(.bottom, 60)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitle(Text("New Project"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            }
        }
    }
    
    func save() {
        let newProject = Project(context: managedObjectContext)
        newProject.name = name
        newProject.start = Date()
        newProject.id = UUID()
        newProject.time = Int64(0)
        newProject.state = Int16(0)
        newProject.icon = Int16(selectedIcon!)
        newProject.isFertilized = false
        if(parent != nil){
            newProject.parent = parent
            newProject.level = parent!.level + Int16(1)
            newProject.plant = -1
            newProject.lastTierUpdate = nil
            newProject.tier = -1
        } else {
            newProject.parent = nil
            newProject.level = Int16(0)
            newProject.plant = selectedPlant!
            newProject.lastTierUpdate = Date()
            newProject.tier = Int16(1)
            
            let currentItemCount = storeData.items[Int(selectedPlant!)].count
            storeData.setItem(id: Int(selectedPlant!), newCount: currentItemCount - 1)
        }
        
        PersistenceController.shared.save()
    }
}
