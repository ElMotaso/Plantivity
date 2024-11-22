import SwiftUI
import CoreData

struct AchievementsView: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var achievementsData: AchievementsData
    @Environment(\.managedObjectContext) var managedObjectContext
        
    @State var showFilter = false
    @State var showAchieved = true
    @State var showUnachieved = true
    
    var body: some View {
        NavigationView {
            PopupMenu(
                show: $showFilter,
                content: {
                    ZStack{
                        ScrollView {
                            ForEach(achievementsData.achievements.filter{achievement in (showAchieved && achievement.isAchieved) || (showUnachieved && !achievement.isAchieved) }){ achievement in
                                AchievementListItemView(achievement: achievement)
                                    .padding()
                            }
                            .padding(.bottom, 60)
                        }
                    }
                }, popupContent: {
                    AchievmentsFilterView(showAchieved: $showAchieved, showUnachieved: $showUnachieved)
                    
                })
                .navigationBarTitle(Text("Achievements"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
                .navigationBarItems(
                    trailing: HStack {
                        Button(action: {showFilter.toggle()}){
                            Image(systemName: !showAchieved || !showUnachieved ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                        }
                        .padding()
                    }
                )
        }
        .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
    }
}
/*

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var achievementsData: AchievementsData
    @Environment(\.managedObjectContext) var managedObjectContext
        
    @State var showFilter = false
    @State var showAchieved = true
    @State var showUnachieved = true
        
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView {
                    ForEach(achievementsData.achievements.filter{achievement in (showAchieved && achievement.isAchieved) || (showUnachieved && !achievement.isAchieved) }){ achievement in
                        AchievementListItemView(achievement: achievement)
                            .padding()
                    }
                }
                .padding()
                if showFilter {
                    GeometryReader{ geometry in
                        AchievmentsFilterView(showAchieved: $showAchieved, showUnachieved: $showUnachieved)
                            .padding(.top, geometry.size.height/3)
                            .padding(.horizontal)
                    }
                    .background(Color(themeData.theme.isDark ? .gray : .black).opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showFilter.toggle()
                    }
                }
            }
            .navigationBarTitle(Text("Achievements"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            .navigationBarItems(
                trailing: HStack {
                    Button(action: {showFilter.toggle()}){
                        Image(systemName:"line.horizontal.3.decrease")
                    }
                    .padding()
                }
            )
        }
        .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
    }
}
*/
