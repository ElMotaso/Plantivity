import SwiftUI

struct ItemItem: View {
    @EnvironmentObject var storeData: StoreData
    @EnvironmentObject var themeData: ThemeData
    
    let item: Item
    let project: Project
    
    var body: some View {
        ZStack {
            Button(action: {storeData.useItem(id: Int(item.id), project: project)}){
                if item.image.hasPrefix("I") {
                    Text(item.image)
                        .frame(width: 60, height: 60)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                        .foregroundColor(themeData.theme.accentColor)
                } else {
                    Image(item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                        .foregroundColor(themeData.theme.accentColor)
                }
            }
            
            Text(String(item.count))
                .frame(maxWidth: 25)
                .frame(height: (25))
                .foregroundColor(themeData.theme.invertedTextColor)
                .background(
                    Circle()
                        .foregroundColor(themeData.theme.accentColor)
                )
                .offset(x: 25, y: -25)
        }
        
    }
}
