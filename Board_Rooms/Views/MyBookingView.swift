//
//  MyBookingView.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 21/07/1446 AH.
//

import SwiftUI

struct MyBookingView: View {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.darkBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.white // Button color
    }
    
    @EnvironmentObject var empLogin: LoginViewModel
    @State private var empBooking: [BookingsRecord] = []
    @State private var boardRooms: [BoardRoomsRecord] = []
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView{
            
            VStack{
                
                
                ScrollView {
                    
                    if let loggedInUser = empLogin.loggedInUser {
                        VStack {
                            if empBooking.isEmpty {
                                Text("No bookings found")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                
                                ForEach(empBooking, id: \.id) { booking in
                                    if let boardRoom = boardRooms.first(where: { $0.fields.id == booking.fields.boardroomID }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 23)
                                                .frame(width: 390, height: 150)
                                                .foregroundColor(Color.white)
                                                .padding()
                                            HStack{
                                                RemoteImageView(imageURL: "\(boardRoom.fields.imageURL)")
                                                //.padding(.leading)
                                                
                                                VStack(alignment: .leading, spacing: 8){
                                                    Text("\(boardRoom.fields.name)")
                                                        .fontWeight(.semibold)
                                                    Text("Floor \(boardRoom.fields.floorNo)")
                                                        .font(.caption)
                                                        .foregroundColor(.lightGray)
                                                    
                                                    HStack{
                                                        Image(systemName: "person.2")
                                                            .foregroundColor(.pigOrange)
                                                        Text(" \(boardRoom.fields.seatNo)")
                                                            .font(.caption)
                                                            .foregroundColor(.pigOrange)
                                                    }
                                                    
                                                    Text("\(boardRoom.fields.facilities.joined(separator: ", "))")
                                                    
                                                }
                                                
                                                ZStack{
                                                    RoundedRectangle(cornerRadius: 9)
                                                        .frame(width: 100, height: 30)
                                                        .foregroundColor(Color.darkBlue)
                                                    
                                                    Text("\(formatDate(from: booking.fields.date))")
                                                        .foregroundColor(.white)
                                                }
                                                
                                                
                                                
                                            }.frame(width: 390, height: 150)
                                                .padding()
                                            
                                        }
                                    } else {
                                        Text("Boardroom details not found for booking ID: \(booking.id)")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                            }
                        }
                    }}// End Scroll View
            }.navigationTitle("My Booking")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.background)
                .onAppear {
                    empLogin.fetchBoardRooms { rooms in
                        self.boardRooms = rooms
                        if let loggedInUserID = empLogin.loggedInUser?.id {
                            empLogin.fetchBookings(for: "\(loggedInUserID)") { userBookings in
                                DispatchQueue.main.async {
                                    if userBookings.isEmpty {
                                        errorMessage = "No bookings found for employee ID \(loggedInUserID)"
                                    } else {
                                        
                                        self.empBooking = userBookings
                                    }
                                }
                            }
                        }
                    }
                }
        }.navigationBarBackButtonHidden(true)
    }
    
    func formatDate(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}

#Preview {
    MyBookingView().environmentObject(LoginViewModel())
}
