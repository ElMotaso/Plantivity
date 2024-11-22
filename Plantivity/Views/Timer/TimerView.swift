import SwiftUI
import AVFoundation

struct TimerView: View {
    @EnvironmentObject var achievementsData: AchievementsData
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var storeData: StoreData
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var stats: Stats
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)]
 //       predicate: NSPredicate(format: "level == 0")
    ) var projects: FetchedResults<Project>
        
    @State var notifyUser = UserDefaults.standard.bool(forKey: "notifyUser")
    
    @State var isRunning = false
    @State var isStopped = true
    @State var timeString = "00:00:00"
    @State var timeRemaining = 0
    @State var popupTimeRemaining = 1200
    @State var progress = 1.0
    @State var timer = Timer.publish(every: 0.99, tolerance: 0.02, on: .main, in: .common).autoconnect()
    
    @State var selectedTime = 0
    
    @State var project: Project? = nil
    
    @State var backgroundDate: NSDate? = nil
    
    @State var date = Date()
    
    @State var show = false

    @State var popupText = "Select a project"
    @State var popupBackgroundColor = Color.red
    @State var popupTextColor = Color.black
    
        var body: some View {
            NavigationView{
                Popup(backgroundColor: popupBackgroundColor, textColor: popupTextColor, text: popupText ,show: $show, background: true) {
                    VStack{
                        Button(
                            action: {
                                let center = UNUserNotificationCenter.current()
                                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                                    //TODO
                                }
                                notifyUser.toggle()
                                if(notifyUser && isRunning){
                                    notify()
                                }
                                else{
                                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                                }
                                UserDefaults.standard.setValue(notifyUser, forKey: "notifyUser")
                            },
                            label: {
                                Image(systemName: notifyUser ? "bell.fill" : "bell.slash")
                            }
                        )
                        .padding(.top)
                        ZStack {
                            GeometryReader{ geometry in
                                let size = min(geometry.size.width, geometry.size.height)
                                VStack{
                                    Spacer()
                                    HStack{
                                        Spacer()
                                        TimerProgress(progress: $progress, thickness: size*0.06)
                                            .frame(width: size*0.8, height: size*0.8)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                VStack{
                                    Spacer()
                                    if(isStopped){
                                        HStack{
                                            Spacer()
                                            TimePicker(width: size*0.5, height: size*0.5, seconds: $selectedTime)
                                            Spacer()
                                        }
                                    } else {
                                        HStack{
                                            Spacer()
                                            Text(timeString)
                                                .font(.system(.title, design: .monospaced))
                                                .bold()
                                                .onReceive(timer) { _ in
                                                    updateTimer()
                                                }
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            backgroundDate = NSDate()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                            if let date = backgroundDate {
                                if(isRunning && !isStopped){
                                    timeRemaining -= Int(-date.timeIntervalSinceNow)
                                }
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button (action: {
                                if(project?.name == nil){
                                    show = true
                                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                                    
                                    popupBackgroundColor = .red
                                    popupTextColor = .black
                                    popupText = "Select a project before you start."
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        show = false
                                    }
                                } else {
                                    startTimer()
                                }
                            }, label: {
                                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(themeData.theme.backgroundColor)
                                    .background(themeData.theme.textColor.opacity((project?.name == nil) ? 0.3 : 1))
                                    .clipShape(Circle())
                            })
                            Spacer()
                            Spacer()
                            Button (action: {
                                if(!isStopped){
                                    if(notifyUser){
                                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                                        AudioServicesPlaySystemSound(1006)
                                    }
                                }
                                stopTimer()
                            }, label: {
                                Image(systemName: "square.fill")
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(themeData.theme.backgroundColor)
                                    .background(themeData.theme.textColor.opacity((project?.name == nil) ? 0.3 : 1))
                                    .clipShape(Circle())
                            })
                            .disabled((project == nil))
                            Spacer()
                        }
                        .padding(.top)
                        Spacer()
                        VStack{
                            ColoredText(text: "Time worked today: ", spacer: false)
                                .font(.title)
                            Divider()
                                .padding(.horizontal, 30)
                                .padding(.top, -5)
                            ColoredText(text: stats.getDayTime(projects: projects), spacer: false)
                                .font(.body)
                                .padding(.bottom)
                        }
                        .padding(.vertical)

                        ColoredText(text: "Selected Project:")
                            .padding(.horizontal)
                        NavigationLink(destination: ProjectSelector(selectedProject: $project, onlyActiveProjects: true)){
                            ZStack {
                                RoundedRectangle(cornerRadius: 8).fill(themeData.theme.textColor)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 30)
                                    .padding(.horizontal, 5)
                                Text(project?.name ?? "No Project")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 30)
                                    .foregroundColor(themeData.theme.invertedTextColor)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 60)
                        .disabled(!isStopped)
                        .onTapGesture {
                            if(!isStopped){
                                show = true
                                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                                
                                popupBackgroundColor = .red
                                popupTextColor = .black
                                popupText = "You cannot change the project during a session."
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                    show = false
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.bottom)

                    }
                }
                .onAppear(){
                    if(isStopped){
                        timer.upstream.connect().cancel()
                    }
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
    }
    
    func updateTimer(){
        if timeRemaining > 0 {
            if(project?.name == nil){
                stopTimer()
                popupBackgroundColor = .red
                popupTextColor = .black
                popupText = "The selected project was deleted. Click here to dismiss."
                show = true
                if(notifyUser){
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                }
            }
            timeRemaining -= 1
            if(popupTimeRemaining > 0){
                popupTimeRemaining -= 1
            } else {
                show = true
                if(notifyUser){
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                }
                
                popupBackgroundColor = themeData.theme.accentColor
                popupTextColor = themeData.theme.invertedTextColor
                popupText = "Reminder to rest your eyes for 20 seconds."
                
                popupTimeRemaining = 1200
                DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                    show = false
                }
            }
            timeString = stats.secondsToHoursMinutesSeconds(seconds: timeRemaining)
            progress = Double(timeRemaining)/Double(selectedTime)
        } else {
            if(notifyUser){
                AudioServicesPlaySystemSound(themeData.theme.soundId)
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
            }
            
            popupBackgroundColor = themeData.theme.accentColor
            popupTextColor = themeData.theme.invertedTextColor
            popupText = "Session Completed."
            show = true
            if(notifyUser){
                AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                show = false
            }
            
            saveSession()
            stopTimer()
        }
    }
    
    func startTimer(){
        if(selectedTime != 0 && project != nil){
            if(isRunning){
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                timer.upstream.connect().cancel()
                isRunning = false
            } else {
                timer = Timer.publish(every: 1, tolerance: 0.01, on: .main, in: .common).autoconnect()
                isRunning = true
                
                if(isStopped){
                    isRunning = true
                    timeRemaining = selectedTime
                    popupTimeRemaining = 1200
                    progress = 1
                    timeString = stats.secondsToHoursMinutesSeconds(seconds: timeRemaining)
                    date = Date()
                }
                if(notifyUser){
                    notify()
                }
            }
            isStopped = false
            settings.showTabBar = false
        }
    }
    
    func stopTimer(){
        if(!isStopped){
            selectedTime = 0
        }
        isRunning = false
        isStopped = true
        settings.showTabBar = true
        progress = 1
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        timer.upstream.connect().cancel()
    }
    
    func saveSession(){
        selectedTime = selectedTime
        let session = Session(context: managedObjectContext)
        session.day = Date()
        session.id = UUID()
        session.time = Int32(selectedTime)
        session.project = project

        project?.time += Int64(selectedTime)
        addTimeToParent(project: project, time: Int32(selectedTime))
        
        let timeStats = stats.getTime(projects: projects)
        let time = timeStats.0
        let sessionCount = timeStats.1
      
        let days = stats.getTime(projects: projects).4
        var lastSevenDays = 0
        for i in 0..<7 {
            if(days.count - 1 - i >= 0){
                lastSevenDays += days[days.count - 1 - i]
            }
        }
        
        /* -- Achievments -- */
        
        if(sessionCount >= 1){
            achievementsData.newAchievement(id: 0)
            storeData.addCoins(coins: achievementsData.achievements[0].reward)
        }
        if (time >= 24 * 60 * 60){
            achievementsData.newAchievement(id: 1)
            storeData.addCoins(coins: achievementsData.achievements[1].reward)
        }
        if (time >= 7 * 24 * 60 * 60){
            achievementsData.newAchievement(id: 2)
            storeData.addCoins(coins: achievementsData.achievements[2].reward)
        }
        if (time >= 30 * 24 * 60 * 60){
            achievementsData.newAchievement(id: 3)
            storeData.addCoins(coins: achievementsData.achievements[3].reward)
        }
        if(lastSevenDays >= 144000){
            achievementsData.newAchievement(id: 10)
            storeData.addCoins(coins: achievementsData.achievements[10].reward)
        }
        if(lastSevenDays >= 216000){
            achievementsData.newAchievement(id: 11)
            storeData.addCoins(coins: achievementsData.achievements[11].reward)
        }
        if(lastSevenDays >= 288000){
            achievementsData.newAchievement(id: 12)
            storeData.addCoins(coins: achievementsData.achievements[12].reward)
        }
        if(isSylvester()){
            achievementsData.newAchievement(id: 13)
            storeData.addCoins(coins: achievementsData.achievements[13].reward)
        }

        
        PersistenceController.shared.save()

        /* -- Plants -- */
        if project != nil {
            storeData.addCoins(coins: Int(Float(plantsData.getRewardOfProject(project: project!)) * Float(session.time) / 3600))
        }
    }
    
    
    func isSylvester() -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        let dayEnd = calendar.component(.day, from: currentDate)
        let monthEnd = calendar.component(.month, from: currentDate)
        let dayStart = calendar.component(.day, from: date)
        let monthStart = calendar.component(.month, from: date)
        
        if(dayEnd == 1 && monthEnd == 1
            && dayStart == 31 && monthStart == 12){
            return true
        }
        return false
    }
    
    func notify(){
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "Session Completed"
                content.body = "Your session is finished. You can now take a break!"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeRemaining), repeats: false)

                let identifier = "TimerCompletedNotification"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

                center.add(request, withCompletionHandler: { (error) in
                    //TODO
                })
            }
        }
    }
    
    func addTimeToParent(project: Project?, time: Int32) -> Void{
        if(Int(project?.level ?? 0) > 0){
            if(project != nil){
                if(project?.parent != nil){
                    project?.parent?.time += Int64(selectedTime)
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
}
