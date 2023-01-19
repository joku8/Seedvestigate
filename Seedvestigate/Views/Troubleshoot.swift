//
//  Troubleshoot.swift
//  Seedvestigate
//
//  Created by Joseph Ku on 1/14/23.
//

import SwiftUI

struct Troubleshoot: View {
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 25)
            Text("Troubleshooting")
                .font(.largeTitle)
                .fontWeight(.thin)
                .foregroundColor(Color.blue)
            Spacer()
                .frame(height: 25)
            HStack{
                Spacer()
                    .frame(width: 20)
                Text("Make sure the seed packet is clearly visible\n\nThe seed packet should be the only item visible in the screen\n\nEnsure that the correct seed supplier was selected")
                    .font(.body)
                    .fontWeight(.light)
                
            }
            Spacer()
            Image(systemName: "wrench.and.screwdriver.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            Spacer()
        }
        
    }
}

struct Troubleshoot_Previews: PreviewProvider {
    static var previews: some View {
        Troubleshoot()
    }
}
