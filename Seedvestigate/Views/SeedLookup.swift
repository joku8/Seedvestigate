//
//  SeedLookup.swift
//  Seedvestigate
//
//  Created by Joseph Ku on 1/4/23.
//

import SwiftUI
import UIKit
import Vision

struct SeedLookup: View {
    
    @State private var isShownCamera: Bool = false
    @State private var isShownSeed: Bool = false
    
    @State private var ui_image: UIImage?
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        
        VStack{
            Spacer()
            if let image = ui_image {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
            } else {
                Image("grayscaleseed").resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
            }
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
            A(isShown: self.$isShownCamera, myimage: self.$ui_image, mysourceType: self.$sourceType)
        }
        .sheet(isPresented: $isShownSeed) {
            if ui_image != nil {
                seedPacketInfo(ui_image: $ui_image)
            } else {
                pictureRequired()
            }
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
    @Binding var myimage: UIImage?
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
    @Binding var myimage: UIImage?
    
    init(isShown: Binding<Bool>, myimage: Binding<UIImage?>) {
        _isShown = isShown
        _myimage = myimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(image)
            myimage = image
        }
        isShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct pictureRequired: View{
    var body: some View{
        VStack{
            Image(systemName: "leaf.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text("Please take an image first")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.green)
        }
    }
}

struct seedPacketInfo: View{
    @Binding var ui_image: UIImage?
    
    @State var recognizedText: String = ""
    
    
    
    var body: some View{
        VStack{
            Text("Needs to be filled with seed info")
        }.onAppear {
            self.recognizedText = ""
            self.recognizeText(image: self.ui_image)
            parseData(recognizedText)
        }
    }
    
    func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("Could not convert cgImage")
        }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                return
            }
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")
            self.recognizedText = text
        }
        // Process request
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }

}


