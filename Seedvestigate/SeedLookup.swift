//
//  SeedLookup.swift
//  Seedvestigate
//
//  Created by Joseph Ku on 1/4/23.
//

import SwiftUI
import UIKit

struct SeedLookup: View {
    
    @State private var isShownCamera: Bool = false
    @State private var isShownSeed: Bool = false
    
    
    @State private var image: Image = Image("grayscaleseed")
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack{
            Spacer()
            image.resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
            Spacer()
            Button(action: {
                self.isShownSeed.toggle()
            }) {
                HStack{
                    Text("Search")
                        .font(.title2)
                        .fontWeight(.light)
                    Image(systemName: "magnifyingglass")
                }
            }
            Spacer()
                .frame(height: 25)
            Button(action: {
                self.isShownCamera.toggle()
                self.sourceType = .camera
            }) {
                HStack{
                    Text("Take Photo")
                        .font(.title2)
                        .fontWeight(.light)
                    Image(systemName: "camera")
                }
                
            }
        }
        .sheet(isPresented: $isShownCamera) {
            A(isShown: self.$isShownCamera, myimage: self.$image, mysourceType: self.$sourceType)
        }
        .sheet(isPresented: $isShownSeed) {
            seedPacketInfo(image: $image)
        }
    }
}


struct SeedLookup_Previews: PreviewProvider {
    static var previews: some View {
        SeedLookup()
    }
}

struct A: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var myimage: Image
    @Binding var mysourceType: UIImagePickerController.SourceType
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<A>) {
        
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<A>) -> UIImagePickerController {
        let obj = UIImagePickerController()
        obj.sourceType = mysourceType
        obj.delegate = context.coordinator
        return obj
    }
    func makeCoordinator() -> C {
        return C(isShown: $isShown, myimage: $myimage)
    }
}

class C: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isShown: Bool
    @Binding var myimage: Image
    
    init(isShown: Binding<Bool>, myimage: Binding<Image>) {
        _isShown = isShown
        _myimage = myimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            myimage = Image.init(uiImage: image)
        }
        isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct seedPacketInfo: View{
    @Binding var image: Image
    
    
    
    var body: some View{
        
        image
        
    }
}
