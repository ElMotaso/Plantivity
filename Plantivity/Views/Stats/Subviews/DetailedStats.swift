import SwiftUI

struct DetailedStats: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var stats: Stats

    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.name, ascending: true)]
    ) var projects: FetchedResults<Project>
    
    let time: (Int, Int, Date, Int, [Int], Date, String)
    
    var body: some View {
        //let time = stats.getTime(projects: projects)
        let timeSum = time.0
        let sessioCount = time.1
        let oldestDate = time.2
        let averageTime = time.3
        let dayArray = time.4
        let mostProductiveDay = time.5
        let mostProductiveTime = time.6
        
        
        VStack{
            ColoredText(text: "Overview:")
                .padding(.bottom)
            HStack{
                ColoredText(text: "Time worked:", bold: false)
                Spacer()
                ColoredText(text: stats.secondsToHoursMinutesSeconds(seconds: timeSum), bold: false)
            }
            HStack{
                ColoredText(text: "Sessions completed:", bold: false)
                Spacer()
                ColoredText(text: String(sessioCount), bold: false)
            }
            HStack{
                ColoredText(text: "You started on:", bold: false)
                Spacer()
                ColoredText(text: formatDate(date: oldestDate) + ", " + ((dayArray.count != 1) ? (String(dayArray.count) + " days ago.") : ("Today")), bold: false)
            }
            HStack{
                ColoredText(text: "Average per day:", bold: false)
                Spacer()
                ColoredText(text: stats.secondsToHoursMinutesSeconds(seconds: averageTime), bold: false)
            }
            HStack{
                ColoredText(text: "Most productive day:", bold: false)
                Spacer()
                ColoredText(text: formatDate(date: mostProductiveDay) + " (" + mostProductiveTime + ")", bold: false)
            }
            HStack{
                ColoredText(text: "Time worked today:", bold: false)
                Spacer()
                ColoredText(text: stats.getDayTime(projects: projects), bold: false)
            }
        }.padding()
        .background(themeData.theme.backgroundColor)
        .cornerRadius(15)
    }
}
