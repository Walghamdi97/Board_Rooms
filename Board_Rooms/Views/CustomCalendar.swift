//
//  CustomCalendar.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 28/07/1446 AH.
//

import SwiftUI

struct CustomCalendar: View {
    @State private var selectedDate: String?
    var days: [Day]{
            generateDaysForMonth()
        }

    
    var body: some View {
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
                                .foregroundColor(selectedDate == day.date ? .white : Color.darkBlue)
                                .frame(width: 35, height: 35)
                                .background(selectedDate == day.date ? Color(red: 0.827, green: 0.369, blue: 0.222) : Color.white)
                                .clipShape(Circle())
                                .shadow(color: .gray.opacity(selectedDate == day.date ? 0.0 : 0.2), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            selectedDate = day.date  // ✅ Update selected day
                        }
                    }
                }
                //.padding(.horizontal, 15)
            }
        } .padding()
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

struct Day: Identifiable {
    let id = UUID()
    let date: String
    let dayName: String
    var isSelected: Bool = false
}

#Preview {
    CustomCalendar()
}
