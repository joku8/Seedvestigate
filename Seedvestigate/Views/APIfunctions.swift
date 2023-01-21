//
//  APIfunctions.swift
//  Seedvestigate
//
//  Created by Joseph Ku on 1/20/23.
//

import Foundation
import Alamofire

struct Packet:Decodable {
    var plant: String
    var variety: String
    var source: String
    var _id: String
}

class APIfunctions {
    
    var delegate: DataDelegate?
    
    static let functions = APIfunctions()
    
    func fetchPackets(completion: @escaping ([Packet]) -> Void) {
            AF.request("http://127.0.0.1/fetch").responseDecodable(of: [Packet].self) { response in
                switch response.result {
                case .success(let packets):
                    completion(packets)
                case .failure(let error):
                    print(error)
                }
            }
        }
    
    
    
    // func addPacket
}

protocol DataDelegate: class {
    func updateArray(newArray: [Packet])
}
