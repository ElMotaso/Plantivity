import SwiftUI

struct ThemeButton: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    
    var theme: ThemeName
    var size: CGFloat
    
    var body: some View {
        Button (action: {
                themeData.setTheme(theme: theme)
                presentationMode.wrappedValue.dismiss()
                settings.selection = 2
            },
            label: {
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: size, height: size)
                .background(
                    themeData.getTheme(theme: theme).backgroundColor)
                .foregroundColor(
                    themeData.getTheme(theme: theme).textColor)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(Circle().stroke(Color.white, lineWidth: size/10))
                .shadow(radius: size/20)
        })
    }
}

struct ThemeButton_Previews: PreviewProvider {
    static var previews: some View {
        ThemeButton(theme: .white, size: 200)
    }
}
