import Foundation
import SwiftUI
import AVFoundation

class ThemeData: ObservableObject{

    @Published var theme = Theme(backgroundColor: Color.white, textColor: Color.black, invertedTextColor: Color.white, accentColor: Color.blue, symbol: "square.and.pencil")

    func setTheme(theme: ThemeName) {
        self.theme = getTheme(theme: theme)
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(self.theme.accentColor)
        
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(self.theme.backgroundColor)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(self.theme.textColor)]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(self.theme.accentColor)

        UserDefaults.standard.setValue(theme.rawValue, forKey: "themeName")

    }

    func getTheme(theme: ThemeName) -> Theme{
        switch theme {
        case .white:
            return Theme(
                backgroundColor: Color.white,
                textColor: Color.black,
                invertedTextColor: Color.white,
                accentColor: Color.blue,
                statsColor: Color.gray,
                isDark: false,
                symbol: "square.and.pencil")
        case .black:
            return Theme(
                backgroundColor: Color.black,
                textColor: Color.white,
                invertedTextColor: Color.black,
                accentColor: Color.blue,
                statsColor: Color(red: 0.40, green: 0.40, blue: 0.40),
                isDark: true,
                symbol: "square.and.pencil")
        case .red:
            return Theme(
                backgroundColor: Color(red: 0, green: 0, blue: 0),
                textColor: Color(red: 0.75, green: 0.20, blue: 0.20),
                invertedTextColor: Color.black,
                accentColor: Color(red: 0.75, green: 0.20, blue: 0.20),
                statsColor: Color(red: 0.75, green: 0.20, blue: 0.20),
                isDark: true,
                symbol: "flame",
                soundId: 1009
            )
        case .blue:
            return Theme(
                backgroundColor: Color(red: 0.10, green: 0.46, blue: 0.62),
                textColor:  Color(red: 0.52, green: 0.73, blue: 0.60),
                invertedTextColor: Color.white,
                accentColor:  Color(red: 0.52, green: 0.73, blue: 0.60),
                statsColor:  Color(red: 0.52, green: 0.73, blue: 0.60),
                isDark: false,
                symbol: "power",
                soundId: 1008
            )
        }
    }
}


    struct Theme {
    var backgroundColor = Color.white
    var textColor = Color.black
    var invertedTextColor = Color.black
    var accentColor = Color.blue
    var statsColor = Color.blue
    var isDark = false
    var symbol = ""
    var soundId: SystemSoundID = 1005
    }

    enum ThemeName: String{
    case white
    case black
    case red
    case blue
    }

    func StringToThemeName(string: String) -> ThemeName {
    switch string {
    case "white":
        return .white
    case "black":
        return .black
    case "blue":
        return .blue
    case "red":
        return .red
    default:
        return .white
    }
}
