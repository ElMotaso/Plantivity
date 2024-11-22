import SwiftUI

struct TimePicker: View {
    var width: CGFloat
    var height: CGFloat
    @Binding var seconds: Int
    
    @State var selectedHour = 0
    @State var selectedMinute = 0
    @State var selectedSecond = 0
    
    var h = [Int](0..<24)
    var m = [Int](0..<60)
    //var s = [Int](0..<60)
    
    
    var body: some View {
        HStack(spacing: 0) {
            Picker(selection: $selectedHour, label: Text("Hours")) {
                ForEach(0 ..< h.count, id: \.self) { i in
                    Text(((h[i] >= 10) ? String(h[i]) : "0" + String(h[i]))).tag(i)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(width: width/2, height: height, alignment: .center)
            .clipped()
            Text(":")
            Picker(selection: $selectedMinute, label: Text("Minutes")) {
                ForEach(0 ..< m.count, id: \.self) { i in
                    Text(((m[i] >= 10) ? String(m[i]) : "0" + String(m[i]))).tag(i)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(width: width/2, height: height, alignment: .center)
            .clipped()
            /*Text(":")
            Picker(selection: $selectedSecond, label: Text("Seconds")) {
                ForEach(0 ..< s.count, id: \.self) { i in
                    Text(((s[i] >= 10) ? String(s[i]) : "0" + String(s[i]))).tag(i)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(width: width/3, height: height, alignment: .center)
            .clipped()
             */
        }
        .onChange(of: selectedHour){ i in
            seconds = i * 3600 + selectedMinute * 60 + selectedSecond
        }
        .onChange(of: selectedMinute){ i in
            seconds = selectedHour * 3600 + i * 60 + selectedSecond
        }
        .onChange(of: selectedSecond){ i in
            seconds = selectedHour * 3600 + selectedMinute * 60 + i
        }
    }
}


extension UIPickerView {
   open override var intrinsicContentSize: CGSize {
      return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)}
}
