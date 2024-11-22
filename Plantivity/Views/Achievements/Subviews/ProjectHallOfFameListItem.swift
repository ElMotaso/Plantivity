//
//  ProjectHallOfFameListItem.swift
//  Plantivity
//
//  Created by Bania on 06.09.22.
//

import SwiftUI

struct ProjectHallOfFameListItem: View {
    @EnvironmentObject var iconData: IconData
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var plantsData: PlantsData
    @ObservedObject var project: Project
    
    var selected: Bool
    
    var body: some View {
        HStack {
            VStack{
                HStack{
                    ZStack{
                        Image(systemName: iconData.icons[Int(project.icon)].image)
                            .foregroundColor(themeData.theme.accentColor)
                            .frame(width: 20)
                        Image(systemName: /*Int(project.state) < 2 ? settings.states[Int(project.state)] + ".fill" :*/ settings.states[Int(project.state)])
                            .foregroundColor(themeData.theme.textColor)
                            .frame(width: 5)
                            .offset(x: 15, y: 7)
                    }
                    .padding(.trailing)
                    ColoredText(text: project.name ?? "Unknown")
                }
                HStack{
                    ColoredText(text: "Plant: " + plantsData.plants[Int(project.plant)].name, bold: false, spacer: false)
                        .padding(.trailing)
                    ColoredText(text: "Tier: " + String(plantsData.getTierOfProject(project: project)), bold: false, spacer: false)
                    Spacer()
                }
                .font(.caption)
            }
            Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                .foregroundColor(themeData.theme.textColor)
        }
    }
}
