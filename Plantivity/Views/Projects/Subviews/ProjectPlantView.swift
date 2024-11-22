//
//  ProjectPlantView.swift
//  Plantivity
//
//  Created by Bania on 28.06.22.
//

import SwiftUI

struct ProjectPlantView: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var plantsData: PlantsData
    @EnvironmentObject var storeData: StoreData

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var project: Project
    
    var gridItemLayout: [GridItem] = [GridItem(.adaptive(minimum: .infinity))]
    var items: [Item] {
        return storeData.getItems(includePlants: false)
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if (plantsData.getImageOfProject(project: project).hasPrefix("P")){
                    Text(plantsData.getImageOfProject(project: project))
                        .frame(maxWidth: .infinity)
                        .frame(height: 450)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                        .foregroundColor(themeData.theme.accentColor)
                        .padding()
                }
                else {
                    VStack {
                        ColoredText(text: project.name ?? "Unknown Project", bold: true, spacer: false)
                            .padding(.top)
                            .font(.title)
                        Image(plantsData.getImageOfProject(project: project))
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 450)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                            .foregroundColor(themeData.theme.accentColor)
                            .padding(.bottom)
                            .padding(.horizontal)
                    }
                }
                Spacer()
            }
            if !items.isEmpty {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(items, id: \.id){ item in
                            ItemItem(item: item, project: project)
                                .padding(.vertical)
                                .padding(.horizontal, 7)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .background(themeData.theme.backgroundColor)
        .cornerRadius(15)
    }
}


