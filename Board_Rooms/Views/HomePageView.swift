//
//  HomePageView.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 20/07/1446 AH.
//

import SwiftUI

struct BoardRoomsList: Codable {
    //var id: Int
    var name: String
    var description: String
    var no_of_seats: Int
    var floor_no: Int
}

struct HomePageView: View {
    @State private var boardRooms: [BoardRoomsList] = []
    
    var body: some View {
        NavigationView {
            List(boardRooms, id: \.floor_no){ boardRooms in
            VStack(alignment: .leading){
                Text(boardRooms.name)
                    .bold()
                    .foregroundColor(.black)
                
                Text("\(boardRooms.floor_no)")
                    .foregroundColor(.gray)
            }
        }.navigationTitle("Board Rooms")
                .task{
                    await loadData()
                }
            
    }
    }
    
    func loadData() async {
        //Create URL
        guard let url = URL(string: "https://8cd2971c-9293-4e45-b01c-f3c2c582ad1a.mock.pstmn.io/boardrooms") else {
            print("This URL is not valid")
            return }
        
        // Fetch data from URL
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode data
            if let decodeData = try? JSONDecoder().decode([BoardRoomsList].self, from: data){
                boardRooms = decodeData
            }
        } catch{
            print("This data is not valid")
        }
        
    }
}

#Preview {
    HomePageView()
}
