import SwiftUI

struct StatsView: View {
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var stats: Stats

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)]
    ) var projects: FetchedResults<Project>

    let padding: CGFloat = 50
    
    @State var searchString = ""
    @State var pickedTime = 7
    @State var show = false
    
    var body: some View {
        let time = stats.getTime(projects: projects)
        NavigationView{
        ZStack{
            (themeData.theme.isDark ? Color.black : Color.white)
                .ignoresSafeArea()
                VStack(){
                    let iconValues = stats.getIconStats(projects: projects, selectedIcons: iconData.selectedIcons)
                    
                    if(iconData.selectedIcons.count > 2){
                        GeometryReader{ geometry in
                            Overview(center: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2) , size: geometry.size.width - padding - settings.size, iconSize: settings.size, values: iconValues, icons: iconData.selectedIcons)
                        }
                        .padding(.top, 50)
                        .padding()
                        
                    }
                    VStack{
                        Picker(selection: $pickedTime, label: Text("")){
                            Text("7 Days")
                                .foregroundColor(pickedTime == 7 ? themeData.theme.invertedTextColor : themeData.theme.textColor)
                                .tag(7)
                            Text("30 Days")
                                .foregroundColor(pickedTime == 30 ? themeData.theme.invertedTextColor : themeData.theme.textColor)
                                .tag(30)
                            Text("12 Months")
                                .foregroundColor(pickedTime == 12 ? themeData.theme.invertedTextColor : themeData.theme.textColor)
                                .tag(12)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top, 50)
                        .padding(.horizontal)

                        GeometryReader{ geometry in
                            Bars(value: stats.getStats(projects: projects, size: pickedTime, days: time.4), pickedTime: pickedTime, width: geometry.size.width, height: geometry.size.height*5/6)
                                .padding(.top, 24)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 60)
                    }
                }
            
            if show {
                GeometryReader{ geometry in
                    DetailedStats(time: time)
                        .padding(.top, geometry.size.height/3)
                        .padding(.horizontal)
                }
                .background(Color(themeData.theme.isDark ? .gray : .black).opacity(0.5))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    show.toggle()
                }
            }
                
        }
        .navigationBarTitle(Text("Statistics"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
        .navigationBarItems(
            leading:
                NavigationLink(destination: StatsSettingsView()){
                Image(systemName:"gearshape")
            },
            trailing: HStack {
                Button(
                    action: {
                        show.toggle()
                    },
                    label: {
                        Image(systemName:"doc.text")
                    }
                )
                .padding()
                NavigationLink(destination: StatsListView()){
                    Image(systemName:"list.bullet")
                }
            }
        )
    }
    .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
    .navigationViewStyle(StackNavigationViewStyle())
    }
}

func formatDate(date: Date) -> String {
    let formatter1 = DateFormatter()
    formatter1.dateStyle = .short
    return formatter1.string(from: date)
}
