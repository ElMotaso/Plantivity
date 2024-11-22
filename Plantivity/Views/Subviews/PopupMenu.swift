import SwiftUI

struct PopupMenu<Content: View, PopupContent: View>: View {
    @EnvironmentObject var themeData: ThemeData
    
    @Binding var show: Bool
    
    let content: () -> Content
    let popupContent: () -> PopupContent

    var body: some View {
        ZStack{
            content()
            if show {
                GeometryReader{ geometry in
                    popupContent()
                        .padding(.top, geometry.size.height/3)
                        .padding(.horizontal)
                }
                .background(Color(themeData.theme.isDark ? .gray : .black).opacity(0.5))
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    show.toggle()
                }
            }
        }
    }
}
