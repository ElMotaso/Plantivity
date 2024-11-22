import SwiftUI

@main
struct PlantivityApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var settings = Settings()
    @StateObject var achievementsData = AchievementsData()
    @StateObject var iconData = IconData()
    @StateObject var plantsData = PlantsData()
    @StateObject var storeData = StoreData()
    @StateObject var themeData = ThemeData()
    @StateObject var stats = Stats()
    
    let persistenceController = PersistenceController.shared
    let userDefaults = UserDefaults.standard

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settings)
                .environmentObject(achievementsData)
                .environmentObject(iconData)
                .environmentObject(plantsData)
                .environmentObject(themeData)
                .environmentObject(storeData)
                .environmentObject(stats)
                .onAppear(perform: initialize)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
        
    }
    
    func initialize() {
        themeData.theme = themeData.getTheme(theme: StringToThemeName(string: userDefaults.string(forKey: "themeName") ?? "white"))
        themeData.setTheme(theme: StringToThemeName(string: userDefaults.string(forKey: "themeName") ?? "white"))
        if let icons = iconData.getSelectedIcons(ids: userDefaults.array(forKey: "selectedIcons") as? [Int] ?? [Int]()) {
            iconData.selectedIcons = icons
        }
        achievementsData.achievements = achievementsData.getAchievements(ids: userDefaults.array(forKey: "achievments") as? [Int] ?? [Int]())
        storeData.coins = userDefaults.integer(forKey: "coins")
        storeData.loadItems()
    }
}
