import Foundation
import SwiftUI
import AVFoundation

class IconData: ObservableObject{
    @Published var icons: [Icon] = [
            Icon(image: "book", id: 0),
            Icon(image: "bicycle", id: 1),
            Icon(image: "music.note", id: 2),
            Icon(image: "hammer", id: 3),
            Icon(image: "gamecontroller", id: 4),
            Icon(image: "paintpalette", id: 5),
            Icon(image: "tv", id: 6),
            Icon(image: "graduationcap", id: 7),
            Icon(image: "camera", id: 8),
            Icon(image: "envelope", id: 9),
            Icon(image: "cart", id: 10),
            Icon(image: "briefcase", id: 11)
        ]

    @Published var selectedIcons: [Icon] = [
        Icon(image: "hammer", id: 3),
        Icon(image: "music.note", id: 2),
        Icon(image: "book", id: 0),
        Icon(image: "bicycle", id: 1),
        Icon(image: "briefcase", id: 11)
    ]
    
    func setSelectedIcons(icons: [Icon]){
        var selected: [Int] = []
        for icon in icons{
            selected.append(icon.id)
        }
        selectedIcons = icons
        UserDefaults.standard.setValue(selected, forKey: "selectedIcons")
    }
    
    func getSelectedIcons(ids: [Int]) -> [Icon]?{
        if(ids.count == 0){
            return nil
        } else {
            var selected: [Icon] = []
            for id in ids {
                for icon in icons {
                    if(icon.id == id){
                        selected.append(icon)
                    }
                }
            }
            return selected
        }
    }
}

struct Icon: Identifiable {
        let image: String
        let id: Int
}
    
