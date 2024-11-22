import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(imagePicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let imagePicker: ImagePicker
        
        init(imagePicker: ImagePicker){
            self.imagePicker = imagePicker
        }
        
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                //Compression
                guard let data = image.jpegData(compressionQuality: 0), let compressedImage = UIImage(data: data) else {
                          //TODO: Error handling
                    return
                }

                imagePicker.image = compressedImage
            } else {
                //TODO: Error handling
            }
            picker.dismiss(animated: true)
        }
    }
}
