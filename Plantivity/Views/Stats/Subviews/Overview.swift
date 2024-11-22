import SwiftUI

struct Value {
    let icon: Int
    var value: Double
}

struct Overview: View {
    @EnvironmentObject var themeData: ThemeData
    
    var center: CGPoint
    var size: CGFloat
    var iconSize: CGFloat
    var values: [Value]
    var icons: [Icon]
    
    var body: some View {
        ZStack{
            ForEach(0..<5){ i in
                Path { path in
                    var previousPoint: CGPoint? = nil
                    var newPoint: CGPoint? = nil
                    
                    for j in 0..<icons.count + 1 {
                        let alpha = (2 * CGFloat.pi * CGFloat(j) / CGFloat(icons.count)) - CGFloat.pi/2
                        let x = size / 2 * cos(alpha)
                        let y = size / 2 * sin(alpha)
                        
                        newPoint = CGPoint(x: center.x + CGFloat(i + 1) / 5 * x , y: center.y + CGFloat(i + 1) / 5 * y)
                        
                        if(j == 0){
                            path.move(to: newPoint!)
                        }
                        
                        if(previousPoint != nil){
                            path.addLine(to: newPoint!)
                        }
                        
                        previousPoint = newPoint
                    }
                }
                .fill(themeData.theme.accentColor.opacity(0.2))
            }
            ForEach(icons){ icon in
                if let index = icons.firstIndex(where: {i in i.id == icon.id}){
                    let alpha = Double(2 * CGFloat.pi * CGFloat(index) / CGFloat(icons.count) - CGFloat.pi/2)
                    
                    Image(systemName: icon.image)
                        .foregroundColor(themeData.theme.textColor)
                    .rotationEffect(.radians(-alpha))
                    .offset(x: size/2 + iconSize/2)
                    .rotationEffect(.radians(alpha))
                }
            }
            
            Path { path in
                if(values.count > 0){
                    var prevValuePoint: CGPoint? = nil
                    var newValuePoint: CGPoint? = nil
                    
                    for j in 0..<values.count + 1 {
                        let alpha = (2 * CGFloat.pi * CGFloat(j) / CGFloat(icons.count)) - CGFloat.pi/2
                        let x = size / 2 * cos(alpha)
                        let y = size / 2 * sin(alpha)
                        var value =  CGFloat(values[j < values.count ? j : 0].value)
                        value = value <= 0.05 ? 0.05 : value
                        
                        newValuePoint = CGPoint(x: center.x + value * x , y: center.y + value * y)
                        
                        if(j == 0){
                            path.move(to: newValuePoint!)
                        }
                        
                        if(prevValuePoint != nil){
                            path.addLine(to: newValuePoint!)
                        }
                        
                        prevValuePoint = newValuePoint
                    }
                }
            }
            .fill(themeData.theme.statsColor.opacity(0.7))
        }
    }
}
