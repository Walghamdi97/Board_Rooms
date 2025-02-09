//
//  HomePageView.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 20/07/1446 AH.
//

import SwiftUI



struct HomePageView: View {
    
    
    
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
                
                Button (action: {
                    
                }){
                    Image("availableToday")
                        .resizable()
                        .scaledToFit()
                }.padding()
                
                
                HStack{
                    Text("My booking")
                        .fontWeight(.semibold)
                        .foregroundColor(.darkBlue)
                    Spacer()
                    NavigationLink(destination: MyBookingView()){
                        Text("See All")
                        
                            .foregroundColor(.pigOrange)
                        
                    }
                }.padding()
                
                
                ScrollView(.horizontal, showsIndicators: false, content: {
                    
                    if let loggedInUser = empLogin.loggedInUser {
                        HStack {
                            if empBooking.isEmpty {
                                Text("No bookings found")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                
                                ForEach(empBooking, id: \.id) { booking in
                                    if let boardRoom = boardRooms.first(where: { $0.fields.id == booking.fields.boardroomID }) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 23)
                                                .frame(width: 358, height: 122)
                                                .foregroundColor(Color.white)
                                                //.padding()
                                            HStack(spacing: 20){
                                                
                                                AsyncImage(url: URL(string: boardRoom.fields.imageURL)) { image in
                                                    image.resizable()
                                                } placeholder: {
                                                    Color.gray.opacity(0.3) // Placeholder while loading
                                                }
                                                .frame(width: 106, height: 106)
                                                .cornerRadius(10)
                                                
                                                VStack(alignment: .leading, spacing: 8){
                                                    
                                                    Text("\(boardRoom.fields.name)")
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.darkBlue)
                                                        .lineLimit(nil)
                                                    Text("Floor \(boardRoom.fields.floorNo)")
                                                        .font(.caption)
                                                        .foregroundColor(.lightGray)
                                                    
                                                    HStack{

                                                        Label("\(boardRoom.fields.seatNo)", systemImage: "person.2")
                                                            .font(.caption)
                                                            .fontWeight(.regular)
                                                            .foregroundColor(.pigOrange)
                                                        
                                                    }.background {
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .fill(Color.background)
                                                            .frame(width: 50, height: 20)
                                                        
                                                    }
                                                    
                                                    HStack(spacing: 15) {
                                                        // Facility icons loop
                                                        ForEach(["Wi-Fi", "Screen", "Microphone", "Projector"], id: \.self) { facility in
                                                            if boardRoom.fields.facilities.contains(facility) {
                                                                HStack {
                                                                    Image(systemName: getFacilityIcon(facility: facility))
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                        .frame(width: 15, height: 16)
                                                                        .foregroundColor(.darkBlue)
                                                                    
                                                                }.background {
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .fill(Color.background)
                                                                        .frame(width: 23, height: 20)
                                                                    
                                                                }
                                                        
                                                            }
                                                        }
                                                    }
                                                    
                                                }.padding(.trailing, 10)
                                                
                                                VStack(alignment:.trailing){
                                                    VStack {
                                                        Text("\(formatDate(from: booking.fields.date))")
                                                            .font(.caption)
                                                            .foregroundColor(.white)
                                                    }.background {
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .fill(Color.darkBlue)
                                                            .frame(width: 65, height: 26)
                                                        
                                                    }
                                                    Spacer()
                                                }.padding(.top,25)
                                                
                                               
                                                
                                                
                                                
                                            }
                                            
                                        }.frame(width: 358, height: 122)
                                            .padding()
                                    } else {
                                        Text("Boardroom details not found for booking ID: \(booking.id)")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                            }
                        }
                    }})// End Scroll View
                
                
                
                CustomCalendar()
                
                ScrollView(.vertical, showsIndicators: false, content:{
                    ForEach(boardRooms, id:\.id){ room in
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 23)
                                .frame(width: 358, height: 122)
                                .foregroundColor(Color.white)
                            //.padding()
                            HStack(spacing: 20){
                                
                                    AsyncImage(url: URL(string: room.fields.imageURL)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray.opacity(0.3) // Placeholder while loading
                                    }
                                    .frame(width: 106, height: 106)
                                    .cornerRadius(10)
                               
                                
                                
     
                                VStack(alignment: .leading, spacing: 8){
        
                                    NavigationLink(destination: BoardRoomDetails(boardRoom: room)){
                                        Text("\(room.fields.name)")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.darkBlue)
                                    }
                                    Text("Floor \(room.fields.floorNo)")
                                        .font(.caption)
                                        .foregroundColor(.lightGray)
                                    
                                    HStack{

                                        Label("\(room.fields.seatNo)", systemImage: "person.2")
                                            .font(.caption)
                                            .fontWeight(.regular)
                                            .foregroundColor(.pigOrange)
                                        
                                    }.background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.background)
                                            .frame(width: 50, height: 20)
                                        
                                    }
                                    
                                    
                                    
                                    HStack(spacing: 15) {
                                        // Facility icons loop
                                        ForEach(["Wi-Fi", "Screen", "Microphone", "Projector"], id: \.self) { facility in
                                            if room.fields.facilities.contains(facility) {
                                                HStack {
                                                    Image(systemName: getFacilityIcon(facility: facility))
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 15, height: 16)
                                                        .foregroundColor(.darkBlue)
                                                    
                                                }.background {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .fill(Color.background)
                                                        .frame(width: 23, height: 20)
                                                    
                                                }
                                        
                                            }
                                        }
                                    }
                                    
                                }
                                
                                
                                VStack(alignment:.trailing){
                                    VStack {
                                        Text("Available")
                                            .font(.caption)
                                            .foregroundColor(.darkGreen)
                                    }.background {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.lightGreen)
                                            .frame(width: 65, height: 26)
                                        
                                    }
                                    Spacer()
                                }.padding(.top,14)
                            }
                            
                        }.frame(width: 358, height: 122)
                    }
                })
                
                
            }.navigationTitle("Board Rooms")
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
                  
                    
                }// Ends OnApear
            
            
        }
    }
    

    
    func formatDate(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func getFacilityIcon(facility: String) -> String {
        switch facility {
        case "Wi-Fi":
            return "wifi"
        case "Screen":
            return "tv" // Use the "tv" system image for a screen
        case "Microphone":
            return "mic" // Use the "mic.fill" system image for a microphone
        case "Projector":
            return "videoprojector" // Replace with "video.projector" or a relevant icon
        default:
            return "questionmark.circle" // Fallback icon for unknown facilities
        }
    }
    
    
}


#Preview {
    HomePageView().environmentObject(LoginViewModel())
}


