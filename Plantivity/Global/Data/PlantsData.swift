import Foundation
import SwiftUI
import AVFoundation

class PlantsData: ObservableObject{
    @Published var plants: [Plant] = [
        Plant(id: 0,
              name: "Sunflower",
              intervall: 7,
              images: ["sunflower_0", "sunflower_4", "sunflower_2", "sunflower_3", "sunflower_4", "sunflower_5"],
              reward: [0, 1, 2, 3, 4, 5], // Fair would be double of that compared to other flowers
              work: [0, 900, 1800, 3600, 5400, 7200], // Daily average: 15 minutes, 30 minutes, 1 hour, 1.5 hours, 2 hours
              frozen: false),
        Plant(id: 1,
              name: "Cactus",
              intervall: 30,
              images: ["cactus_0", "cactus_4", "cactus_2", "cactus_3", "cactus_4", "cactus_5"],
              reward: [0, 2, 4, 6, 7, 9],
              work: [0, 300, 900, 1800, 3600, 5400], // Daily average: 5 minutes, 15 minutes, 30 minutes, 1 hours, 1.5 hours
              frozen: false),
        
        Plant(id: 2,
              name: "Orchid",
              intervall: 1,
              images: ["Orchid, Tier F", "Orchid, Tier D", "Orchid, Tier C", "Orchid, Tier B", "Orchid, Tier A", "Orchid, Tier S"],
              reward: [0, 1, 2, 3, 4, 5],
              work: [0, 1800, 3600, 5400, 7200, 9000], // Daily: 30 minutes, 1 hour, 1.5 hours, 2 hours, 2.5 hours
              frozen: false),
    
        Plant(id: 3,
              name: "Banian Tree",
              intervall: 365,
              images: ["Banian Tree, Tier F", "Banian Tree, Tier D", "Banian Tree, Tier C", "Banian Tree, Tier B", "Banian Tree, Tier A", "Banian Tree, Tier S"],
              reward: [0, 4, 9, 16, 25, 36],
              work: [0, 900, 1800, 3600, 5400, 7200], // Daily: 15 minutes, 30 minutes, 1 hour, 1.5 hours, 2 hours
              frozen: false)
    ]
    
    func dayDifference(firstDate: Date, secondDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: firstDate, to: secondDate).day ?? 0
    }
    ////////////////
    func getTierOfProject(project: Project) -> Int {
        if project.state != 0 {
            return Int(project.tier)
        }
        if(project.plant == -1){
            return -1
        }
        if (project.tier == 0) {
            return 0
        }
        let plant = plants[Int(project.plant)]
        let nextNeededTierUpdate = Calendar.current.date(byAdding: .day, value: plant.intervall, to: project.lastTierUpdate!)
        if nextNeededTierUpdate! > Date() {
            return Int(project.tier)
        }
        let relevantSessions = project.sessionsArray?.filter { session in
            return plant.intervall >  dayDifference(firstDate: session.day!, secondDate: nextNeededTierUpdate!)
        } ?? []
        
        let timeWorked = relevantSessions.map{Int($0.time)}.reduce(0, +) / plant.intervall
        if (timeWorked <= plant.work[Int(project.tier)]) {
            project.tier = project.tier - 1
        } else if Int(project.tier) <= 4 && (timeWorked > plant.work[Int(project.tier) + 1]){
            project.tier = project.tier + 1
        }
        
        let timeSinceNeededUpdate = dayDifference(firstDate: nextNeededTierUpdate!, secondDate: Date())
        let intervalsSinceNeededUpdate = timeSinceNeededUpdate / plant.intervall
        project.tier =  min(5, max(0, project.tier - Int16(intervalsSinceNeededUpdate)))
        project.lastTierUpdate = Calendar.current.date(byAdding: .day, value: intervalsSinceNeededUpdate * plant.intervall, to: nextNeededTierUpdate!)
        
        if project.tier == 0 {
            project.state = 3
        }
        PersistenceController.shared.save()
        return Int(project.tier)
    }
    
    func getMaximalTiers(projects: FetchedResults<Project>) -> [Int] {
            var maxTier = Array(repeating: -1, count: plants.count)
            for project in projects {
                if(project.plant != -1){
                    maxTier[Int(project.plant)] = max(maxTier[Int(project.plant)], getTierOfProject(project: project))
                }
            }
            return maxTier
        }
    
    func getImageOfProject(project: Project) -> String {
        if(project.plant != -1){
            return self.plants[Int(project.plant)].images[getTierOfProject(project: project)]
        }
        return "unknown"
    }
    
    func getRewardOfProject(project: Project) -> Int {
        var currentProject: Project = project
        while (currentProject.parent != nil) {
            currentProject = currentProject.parent!
        }
        return self.plants[Int(currentProject.plant)].reward[getTierOfProject(project: currentProject)]
    }
}

struct Plant: Identifiable {
    let id: Int16
    let name: String
    let intervall: Int // days in which sessions are counted for tier
    let images: [String]
    var reward: [Int] //Coins per hour worked
    var work: [Int] // Average seconds needed per day to upgrade index tier
    var frozen: Bool
}
