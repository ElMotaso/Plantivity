//
//  PlantSelector.swift
//  Plantivity
//
//  Created by Bania on 23.06.22.
//

import SwiftUI

struct PlantSelector: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var storeData: StoreData
    @EnvironmentObject var settings: Settings
        
    var gridItemLayout: [GridItem] = [GridItem(.adaptive(minimum: 100))]
    
    @Binding var selectedPlant: Int16?
    var items: [Item] {
        return storeData.getItems(includeItems: false)
    }
    
    var body: some View {
        if !items.isEmpty {
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: gridItemLayout, spacing: 10) {
                    ForEach(storeData.getItems(includeItems: false), id: \.id){ item in
                        PlantItem(item: item, selectedPlant: $selectedPlant)
                    }
                }
                .padding(.top)
            }
            .padding()
        } else {
            Spacer()
            ColoredText(text: "You have no seeds!", bold: false, spacer: false)
            .opacity(0.6)
            HStack {
                Spacer()
                ColoredText(text: "To buy seeds click", bold: false, spacer: false)
                    .opacity(0.6)
                /*Button(action: {
                    settings.selection = 4
                }, label: {
                    Text("here.")
                        .underline()
                        .foregroundColor(themeData.theme.accentColor)
                })*/
                NavigationLink(destination: StoreView()){
                    Text("here.")
                        .underline()
                        .foregroundColor(themeData.theme.accentColor)
                }
                .padding(.leading, -2)
                Spacer()
            }
            Spacer()
        }
    }
}
