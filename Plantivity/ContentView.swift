import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var stats: Stats
    
    @State var change: Int = 0
    
    var body: some View {
        ZStack {
            switch settings.selection {
                case 0:
                    ProjectsView()
                case 1:
                    StatsView()
                case 2:
                    TimerView()
                case 3:
                    HallOfFameView()
                case 4:
                    StoreView()
                default:
                    EmptyView()
            }
            VStack{
                Spacer()
                if settings.showTabBar {
                    TabBar(images: ["book", "chart.bar.xaxis", themeData.theme.symbol, "camera.macro", "cart"], currentTab: $settings.selection)
                }
            }
            .ignoresSafeArea()
        }
        .background(themeData.theme.backgroundColor)
        .accentColor(themeData.theme.accentColor)
        .colorScheme(themeData.theme.isDark ? .dark : .light)
    }
}

//AccountView()
//.tabItem {
//    Image(systemName: "person")
//    Text("Account")
//}
//.tag(5)
