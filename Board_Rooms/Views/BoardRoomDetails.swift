//
//  BoardRoomDetails.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 29/07/1446 AH.
//

import SwiftUI

struct BoardRoomDetails: View {
    init(boardRoom: BoardRoomsRecord) {
        self.boardRoom = boardRoom
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
    var boardRoom: BoardRoomsRecord
    @State private var isBookingSuccess = false
    @State private var errorMessage: String?
    @State private var selectedDate: String?
    var days: [Day]{
            generateDaysForMonth()
        }
//    @State private var bookedDates: [String] = []
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    AsyncImage(url: URL(string: boardRoom.fields.imageURL)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3) // Placeholder while loading
                                }
                                .frame(width: UIScreen.main.bounds.width, height: 280)
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.1), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .top
                    ).frame(width: UIScreen.main.bounds.width, height: 280)
                    
                    HStack{
                        Label("Floor \(boardRoom.fields.seatNo)", systemImage: "location")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.darkBlue)
                        
                        Spacer()
                        VStack{
                            Label("\(boardRoom.fields.seatNo)", systemImage: "person.2")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.pigOrange)
                        }.background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.background)
                            .frame(width: 50, height: 20)}
                       
                    }.padding()
                        .offset(x: 0, y: 100)
            
                }
                Spacer()
                HStack(){
                    Text("Description")
                        .fontWeight(.semibold)
                        .foregroundColor(.darkBlue)
                    Spacer()
                }.padding(.horizontal)
                
                VStack{
                    ScrollView{
                        Text("\(boardRoom.fields.description)")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .foregroundColor(.darkBlue)
                            .lineLimit(nil)
                            
                            
                    }.frame(width: 358, height: 109)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    
                }
                
                
                HStack(){
                    Text("Facilities")
                        .fontWeight(.semibold)
                        .foregroundColor(.darkBlue)
                        
                    Spacer()
                }.padding(.horizontal)
                
                HStack(spacing: 15) {
                    // Facility icons loop
                    ForEach(["Wi-Fi", "Screen", "Microphone", "Projector"], id: \.self) { facility in
                        if boardRoom.fields.facilities.contains(facility) {
                            HStack {
                                Label("\(facility)", systemImage: getFacilityIcon(facility: facility))
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(.darkBlue)
                                
                    
                                
                            }.background {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.white)
                                    .frame(width: 80, height: 20)
                                
                            }
                    
                        }
                    }
                    Spacer()
                }.padding(.horizontal)
                .padding(.top,10)
                    
                VStack(alignment: .leading, spacing: 13) {
                    Text("All bookings for \(currentMonthName())")
                        .fontWeight(.semibold)
                        .foregroundColor(.darkBlue)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 1) {
                            ForEach(days) { day in
                                VStack(spacing: 7) {
                                    Text(day.dayName)
                                        .font(.system(size: 11, weight: .regular))
                                        .foregroundColor(.gray)
                                        //.foregroundColor(day.isSelected ? .gray : .gray)
                                    
                                        Text(day.date)
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(selectedDate == day.date ? .white :
                                                            (empLogin.bookedDates.contains(day.date) ? .gray : .darkBlue))
                                        .frame(width: 35, height: 35)
                                        .background(selectedDate == day.date ? Color.pigOrange :
                                                        (empLogin.bookedDates.contains(day.date) ? Color.gray.opacity(0.4) : Color.white))
                                        .clipShape(Circle())
                                        .shadow(color: empLogin.bookedDates.contains(day.date) ? .gray.opacity(0.5) : .gray.opacity(0.2),
                                                radius: 5, x: 0, y: 2)
                                    
                                }
                                .padding(.horizontal, 5)
                                .onTapGesture {
                                    if !empLogin.bookedDates.contains(day.date) {
                                        selectedDate = day.date
                                    }
                                }
                            }
                        }
                        //.padding(.horizontal, 15)
                    }
                } .padding()
                
                Button(action: {
                    bookBoardRoom()
                }) {
                    Text("Booking")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 60, height: 40)
                        
                }.buttonStyle(.borderedProminent)
                    .tint(Color.pigOrange)
                    .padding()

                
            }.navigationTitle("\(boardRoom.fields.name)")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.background)
                .onAppear {
                    empLogin.fetchBookedDates(for: boardRoom.fields.id)
                }
                .fullScreenCover(isPresented: $isBookingSuccess) {
                    SuccessView()}
                
        }
            
        
    }
    
    
    func bookBoardRoom() {
        guard let selectedDate = selectedDate else { return }
        
        empLogin.bookBoardRoom(boardroomID: boardRoom.fields.id, selectedDate: selectedDate) { success, error in
            if success {
                isBookingSuccess = true
            }
        }
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
    
    // The current month
    func generateDaysForMonth() -> [Day] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE" // Short day name (e.g., Sun, Mon)

        // Strip time from 'today' to only compare dates
        let today = calendar.startOfDay(for: Date())

        // Get range of days in the current month
        guard let range = calendar.range(of: .day, in: .month, for: today) else { return [] }

        var days: [Day] = []
        let currentDay = calendar.component(.day, from: today)

        for day in range {
            let components = DateComponents(year: calendar.component(.year, from: today),
                                            month: calendar.component(.month, from: today),
                                            day: day)
            if let date = calendar.date(from: components), date >= today {
                let dayName = dateFormatter.string(from: date)
//                if dayName != "Fri" && dayName != "Sat" { // Exclude Fridays and Saturdays
//                    let isSelected = (day == currentDay)
//                    days.append(Day(date: "\(day)", dayName: dayName, isSelected: isSelected))
//                }
                if dayName != "Fri" && dayName != "Sat" { // Exclude Fridays and Saturdays
                                    days.append(Day(date: "\(day)", dayName: dayName))
                                }
            }
        }
        return days
    }

    func currentMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM" // Full month name
        return dateFormatter.string(from: Date())
    }
}


#Preview {
    let sampleBoardRoom = BoardRoomsRecord(
        id: "1",
        createdTime: "1739579999",  // Use a valid Date
        fields: BoardRoomField(
            id: "1",
            name: "Executive Room",
            floorNo: 2,
            seatNo: 10,
            description: "A spacious boardroom with modern facilities.",
            facilities: ["Wi-Fi", "Screen", "Projector"],
            imageURL: "https://via.placeholder.com/300"
        )
    )

    BoardRoomDetails(boardRoom: sampleBoardRoom)
        .environmentObject(LoginViewModel())
}
