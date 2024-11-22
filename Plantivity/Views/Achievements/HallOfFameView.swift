import SwiftUI

struct HallOfFameView: View {
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var achievementsData: AchievementsData

    @State var showPhotoPicker = false
    @State var background: UIImage? = nil
        
    @State var isEditing = false
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.id, ascending: true)]
    ) var projects: FetchedResults<Project>
        
    var body: some View {
        NavigationView {
        GeometryReader { geometry in
            ZStack {
                //themeData.theme.backgroundColor
                //    .ignoresSafeArea()
                if background == nil{
                    if achievementsData.projectImages.isEmpty && !isEditing {
                        VStack {
                            Spacer()
                            ColoredText(text: "Your Hall of Fame is empty.", bold: false, spacer: false)
                                .opacity(0.6)
                            HStack {
                                Spacer()
                                ColoredText(text: "To create your garden press", bold: false, spacer: false)
                                    .opacity(0.6)
                                Button (
                                    action: {
                                        isEditing = true
                                    },
                                    label: {
                                        Image(systemName: "pencil")
                                    }
                                )
                                .padding(.leading, -3)
                                .padding(.bottom, -1)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    //Image("background")
                    //    .resizable()
                    //    .scaledToFit()
                    //    .padding(.bottom, 40)
                } else {
                    Image(uiImage: background!)
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 40)
                }
                ForEach ($achievementsData.projectImages){ projectImage in
                    PlantImage(projectImage: projectImage, isEditing: $isEditing)
                }
                if isEditing {
                    HStack{
                        VStack{
                            Spacer()
                            NavigationLink(destination: HallOfFameProjectSelectorView()) {
                                Image(systemName: "camera.macro")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            }
                            .padding(.bottom, 5)
                            Button (action: {
                                showPhotoPicker = true
                            }, label: {
                                Image(systemName: "photo")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            })
                        }
                        .padding()
                        Spacer()
                        VStack{
                            Spacer()
                            Button (action: {
                                background = nil
                                //selectedProjects = []
                                achievementsData.projectImages = []
                            }, label: {
                                Image(systemName: "arrow.uturn.left")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            })
                            .padding(.bottom, 5)
                            Button (action: {
                                loadLayout()
                                isEditing = false
                            }, label: {
                                Image(systemName: "multiply")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            })
                            .padding(.bottom, 5)
                            Button (action: {
                                saveLayout()
                                isEditing = false
                            }, label: {
                                Image(systemName: "checkmark")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            })
                        }
                        .padding()

                    }
                    .padding(.bottom, 40)
                } else {
                    HStack{
                        VStack{
                            Spacer()
                            Button (action: {
                                isEditing = true
                            }, label: {
                                Image(systemName: "pencil")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            })
                        }
                        .padding()
                        Spacer()
                        VStack{
                            Spacer()
                            Button (action: {
                                let image = drawImage(width: geometry.size.width, height: geometry.size.height)
                                    let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                                    UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                            }, label: {
                                Image(systemName: "square.and.arrow.up")
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .background(themeData.theme.textColor)
                                    .clipShape(Circle())
                            })
                        }
                        .padding()

                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitle(Text("Hall of Fame"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: AchievementsView()){
                        Image(systemName:"rosette")
                    }
            )
        }
        .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
        .onAppear() {
            if !isEditing {
                loadLayout()
            }
        }
        /*.onChange(of: selectedProjects){ list in
            var projectImages = [ProjectImage]()
            for project in list {
                projectImages.append(ProjectImage(id: project.id ?? UUID(), project: project, x: 0, y: 0))
            }
            selectedProjectImages = projectImages
        }*/
        .sheet(isPresented: $showPhotoPicker, content: {
            ImagePicker(image: $background)
        })
    }
    }
    func loadLayout(){
        achievementsData.projectImages = achievementsData.getProjectImages(allProjects: projects)
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            background = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("background.png").path)
        } else {
            background = nil
        }
    }
    
    func saveLayout() -> Bool {
        achievementsData.setProjectImages(selectedProjectImages: achievementsData.projectImages)
        if background != nil {
            guard let data = background!.jpegData(compressionQuality: 1) ?? background!.pngData() else {
                return false
            }
            guard let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("background.png") as URL else {
                return false
            }
            do {
                try data.write(to: path)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            guard let path = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("background.png") as URL else {
                return false
            }
            do {
                try FileManager.default.removeItem(at: path)
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
    }
    
    func drawImage(width: CGFloat, height: CGFloat) -> UIImage {
        let imageSize = background?.size ?? CGSize()
        let backgroundSize = CGSize(width: imageSize.width, height: imageSize.width/width * height)
        
        let zero = CGPoint(x: backgroundSize.width/2, y: backgroundSize.height/2)
        let imageZero = CGPoint(x: zero.x - imageSize.width/2, y: zero.y - imageSize.height/2)

        let plantSize = CGSize(width: backgroundSize.width * 141 / width, height: backgroundSize.height * 300 / height)

        let renderer = UIGraphicsImageRenderer(size: backgroundSize)
        return renderer.image { context in
            background?.draw(in: CGRect(origin: imageZero, size: imageSize))
            for projectImage in achievementsData.projectImages {
                let plantZero = CGPoint(
                    x: (projectImage.x + width/2)/width * backgroundSize.width - plantSize.width/2,
                    y: (projectImage.y + height/2)/height * backgroundSize.height - plantSize.height/2)

                UIImage(named: plantsData.plants[Int(projectImage.project?.plant ?? 0)].name.lowercased() + "_" + String(projectImage.project?.tier ?? 0))?.draw(in: CGRect(origin: plantZero, size: plantSize))
            }
        }
    }
}
