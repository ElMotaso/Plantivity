import SwiftUI

struct StoreView: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var storeData: StoreData

    
    @Environment(\.presentationMode) var presentationMode
    @State var selectedItem: Item? = nil
    @State var showMenu: Bool = false
    
    var gridItemLayout: [GridItem] = [GridItem(.adaptive(minimum: 100))]
    
    @State var popupText = "You don't have enough coins."
    @State var popupBackgroundColor = Color.red
    @State var popupTextColor = Color.black
    
    @State var showErrorPopup = false
        
    var body: some View {
        NavigationView{
            Popup(backgroundColor: popupBackgroundColor, textColor: popupTextColor, text: popupText ,show: $showErrorPopup, doublePadding: true) {
                ZStack{
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: gridItemLayout, spacing: 10) {
                            ForEach(storeData.items, id: \.id){ item in
                                StoreItem(item: item, selectedItem: $selectedItem)
                                    .padding(.bottom)
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 60)
                    }
                    .padding(.horizontal)
                    if selectedItem != nil {
                        GeometryReader{ geometry in
                            StorePopupMenu(selectedItem: $selectedItem, showErrorPopup: $showErrorPopup)
                                .padding(.top, geometry.size.height/5)
                                .padding(.horizontal)
                        }
                        .background(Color(themeData.theme.isDark ? .gray : .black).opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            selectedItem = nil
                        }
                    }
                    
                }
                .navigationBarTitle(Text("Shop"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
                .navigationBarItems(
                    leading:
                        HStack{
                            Image(systemName: "dollarsign.circle")
                                .foregroundColor(themeData.theme.textColor)
                            ColoredText(text: String(storeData.coins))
                        }
                    ,
                    trailing:
                        NavigationLink(destination: SettingsView()){
                            Image(systemName:"gearshape")
                        }
                )
            }
            .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
        }
    }
}
