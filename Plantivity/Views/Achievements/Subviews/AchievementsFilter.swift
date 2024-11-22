import SwiftUI

struct AchievmentsFilterView: View {
    @EnvironmentObject var themeData: ThemeData
    
    @Binding var showAchieved: Bool
    @Binding var showUnachieved: Bool
    
    var body: some View {
        VStack{
            ColoredText(text: "Filter:")
                .padding(.bottom)
            Toggle(isOn: $showAchieved){
                ColoredText(text: "Show achieved achievments:", bold: false)
            }
            .padding(.top, 5)
            .padding(.bottom)
            Toggle(isOn: $showUnachieved){
                ColoredText(text: "Show unachieved achievments:", bold: false)
            }
            .padding(.top, 5)
        }.padding()
        .background(themeData.theme.backgroundColor)
        .cornerRadius(15)
    }
}
//
//struct AchievmentsFilterView_Previews: PreviewProvider {
//    static var previews: some View {
//        AchievmentsFilterView()
//    }
//}
