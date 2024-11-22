
import SwiftUI

struct PlantImage: View {
    @EnvironmentObject var plantsData: PlantsData
    
    @Binding var projectImage: ProjectImage
    
    @Binding var isEditing: Bool
    
    @GestureState var offset = CGSize.zero
    
    var body: some View {
        if isEditing {
            if (projectImage.project != nil){
                Image(plantsData.getImageOfProject(project: projectImage.project!))
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .offset(
                        x: offset.width,
                        y: offset.height)
                    .animation( offset.width + offset.height > 0 ? .easeInOut : .none, value: offset)
                    .offset(
                        x: projectImage.x,
                        y: projectImage.y)
                    .gesture(
                        DragGesture()
                            .updating($offset, body: { (value, state, transaction) in
                                state = value.translation
                            })
                            .onEnded { value in
                                projectImage.x += value.translation.width
                                projectImage.y += value.translation.height
                            }
                )
            }
        } else {
            if (projectImage.project != nil){
                Image(plantsData.getImageOfProject(project: projectImage.project!))
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .offset(
                    x: projectImage.x + offset.width,
                    y: projectImage.y + offset.height)
            }
        }
    }
}
