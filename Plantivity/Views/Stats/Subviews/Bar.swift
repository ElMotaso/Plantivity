import SwiftUI

struct Bar: View {
    @EnvironmentObject var themeData: ThemeData
    
    var value: CGFloat
    var description: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack{
            ZStack (alignment: .bottom){
                let val = value != 0 ? max(value, width/height) : 0
                
                Capsule().frame(width: width, height: height)
                    .foregroundColor(themeData.theme.statsColor.opacity(0.2))
                Capsule().frame(width: width, height: abs(height*val))
                    .foregroundColor(themeData.theme.accentColor)
            }
            ColoredText(text: description)
        }
    }
}
