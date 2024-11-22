import SwiftUI

struct Popup<Content: View>: View {
    @EnvironmentObject var themeData: ThemeData
    let backgroundColor: Color
    let textColor: Color

    let text: String
    
    @Binding var show: Bool
    
    var background: Bool = false
    var doublePadding: Bool = false
        
    let content: () -> Content

    var body: some View {
        ZStack{
            if(background){
                themeData.theme.backgroundColor
                    .ignoresSafeArea()
            }
            
            self.content()
            
            if show {
                GeometryReader{ geometry in
                    ZStack{
                        RoundedRectangle(cornerRadius: geometry.size.width*0.02)
                            .fill(backgroundColor)
                            .frame(width: geometry.size.width*0.9, height: 50)
                        Text(text)
                            .frame(width: geometry.size.width*0.8)
                            .foregroundColor(textColor)
                    }
                    .padding(.top, doublePadding ? geometry.size.height*0.12 : geometry.size.height*0.05)
                    .padding(.horizontal, geometry.size.width*0.05)
                }
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    show.toggle()
                }
            }
        }
    }
}
