import SwiftUI

struct ThemeSelector: View {
    
    var body: some View {
        HStack{
            ColoredText(text: "Theme:", spacer: false)
            HStack{
                ThemeButton(theme: .white, size: 40)
                    .frame(maxWidth: .infinity)
                ThemeButton(theme: .black, size: 40)
                    .frame(maxWidth: .infinity)
                ThemeButton(theme: .blue, size: 40)
                    .frame(maxWidth: .infinity)
                ThemeButton(theme: .red, size: 40)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct ThemeSelector_Previews: PreviewProvider {
    static var previews: some View {
        ThemeSelector()
    }
}


