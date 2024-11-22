import Foundation
import SwiftUI
import AVFoundation

class Settings: ObservableObject{
    @Published var showTabBar = true
    @Published var selection = 2
    let size: CGFloat = 50
    let states = ["play", "pause", "checkmark", "multiply"]
}
