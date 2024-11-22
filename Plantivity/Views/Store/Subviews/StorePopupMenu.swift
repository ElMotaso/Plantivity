import SwiftUI
import AVFoundation

struct StorePopupMenu: View {
    @EnvironmentObject var themeData: ThemeData
    @EnvironmentObject var storeData: StoreData
    @EnvironmentObject var plantsData: PlantsData

    @State var count: Int = 0
    @Binding var selectedItem: Item?
    
    @Binding var showErrorPopup: Bool
    
    var body: some View {
        VStack{
            if selectedItem?.plantId != nil {
                HStack{
                    let plant = plantsData.plants[Int(selectedItem?.plantId ?? 0)]
                    if(plant.images[3].hasPrefix("P")){
                        Text(plant.images[1])
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                .foregroundColor(themeData.theme.accentColor)
                                .padding()

                    } else{
                        Image(plant.images[3])
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                .foregroundColor(themeData.theme.accentColor)
                                .padding()
                    }
                    VStack{
                        ColoredText(text: plant.name)
                        ColoredText(text: "Update Interval:")
                            .padding(.top, 5)
                        if(plant.intervall <= 7){
                            ColoredText(text: "\tVery Short", bold: false)
                        }else if(plant.intervall <= 7){
                            ColoredText(text: "\tShort", bold: false)
                        }else if(plant.intervall <= 30){
                            ColoredText(text: "\tMedium", bold: false)
                        }else if(plant.intervall < 183){
                            ColoredText(text: "\tLong", bold: false)
                        }else{
                            ColoredText(text: "\tVery Long", bold: false)
                        }
                        
                        ColoredText(text: "Session Reward:")
                        if(plant.reward[1] < 5){
                            ColoredText(text: "\tLittle", bold: false)
                        }else if(plant.reward[1] < 10){
                            ColoredText(text: "\tMedium", bold: false)
                        }else{
                            ColoredText(text: "\tLarge", bold: false)
                        }
                        
                        ColoredText(text: "Required Work:")
                        if(plant.work[1] < 900){
                            ColoredText(text: "\tVery Little", bold: false)
                        }else if(plant.work[1] < 1800){
                            ColoredText(text: "\tLittle", bold: false)
                        }else if(plant.work[1] < 3600){
                            ColoredText(text: "\tMedium", bold: false)
                        }else{
                            ColoredText(text: "\tMuch", bold: false)
                        }
                    }
                Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: (200))
                .padding(.bottom)
            } else {
                if selectedItem != nil {
                    HStack{
                        if selectedItem!.image.hasPrefix("I") {
                            Text(selectedItem!.image)
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                .foregroundColor(themeData.theme.accentColor)
                                .padding()
                        } else {
                            Image(selectedItem!.image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .frame(maxHeight: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8).stroke(themeData.theme.textColor, lineWidth: 1))
                                .foregroundColor(themeData.theme.accentColor)
                                .padding()
                        }
                        VStack{
                            ColoredText(text: selectedItem!.name)
                            ColoredText(text: "Description:")
                                .padding(.top, 5)
                            ColoredText(text: selectedItem!.description, bold: false).padding(.leading, 5)
                        }
                    Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: (200))
                    .padding(.bottom)
                }
            }
            ColoredText(text: ("How many " + String(selectedItem?.name ?? "item") + "'s do you want to buy?"))
                .padding(.bottom, 5)
            ColoredText(text: ("Count: " + String(count)), bold: false)
                .padding(.bottom)
            Slider(result: $count, maxResult: 10)
                .padding(.bottom)
            WideButton(text: "Buy", action: {
                let intCount = Int(count)
                if storeData.addCoins(coins: -(Int(selectedItem?.price ?? 0) * intCount)) {
                    storeData.setItem(id: Int(selectedItem?.id ?? 0), newCount: intCount)
                    selectedItem = nil
                } else {
                    print("Error")
                    showErrorPopup = true
                    AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        showErrorPopup = false
                    }
                }
            })
        }
        .padding()
        .background(themeData.theme.backgroundColor)
        .cornerRadius(15)
    }
}

