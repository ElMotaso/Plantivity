import SwiftUI

struct PlantItem: View {
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var themeData: ThemeData
    
    @Environment(\.presentationMode) var presentationMode

    
    let item: Item
    @Binding var selectedPlant: Int16?
    
    var body: some View {
        ZStack {
            Button(action: {
                selectedPlant = item.plantId
                presentationMode.wrappedValue.dismiss()
            }, label: {
                ZStack{
                    if item.image.hasPrefix("I") {
                        Text(item.image)
                            .frame(maxWidth: .infinity)
                            .frame(height: (200))
                            .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                            .foregroundColor(themeData.theme.accentColor)
                    } else {
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: (200))
                            .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                            .foregroundColor(themeData.theme.accentColor)
                    }
                }
            })
            Text(String(item.count))
                .frame(maxWidth: .infinity)
                .frame(height: (24))
                .foregroundColor(themeData.theme.invertedTextColor)
                .background(
                    Circle()
                        .foregroundColor(themeData.theme.accentColor)
                )
                .offset(y: -100)
                .offset(x: 60)
                .padding(.horizontal, 16)
        }
    }
}
