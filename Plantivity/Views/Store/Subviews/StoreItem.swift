import SwiftUI

struct StoreItem: View {
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var themeData: ThemeData
    
    let item: Item
    @Binding var selectedItem: Item?
    
    var body: some View {
        ZStack {
            Button(action: {
                selectedItem = item
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
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeData.theme.textColor, lineWidth: 1)
                        .frame(maxWidth: .infinity)
                        .frame(height: (25))
                        .foregroundColor(themeData.theme.textColor)
                        .offset(y: 100)
                        .padding(.horizontal, 15)
                }
            })
            HStack{
                Image(systemName: "dollarsign.circle")
                if item.price != 0 {
                    Text(String(item.price))
                } else {
                    Text("Free")
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: (24))
            .foregroundColor(themeData.theme.textColor)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(themeData.theme.isDark ? .black : .white))
            )
            .offset(y: 100)
            .padding(.horizontal, 16)
        }
    }
}
