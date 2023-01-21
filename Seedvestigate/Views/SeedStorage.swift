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
import UIKit

//
//protocol DataDelegate {
//    func updateArray(newArray:String)
//}
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    var packet_array = [Packet]()
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return packet_array.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)
//        return cell
//    }
//
//    @IBOutlet weak var packetTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        APIfunctions.functions.delegate = self
//        APIfunctions.functions.fetchPackets()
//        print(packet_array)
//        packetTableView.delegate = self
//        packetTableView.dataSource = self
//    }
//
//}
//
//extension ViewController: DataDelegate {
//
//    func updateArray(newArray: String) {
//        do {
//            packet_array = try JSONDecoder().decode([Packet].self, from: newArray.data(using: .utf8)!)
//        } catch {
//            print("FAILED TO DECODE")
//        }
//    }
//}


//struct MyViewController: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<MyViewController>) -> UIViewController {
//        let vc = ViewController()
//        vc.modalPresentationStyle = .fullScreen
//        return vc
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<MyViewController>) {
//    }
//}

struct SeedStorage: View {
    @State private var packets: [Packet] = []

    var body: some View {
        VStack {
            if packets.isEmpty {
                ProgressView()
            } else {
                ForEach(packets, id: \._id) { packet in
                    VStack {
                        Text(packet.plant)
                        Text(packet.variety)
                    }
                }
            }
        }.onAppear(perform: {
            print("About to call fetch function")
            fetchPackets()
            print(packets)
            print("Generating view")
        })
    }
    
    func fetchPackets() {
        print("Fetching packets in view")
        APIfunctions.functions.delegate = self
        APIfunctions.functions.fetchPackets()
    }
    
    func updateArray(newArray: [Packet]) {
        packets = newArray
    }
}

struct SeedStorage_Previews: PreviewProvider {
    static var previews: some View {
        SeedStorage()
    }
}
