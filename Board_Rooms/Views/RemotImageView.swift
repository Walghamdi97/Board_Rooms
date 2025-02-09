//
//  RemotImageView.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 28/07/1446 AH.
//

import SwiftUI

struct RemoteImageView: View {
    let imageURL: String

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView() // Placeholder while loading
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 106, height: 106)
//                    .cornerRadius(10)
                    
            case .failure:
                Image(systemName: "photo") // Placeholder for failure
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
//                    .frame(width: 106, height: 106)
//                    .cornerRadius(10)
            @unknown default:
                Image(systemName: "questionmark") // Fallback for unexpected cases
            }
        }
        //.frame(width: 106, height: 106) // Set your desired size
    }
}


