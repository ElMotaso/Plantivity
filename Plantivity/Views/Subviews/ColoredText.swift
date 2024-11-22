import SwiftUI

struct ColoredText: View {
    @EnvironmentObject var themeData: ThemeData
    var text: String
    var bold: Bool = true
    var spacer: Bool = true
    
    var body: some View {
        HStack {
            if(bold){
                Text(text)
                    .bold()
                    .foregroundColor(themeData.theme.textColor)
            } else {
                Text(text)
                    .foregroundColor(themeData.theme.textColor)
            }
            if(spacer) {
                Spacer()
            }
        }
    }
}
