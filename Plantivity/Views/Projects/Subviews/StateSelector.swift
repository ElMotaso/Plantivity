import SwiftUI

struct StateSelector: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    
    @Binding var state: Int16
    
    var body: some View {
        VStack {
            ColoredText(text: "State of Project:")
                .padding()
            HStack {
                ForEach(settings.states.indices, id: \.self){i in
                    Button(
                        action: {
                            state = Int16(i)
                        }
                        ,label: {
                            Image(systemName: settings.states[i] + ".circle")
                                .resizable()
                                .frame(width: settings.size, height: settings.size)
                                .opacity((state == Int16(i)) ? 1 : 0.3)
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .accentColor(themeData.theme.accentColor)
        }
    }
}
