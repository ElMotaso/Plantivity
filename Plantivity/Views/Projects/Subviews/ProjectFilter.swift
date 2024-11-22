import SwiftUI

struct ProjectFilter: View {
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    @Binding var selectedStatesFilter: [Int]
    @Binding var selectedIconsFilter: [Int]
    
    var body: some View {
        VStack{
            ColoredText(text: "Filter:")
                .padding(.bottom)
        
            ColoredText(text: "States:", bold: false)
            HStack{
                ForEach(settings.states.indices, id: \.self){i in
                    Button(
                        action: {
                            if(selectedStatesFilter.contains(i)){
                                if let index = selectedStatesFilter.firstIndex(of: i) {
                                    selectedStatesFilter.remove(at: index)
                                }
                            } else {
                                selectedStatesFilter.append(i)
                            }
                        }
                        ,label: {
                            Image(systemName: settings.states[i] + ".circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(themeData.theme.accentColor.opacity(selectedStatesFilter.contains(i) ? 1 : 0.3))
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 5)
            .padding(.bottom)
            ColoredText(text: "Icons:", bold: false)
            HStack{
                ForEach(0..<iconData.icons.count/2, id: \.self){i in
                    Button(
                        action: {
                            if(selectedIconsFilter.contains(iconData.icons[i].id)){
                                if let index = selectedIconsFilter.firstIndex(of: iconData.icons[i].id) {
                                    selectedIconsFilter.remove(at: index)
                                }
                            } else {
                                selectedIconsFilter.append(iconData.icons[i].id)
                            }
                        }
                        ,label: {
                            Image(systemName: iconData.icons[i].image)
                                .foregroundColor(themeData.theme.accentColor.opacity(selectedIconsFilter.contains(iconData.icons[i].id) ? 1 : 0.3))
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            HStack{
                ForEach(iconData.icons.count/2..<iconData.icons.count, id: \.self){i in
                    Button(
                        action: {
                            if(selectedIconsFilter.contains(iconData.icons[i].id)){
                                if let index = selectedIconsFilter.firstIndex(of: iconData.icons[i].id) {
                                    selectedIconsFilter.remove(at: index)
                                }
                            } else {
                                selectedIconsFilter.append(iconData.icons[i].id)
                            }
                        }
                        ,label: {
                            Image(systemName: iconData.icons[i].image)
                                .foregroundColor(themeData.theme.accentColor.opacity(selectedIconsFilter.contains(iconData.icons[i].id) ? 1 : 0.3))
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 5)
        }.padding()
        .background(themeData.theme.backgroundColor)
        .cornerRadius(15)
    }
}
