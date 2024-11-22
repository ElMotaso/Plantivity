import Foundation
import SwiftUI
import AVFoundation

class StoreData: ObservableObject{
    @Published var coins: Int = 0
    @Published var items: [Item] = [
        Item(id: 0, price: 0, name: "Sunflower Seed", image: "sunflower_3", description: "", isDefault: false, plantId: 0),
        Item(id: 1, price: 120, name: "Cactus Seed", image: "cactus_3", description: "", isDefault: true, plantId: 1),
        //Item(id: 2, price: 3, name: "Seed P3", image: "I:P3", isDefault: false, plantId: 2),
        //Item(id: 3, price: -1, name: "Seed P4 (coming soon)", image: "I:P4", isDefault: false, plantId: 3),
        //Item(id: 4, price: -100, name: "Seed P5 (coming soon)", image: "I:P5", isDefault: false, plantId: 4),
        Item(id: 2, price: 200, name: "Freezer", image: "freezer", description: "Freezing a plant prevents it from losing a tier if not enough sessions were completed.", isDefault: false, plantId: nil),
        //Item(id: 6, price: 25, name: "Fertilizer", image: "I:2", isDefault: false, plantId: nil),
        //Item(id: 7, price: 5, name: "Reward Booster", image: "I:3", isDefault: false, plantId: nil),
        Item(id: 3, price: 500, name: "Reviver", image: "reviver", description: "Can be applied to neglected plants to give them another chance.", isDefault: false, plantId: nil),
        //Item(id: 9, price: 5000, name: "Place for Ad", image: "I:5", isDefault: false, plantId: nil)
    ]
    
    func loadItems() -> Void{
        let itemCounts = UserDefaults.standard.array(forKey: "items") as? [Int] ?? [Int]()
        if !itemCounts.isEmpty {
            for i in 0..<items.count {
                items[i].count = itemCounts[i]
            }
        }
    }
    
    func addCoins(coins: Int) -> Bool{
        if self.coins + coins >= 0 {
            self.coins += coins
            UserDefaults.standard.setValue(self.coins , forKey: "coins")
            return true
        }
        return false
    }
    
    func getItems(includePlants: Bool = true, includeItems: Bool = true) -> [Item]{
        var searchedItems = [Item]()
        for i in 0..<items.count {
            if items[i].count > 0{
                if includePlants && items[i].plantId != nil {
                    searchedItems.append(items[i])
                }
                if includeItems && items[i].plantId == nil {
                    searchedItems.append(items[i])
                }
            }
        }
        return searchedItems
    }
    
    func setItem(id: Int, newCount: Int) -> Void{
        items[id].count = newCount
        var itemCounts = [Int]()
        for i in 0..<items.count {
            itemCounts.append(items[i].count)
        }
        UserDefaults.standard.setValue(itemCounts, forKey: "items")
    }
    
    func useItem(id: Int, project: Project){
        if(items[id].count <= 0){
            return
        }
        switch id{
            case 2: //Freezer
                if(project.state == 0){
                    project.state = 1
                    setItem(id: id, newCount: items[id].count - 1)
                }
            case 5: //Unused
                if(!project.isFertilized){
                    project.isFertilized = true
                    setItem(id: id, newCount: items[id].count - 1)
                }
            case 3: //Reviver
                if(project.tier == 0){
                    project.tier = 1
                    project.state = 0
                    setItem(id: id, newCount: items[id].count - 1)
                }
            default: break
        }
        PersistenceController.shared.save()
        return
    }
}

struct Item: Identifiable {
    let id: Int16
    let price: Int
    let name: String
    let image: String
    var count: Int = 0
    let description: String
    let isDefault: Bool
    let plantId: Int16?
}
