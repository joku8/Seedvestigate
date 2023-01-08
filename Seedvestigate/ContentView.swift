//
//  ContentView.swift
//  Seedvestigate
//
//  Created by Joseph Ku on 1/4/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack {
                Image("seed")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                Text("Seedvestigate")
                    .font(.title)
                    .fontWeight(.thin)
                Spacer()
                Spacer()
                NavigationLink(destination: SeedLookup()) {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                }
                .frame(height: 100)
                Text("Seed Packet Lookup")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                Spacer()
                NavigationLink(destination: SeedStorage()) {
                    Image(systemName: "list.bullet.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                }
                Text("Saved Seed Packets")
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                Spacer()
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
