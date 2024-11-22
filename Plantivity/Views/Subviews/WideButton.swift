import SwiftUI

struct WideButton: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    

    var text: String
    var action: () -> Void
    var color: Color? = nil
    
    var body: some View {
        Button(
            action: action,
            label: {
                Text(text)
                    .frame(maxWidth: .infinity)
                    .frame(height: (2/3 * settings.size))
                    .background(RoundedRectangle(cornerRadius: 8).fill(color ?? themeData.theme.textColor))
                    .foregroundColor(themeData.theme.invertedTextColor)
            }
        )
    }
}
