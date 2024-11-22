import SwiftUI

struct Slider: View {
    @EnvironmentObject var themeData: ThemeData

    @Binding var result: Int
    var maxResult: Int
    
    var height: CGFloat = 5
    var size: CGFloat = 15
    @State var offset: CGFloat = 0
    
    var body: some View {
        VStack{
            GeometryReader { geometry in
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
                    Capsule()
                        .fill(Color.black.opacity(0.25))
                        .frame(height: height)
                    
                    Capsule()
                        .fill(themeData.theme.accentColor)
                        .frame(width: offset + size/2, height: height)
                    Circle()
                        .fill(themeData.theme.accentColor)
                        .frame(width: size, height: size)
                        .offset(x: offset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let width = geometry.size.width - size
                                    if(value.location.x < size/2){
                                        result = 0
                                    } else if(value.location.x > size/2 && value.location.x < geometry.size.width - size/2){
                                        result = Int(round((value.location.x + size/2) * CGFloat(maxResult) / width))
                                    } else {
                                        result = maxResult
                                    }
                                    offset = CGFloat(result) * width / CGFloat(maxResult)
                                
                                }
                                .onEnded { value in
                                    if(value.location.x < size/2){
                                        result = 0
                                    } else if(value.location.x > size/2 && value.location.x < geometry.size.width - size/2){
                                        let width = geometry.size.width - size
                                        result = Int(round((value.location.x + size/2) * CGFloat(maxResult) / width))
                                    } else {
                                        result = maxResult
                                    }
                                }
                        )
                    }
            }
        }
        .frame(height: max(height, size))
    }
}
