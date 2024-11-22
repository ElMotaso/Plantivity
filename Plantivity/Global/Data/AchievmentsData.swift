import Foundation
import SwiftUI
import AVFoundation

class AchievementsData: ObservableObject{
    @EnvironmentObject var storeData: StoreData
    
    @Published var projectImages: [ProjectImage] = [ProjectImage]()
    
    @Published var achievements: [Achievement] = [
            Achievement(image: "babysteps",
                        name: "First steps",
                        description: "Congratulations on finishing your first work session. I am curious about how much you can achieve.",
                        reward: 5,
                        id: 0),

            Achievement(image: "day",
                        name: "One day out of how many?",
                        description: "Achieved for working a full day across all your projects combined.",
                        reward: 20,
                        id: 1),

            Achievement(image: "week",
                        name: "One full week",
                        description: "Achieved for working 168 hours or one full week.",
                        reward: 50,
                        id: 2),

            Achievement(image: "month",
                        name: "One hard month...with some brakes",
                        description: "It is said, you will work about 125 times that in your entire life. (Achieved for working 720 hours)",
                        reward: 100,
                        id: 3),

            Achievement(image: "wind",
                        name: "8 hours on one project",
                        description: "So you can focus on a sinlge project for at least a little bit. Congrats for working 8 hours on a project.",
                        reward: 10,
                        id: 4),

            Achievement(image: "fire",
                        name: "80 hours on one project",
                        description: "The numbers are getting serious. But just saying, some people do that in a week. How much time did you need?",
                        reward: 100,
                        id: 5),

            Achievement(image: "lightning",
                        name: "At this point...",
                        description: "...I hope I get some credit. Congratulations for working 800 hours on one project.",
                        reward: 1000,
                        id: 6),

            Achievement(image: "happy",
                        name: "That was nice",
                        description: "Achieved for completing a project successfully.",
                        reward: 75,
                        id: 7),

            Achievement(image: "crying",
                        name: "Sometimes it works, sometimes it doesn't",
                        description: "Maybe this achievement helps you feel better. (Achieved for quitting a project)",
                        reward: 1,
                        id: 8),

            Achievement(image: "neutral",
                        name: "And I thought you gave up",
                        description: "It really was time you picked that up again. (Achieved for continuing a project after pausing it)",
                        reward: 10,
                        id: 9),

            Achievement(image: "worker",
                        name: "Normal human numbers",
                        description: "Don't feel too good about it, it shouldn't be less. (Achieved for working 40 hours in the last 7 days)",
                        reward: 100,
                        id: 10),

            Achievement(image: "company",
                        name: "So you are getting started?",
                        description: "Achieved for working 60 hours in the last 7 days.",
                        reward: 250,
                        id: 11),

            Achievement(image: "rocket",
                        name: "To the moon",
                        description: "80 hours in a week? Even I can't complain anymore. Keep it up.",
                        reward: 500,
                        id: 12),

            Achievement(image: "newyear",
                        name: "Annoying fireworks",
                        description: "I am not really sure what to say. Either you cheated or you really worked through new years eve. Which option is sadder?",
                        reward: -10,
                        id: 13)
        ]
        
    func getProjectImages(allProjects: FetchedResults<Project>) -> [ProjectImage]{
        let indicies = UserDefaults.standard.array(forKey: "indicies") as? [String] ?? [String]()
        let xCoordinates = UserDefaults.standard.array(forKey: "xCoordinates") as? [Int] ?? [Int]()
        let yCoordinates = UserDefaults.standard.array(forKey: "yCoordinates") as? [Int] ?? [Int]()
        
        var projectImages = [ProjectImage]()
        for i in 0..<indicies.count {
            let uuid = UUID(uuidString: indicies[i])
            if uuid != nil {
                let project = allProjects.first(where: {$0.id == uuid!})
                if project != nil {
                    projectImages.append(ProjectImage(id: uuid!, project: project, x: CGFloat(xCoordinates[i]), y: CGFloat(yCoordinates[i])))
                }
            }
        }
        return projectImages
    }
    
    func setProjectImages(selectedProjectImages: [ProjectImage]){
        var indicies = [String]()
        var xCoordinates = [Int]()
        var yCoordinates = [Int]()
        for i in 0..<selectedProjectImages.count {
            indicies.append(selectedProjectImages[i].id.uuidString)
            xCoordinates.append(Int(selectedProjectImages[i].x))
            yCoordinates.append(Int(selectedProjectImages[i].y))
        }
        UserDefaults.standard.setValue(indicies, forKey: "indicies")
        UserDefaults.standard.setValue(xCoordinates, forKey: "xCoordinates")
        UserDefaults.standard.setValue(yCoordinates, forKey: "yCoordinates")
    }
    
    func setAchievements(achievements: [Achievement]){
        var achieved: [Int] = []
        for achievement in achievements{
            if(achievement.isAchieved){
                achieved.append(achievement.id)
            }
        }
        self.achievements = achievements
        UserDefaults.standard.setValue(achieved, forKey: "achievments")
    }

    func getAchievements(ids: [Int]) -> [Achievement]{
        var achieved: [Achievement] = []
        for i in 0..<achievements.count {
            for id in ids {
                if(achievements[i].id == id && ids.contains(achievements[i].id)){
                    achievements[i].isAchieved = true
                }
            }
            achieved.append(achievements[i])
        }
        return achieved
    }

    func newAchievement(id: Int) -> Void {
        if(!achievements[id].isAchieved){
            AudioServicesPlaySystemSound(1325)
            
            achievements[id].isAchieved = true
            achievements[id].date = Date()
            
            /* TODO: Notification */
            setAchievements(achievements: achievements)
        }
    }
    
    
}

struct ProjectImage: Identifiable {
    var id: UUID
    var project: Project?
    var x: CGFloat
    var y: CGFloat
    
}


struct Achievement: Identifiable {
    var isAchieved: Bool = false
    var date = Date()
    let image: String
    let name: String
    let description: String
    let reward: Int
    let id: Int
}
