//
//  SeedStorage.swift
//  Seedvestigate
//
//  Created by Joseph Ku on 1/4/23.
//

/**
 This page shows all the saved seed packets and allows the user to delete, manually add, or redirect to scan seed packet page
 */

import SwiftUI

struct Packet: Decodable {
    var plant: String
    var variety: String
    var source: String
    var _id: String
    var notes: String
}

class ViewModel: ObservableObject {
    
    @Published var packets: [Packet] = []

    func fetch() {
        guard let url = URL(string: "http://127.0.0.1:8081/fetch") else {
            return
            
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert to JSON
            do {
                
                let packets = try JSONDecoder().decode([Packet].self, from: data)
                DispatchQueue.main.async {
                    self?.packets = packets
                }
                
            } catch {
                
                print("FAILED")
                print(error)
                
            }
            
        }
        task.resume()
        
    }

}

struct SeedStorage: View {
    @ObservedObject var viewModel = ViewModel()
    
//    @ObservedObject var packetModel = ViewModel()
    
    @State var selectedPacket: Packet? = nil
    
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: 15)
            HStack {
                Spacer()
                    .frame(width: 25)
                Text("Seed Packets")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                Spacer()
                NavigationLink(destination: PacketInfo(packet: nil)) {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                }
                Spacer()
                    .frame(width: 25)
                
                
            }
            List {
                ForEach(viewModel.packets, id: \._id) { packet in
                    NavigationLink(destination: PacketInfo(packet: packet)) {
                        HStack {
                            Text(packet.plant).bold()
                            Text(packet.variety)
                        }
//                            .onTapGesture {
//                                self.selectedPacket = packet
//                                print(selectedPacket?.plant)
//                            }
                    }
                }
            }
//                .navigationTitle("Seed Packets")
            .onAppear {
                self.viewModel.fetch()
            }
        }
    }
        
    
}

struct SeedStorage_Previews: PreviewProvider {
    static var previews: some View {
        SeedStorage()
    }
}

struct PacketInfo: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()

    @State var packet: Packet?
    
//    var packet: Binding<Packet?>

    var body: some View {
        if packet == nil {
            Text("New Packet")
            Text("None here")
        } else {
            Text("Edit Packet")
            Text(packet!.plant)
        }
    }
}
