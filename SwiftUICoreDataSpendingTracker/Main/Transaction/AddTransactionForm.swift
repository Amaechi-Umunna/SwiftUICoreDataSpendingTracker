//
//  AddTransactionForm.swift
//  SwiftUICoreDataSpendingTracker
//
//  Created by Amaechi Chukwu on 31/12/2022.
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var photoData: Data?
    
    @State private var shouldPresentPhotoPicker = false
    
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    
                    NavigationLink(destination: Text("Many").navigationTitle("New Title")) {
                        Text("Many to many")
                    }
                }
                
                Section(header: Text("Photo/Object")) {
                    Button {
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                    }
                    
                    if let data = self.photoData, let image = UIImage.init(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
                    PhotoPickerVIew(photoData: $photoData)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    
    
    struct PhotoPickerVIew: UIViewControllerRepresentable {
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
        }
        
        
        @Binding var photoData : Data?
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            private let parent: PhotoPickerVIew
            
            init(parent: PhotoPickerVIew) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                
                let image = info[.originalImage] as? UIImage
                let imageData = image?.jpegData(compressionQuality: 1)
                self.parent.photoData = imageData
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
    }
    
    private var saveButton: some View {
        Button {
            let context =
            PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = self.name
            transaction.timestamp = self.date
            transaction.amount = Float(self.amount) ?? 0
            transaction.photoData = self.photoData
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch let customError {
                print("Failed to save transaction: \(customError)")
            }
            
        } label: {
            Text("Save")
        }
        
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
        
    }
}

struct AddTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionForm()
    }
}
