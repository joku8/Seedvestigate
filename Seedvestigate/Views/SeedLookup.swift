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
    
    @State private var showCheckmark: Bool = false
    
    @State private var ui_image: UIImage?
    
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var value: String = ""
    var placeholder = "Select Seed Supplier"
    var dropDownList = ["MIgardener", "Baker Creek Heirloom Seeds"]
    
    var body: some View {
        
        VStack{
            Spacer()
            if let image = ui_image {
                    Image(uiImage: image).resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
            } else {
                Image("grayscaleseed").resizable().aspectRatio(contentMode: .fit).frame(width: 400, height: 400)
            }
            Menu {
                ForEach(dropDownList, id: \.self){ client in
                            Button(client) {
                                self.value = client
                            }
                        }
                    } label: {
                        VStack(spacing: 5){
                            HStack{
                                Spacer()
                                    .frame(width: 20)
                                Text(value.isEmpty ? placeholder : value)
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(value.isEmpty ? .gray : .black)
                                Spacer()
                                Image(systemName: showCheckmark ? "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(showCheckmark ? .green : .gray)
                                    .font(Font.system(size: 20, weight: .bold))
                                Spacer()
                                    .frame(width: 20)
                            }
                            .onChange(of: value) { value in
                                self.showCheckmark = !value.isEmpty
                            }
                        }
                        .frame(width: 350, height: 50)
                        .background(showCheckmark ? Color(red: 220 / 255, green: 255 / 255, blue: 212 / 255) : Color(red: 240 / 255, green: 240 / 255, blue: 240 / 255))
                        .cornerRadius(20)
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
            if ui_image == nil {
                pictureRequired()
            } else if (value.isEmpty){
                supplierRequired()
            } else {
                seedPacketInfo(ui_image: $ui_image, supplier: $value)
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

struct supplierRequired: View{
    var body: some View{
        VStack{
            Image(systemName: "leaf.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            Text("Please select a seed supplier")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.green)
        }
    }
}

struct seedPacketInfo: View{
    @Binding var ui_image: UIImage?
    @Binding var supplier: String
    
    @State var recognizedText: String = ""
    @State var jsonString: String = ""
    
    @State var jsonStringPointer: UnsafePointer<CChar>?
    
    struct SeedPacket: Codable {
        let company: String
        let plant: String
        let variety: String
    }
    
    @State var seed_packet: SeedPacket?


    var body: some View{
        VStack{
            let comp = seed_packet?.company ?? ""
            let plnt = seed_packet?.plant ?? ""
            let vrty = seed_packet?.variety ?? ""
            HStack{
                Spacer()
                    .frame(width: 10)
                Text(plnt)
                    .font(.largeTitle)
                    .fontWeight(.thin)
                Text(vrty)
                    .font(.title)
                    .fontWeight(.light)
                    .italic()
                Spacer()
            }
            HStack{
                Spacer()
                    .frame(width: 10)
                Text(comp)
                    .font(.title2)
                    .fontWeight(.ultraLight)
                Spacer()
            }
            Spacer()
            
        }.onAppear {
            self.recognizedText = ""
            self.recognizeText(image: self.ui_image)
            let jsonString = String(cString: parseData(self.recognizedText, self.supplier))
            deallocateJsonString(jsonStringPointer)
            do {
                let data = jsonString.data(using: .utf8)!
                self.seed_packet = try JSONDecoder().decode(SeedPacket.self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
                // show an error message to the user
            }
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


