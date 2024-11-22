import SwiftUI

struct TabBar: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeData: ThemeData
    
    var images: [String]
    @Binding var currentTab: Int
    
    @Namespace var animationId
    var radius: CGFloat = 2
    var width: CGFloat = 50
    
    @State var showAddView = false
    
    var body: some View {
        HStack {
            ForEach(0..<2) { i in
                TabBarButton(currentTab: $currentTab, tag: i, image: images[i], animationId: animationId)
            }
            Button(
                action: {
                    //withAnimation(.spring().speed(1.8)) {
                        currentTab = 2
                    //}
                },
                label: {
                    ZStack{
                        Circle()
                            .fill(themeData.theme.accentColor)
                            .frame(width: width, height: width)
                        Image(systemName: images[2])
                            .accentColor(themeData.theme.invertedTextColor)
                    }
                })
                .offset(y: -30)
            ForEach(3..<5) { i in
                TabBarButton(currentTab: $currentTab, tag: i, image: images[i], animationId: animationId)
            }
        }
        .padding(.bottom)
        .padding(.top)
        .background(
            ZStack{
                (themeData.theme.isDark ? Color.black : Color.gray.opacity(0.10))
                    .ignoresSafeArea()
                    .clipShape(
                        TabBarShape(width: width*1.2)
                        )
                VisualEffectView(effect: UIBlurEffect(style: themeData.theme.isDark ? .dark : .regular)).clipShape(
                        TabBarShape(width: width*1.2)
                    )
            }
        )
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct TabBarButton: View {
    @EnvironmentObject var themeData: ThemeData
    
    @Binding var currentTab: Int
    var tag: Int
    
    var image: String
    var animationId: Namespace.ID
    
    var radius: CGFloat = 1
    var width: CGFloat = 50
    var space: CGFloat = -3
    
    var body: some View {
        Button(action: {
            //withAnimation(.spring().speed(1.8)) {
                currentTab = tag
            //}
        }, label: {
            VStack {
                Image(systemName: image)
                    .padding(.bottom, space)
                if(currentTab == tag){
                    RoundedRectangle(cornerRadius: 1)
                        .frame(width: width, height: 1)
                        .matchedGeometryEffect(id: "TAB", in: animationId)
                } else {
                    RoundedRectangle(cornerRadius: 1)
                        .foregroundColor(.clear)
                        .frame(width: width, height: 1)
                }
            }
            .accentColor(themeData.theme.accentColor)
            .frame(maxWidth: .infinity)
        })
    }
}

struct TabBarShape: Shape {
    var width: CGFloat
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: width/5))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: width/5))
            
            path.move(to: CGPoint(x: (rect.width - width) / 2, y: width/5))
            path.addArc(
                center: CGPoint(x: rect.width / 2, y: width/5),
                radius: width / 2,
                startAngle: .zero,
                endAngle: .init(degrees: 180),
                clockwise: false)
        }
    }
}
