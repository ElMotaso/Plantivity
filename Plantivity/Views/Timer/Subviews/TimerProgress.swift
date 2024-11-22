import SwiftUI

struct TimerProgress: View {
    @EnvironmentObject var themeData: ThemeData
    @Binding var progress: Double
    var thickness: CGFloat
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(lineWidth: thickness)
                    .opacity(0.3)
                    .foregroundColor(themeData.theme.textColor)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
                    .foregroundColor(themeData.theme.textColor)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(progress == 1.0 ? .none : .linear)
            }
        }
}
