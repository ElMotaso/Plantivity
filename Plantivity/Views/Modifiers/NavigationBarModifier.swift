import SwiftUI


struct NavigationBarColor: ViewModifier {
    init(backgroundColor: Color, textColor: Color, accentColor: Color) {

        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(backgroundColor)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(textColor)]

        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(accentColor)
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    func navigationBarColor(backgroundColor: Color, textColor: Color, accentColor: Color) -> some View {
        self.modifier(NavigationBarColor(backgroundColor: backgroundColor, textColor: textColor, accentColor: accentColor))
    }
}

//struct PickerClearBackground: ViewModifier {
//    init() {
//        UIPickerView.appearance().backgroundColor = .clear
//    }
//
//    func body(content: Content) -> some View {
//        content
//    }
//}
//
//extension View {
//    func pickerClearBackground() -> some View {
//        self.modifier(PickerClearBackground())
//    }
//}
