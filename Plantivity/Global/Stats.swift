import Foundation
import SwiftUI
import CoreData

class Stats: ObservableObject {
    @FetchRequest(
        entity: Session.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.day, ascending: true)]
    ) var sessions: FetchedResults<Session>
    
    /**
     *  returns:
     *  0: time worked all time
     *  1: session count
     *  2: date of first session
     *  3: average time worked per day
     *  4: array of days with time worked on it
     *  5: most productive day
     *  6: time worked on most productive day
     */
    func getTime(projects: FetchedResults<Project>) -> (Int, Int, Date, Int, [Int], Date, String) {
        var timeSum = 0
        var sessionCount = 0
        var oldestDate = Date()
        let calendar = Calendar.current
        
        
        
        for project in projects{
            if(project.level == 0) {
                timeSum += Int(project.time) //Time worked, since beginning
            }
            
            sessionCount += project.sessionsArray?.count ?? 0 //Number of completed sessions
            
            if(dayDifference(firstDate: project.start ?? Date(), secondDate: oldestDate) > 0){
                oldestDate = project.start ?? Date() //Updating oldest date stored in app
            }
        }
        
        let dayCount: Int = (calendar.dateComponents([.day], from: oldestDate, to: Date()).day ?? 0) + 1
        let size = dayDifference(firstDate: oldestDate, secondDate: Date())
        var mostProductiveDay = -1
        var mostProductiveTime = 0
        var days = [Int](repeating: 0, count: size + 1)
        var dayComponents = DateComponents()
        
        for project in projects {
            for session in project.sessionsArray ?? []{
                let date = session.day ?? Date()
                let difference = dayDifference(firstDate: oldestDate, secondDate: date)
                if(0 <= difference && difference <= size){
                    days[difference] += Int(session.time)
                }
            }
        }
        
        for i in 0...size {
            if(days[i] > mostProductiveTime){
                mostProductiveDay = i
                mostProductiveTime = days[i]
            }
        }
        dayComponents.day = mostProductiveDay + 1
        
        return (timeSum,
                sessionCount,
                oldestDate,
                timeSum/dayCount,
                days,
                calendar.date(byAdding: dayComponents, to: oldestDate) ?? Date(),
                secondsToHoursMinutesSeconds(seconds: mostProductiveTime))
    }

    
    func getDayTime(projects: FetchedResults<Project>) -> String {
        var sum = 0
        let calendar = Calendar.current
        for project in projects {
            for session in project.sessionsArray ?? []{
                if(calendar.isDateInToday(session.day ?? .distantPast)){
                    sum += Int(session.time)
                }
            }
        }
        return secondsToHoursMinutesSeconds(seconds: sum)
    }
    
    func getIconStats(projects: FetchedResults<Project>, selectedIcons: [Icon]) -> [Value] {
        var stats: [Value] = []
        var max: Double = 0

        for icon in selectedIcons {
            var sum: Double = 0
            for project in projects {
                if(project.icon == icon.id){
                    sum += Double(Int(project.time))
                    for subproject in project.subprojectsArray ?? []{
                        sum -= Double(Int(subproject.time))
                    }
                    if (max < sum){
                        max = sum
                    }
                }
            }
            stats.append(Value(icon: icon.id, value: sum))
        }
        if(max > 0){
            for i in 0..<stats.count {
                stats[i].value = stats[i].value/max
            }
        }
        return stats
    }
  
    
    func getStats(projects: FetchedResults<Project>, size: Int, days: [Int]) -> [CGFloat]{
        var stats = [CGFloat](repeating: 0, count: size)
        var max: CGFloat = 0
        var start = 0
        
        if(size == 12){
            var devider: CGFloat
            for i in 0...11 {
                devider = 30
                if(days.count > 30 * i){
                    for j in 0...29 {
                        if(days.count > 30 * i + j){
                            stats[11 - i] += CGFloat(days[days.count - 1 - i * 30 - j])
                        }
                        else if(j != 0) {
                            devider = CGFloat(j)
                            break
                        }
                    }
                    stats[11 - i] = stats[11 - i] / devider
                    if (stats[11 - i] > max){
                        max = stats[11 - i]
                    }
                }
            }
        }
        else{
            var index = 0
            
            if(size > days.count){
                start = size - days.count
            }
            for i in start..<size {
                index = days.count - size + i
                stats[i] = CGFloat(days[index])
                if(stats[i] > max){
                    max = stats[i]
                }
            }
        }
        if max > 0{
            for i in start..<size {
                stats[i] = stats[i] / max
            }
        }
        return stats
    }
    
    func dayDifference(firstDate: Date, secondDate: Date) -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.day], from: firstDate, to: secondDate).day ?? 0
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = (seconds % 3600) % 60
        let hours = ((h >= 10) ? String(h) : "0" + String(h))
        let mins = ((m >= 10) ? String(m) : "0" + String(m))
        let secs = ((s >= 10) ? String(s) : "0" + String(s))
        return hours + ":" + mins + ":" + secs
    }
}
