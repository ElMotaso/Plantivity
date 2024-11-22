import Foundation
import SwiftUI
import AVFoundation

class PlantsData: ObservableObject{
    @Published var plants: [Plant] = [
        Plant(id: 0,
              intervall: 1,
              images: ["P1.1", "P1.2", "P1.3"],
              reward: [1, 2, 3],
              work: [1, 2, 3],
              frozen: false),
        

        Plant(id: 1,
              intervall: 1,
              images: ["P2.1", "P2.2", "P2.3"],
              reward: [1, 2, 3],
              work: [1, 2, 3],
              frozen: false),

        Plant(id: 2,
              intervall: 1,
              images: ["P3.1", "P3.2", "P3.3"],
              reward: [1, 2, 3],
              work: [1, 2, 3],
              frozen: false),
            ]
}

struct Plant: Identifiable {
    let id: Int16
    let intervall: Int
    let images: [String]
    var reward: [Int]
    var work: [Int]
    var frozen: Bool
}
