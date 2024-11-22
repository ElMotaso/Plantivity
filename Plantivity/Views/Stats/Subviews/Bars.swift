import SwiftUI

struct Bars: View {
    
    var value: [CGFloat]
    var pickedTime: Int
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        HStack{
            ForEach(0...pickedTime - 1, id: \.self){ i in
                Bar(value: value[i], description: "", width: (2/3)*width/CGFloat(pickedTime), height: height)
            }
        }
    }
}
