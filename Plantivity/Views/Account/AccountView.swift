import SwiftUI

struct AccountView: View {
    @EnvironmentObject var themeData: ThemeData

    var body: some View {
        NavigationView {
            List{
                NavigationLink(destination: SettingsView()){
                    ColoredText(text: "App Settings")
                }
                ColoredText(text: "Account Info")
                ColoredText(text: "Layout Settings")
            }.background(themeData.theme.backgroundColor)
            .navigationBarTitle(Text("Account"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape")
            })
        }
        .navigationBarColor(backgroundColor: themeData.theme.backgroundColor, textColor: themeData.theme.textColor, accentColor: themeData.theme.accentColor)
    }
}
