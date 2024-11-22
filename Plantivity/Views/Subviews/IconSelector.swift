import SwiftUI

struct IconSelector: View {
    @EnvironmentObject var iconData: IconData
    @Namespace var namespace
    
    @State var selectedIcons: [Icon] = []
    
    var body: some View {
        VStack{
            ColoredText(text: "Statistics Icons:")
                .padding(.bottom)
                .padding(.horizontal)
            HStack{
                ForEach(selectedIcons){ icon in
                    Button(action: {
                        withAnimation {
                            if let index = selectedIcons.firstIndex(where: {i in i.id == icon.id}){
                                selectedIcons.remove(at: index)
                                iconData.setSelectedIcons(icons: selectedIcons)
                            }
                        }
                    }){
                        Image(systemName: icon.image)
                    }
                }
            }
            Divider()
                .padding(.horizontal)
            LazyVGrid(columns: [ GridItem(.adaptive(minimum: 80)) ]){
                ForEach(iconData.icons){ icon in
                    Button(action: {
                            withAnimation {
                                selectedIcons.append(icon)
                                iconData.setSelectedIcons(icons: selectedIcons)
                            }
                    }){
                        if(!selectedIcons.contains(where: {i in i.id == icon.id})){
                            Image(systemName: icon.image)
                        }
                    }.disabled(selectedIcons.contains(where: {i in i.id == icon.id}))
                }
            }
        }
        .onAppear(){
            selectedIcons = iconData.selectedIcons
        }
    }
}
