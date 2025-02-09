//
//  LoginViewModel.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 21/07/1446 AH.
//

import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let message: String
    let employee: EmployeeField? // Employee details if authentication is successful
}

final class LoginViewModel: ObservableObject {
    
    @Published var employeeData: [Employees] = []
    @Published var boardRooms: [BoardRooms] = []
    @Published var employeeBookings: [Bookings] = []
    @Published var root: [Root] = []
    @Published var errorMessage: String?
    @Published var loggedInUser: EmployeeField?
    @Published var bookedDates: [String] = []
    
    //MARK: Function to authinticate user and save the logged in user
    func authinticateUser(id: Int, password: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appElKqRPusTLsnNe/employees") else {
            print("Invalid URL")
            completion(false)
            return
        }
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to connect: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            // Log raw JSON for debugging
            print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
            // Decode the response
            do {
                
                let employees = try JSONDecoder().decode(Employees.self, from: data)
                
                // Check if any record matches and save logged in user
                if let matchingEmployee = employees.records.first(where: { $0.fields.id == id && $0.fields.password == password }) {
                    DispatchQueue.main.async {
                        self.loggedInUser = EmployeeField(
                            id: matchingEmployee.fields.id,
                            jobTitle: matchingEmployee.fields.jobTitle,
                            name: matchingEmployee.fields.name,
                            email: matchingEmployee.fields.email,
                            password: matchingEmployee.fields.password
                        )
                        completion(true) // Login success
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Invalid job number or password")
                        completion(false)
                    }
                }
            } catch {
                print("Decoding failed: \(error)")
                completion(false)
            }
            
        }.resume()
        
    }
    
    
    //MARK: Function to fetch board rooms
    func fetchBoardRooms(completion: @escaping ([BoardRoomsRecord]) -> Void) {
            guard let url = URL(string: "https://api.airtable.com/v0/appElKqRPusTLsnNe/boardrooms") else { return }
            var request = URLRequest(url: url)
        
            // Create the request
            request.httpMethod = "GET"
            request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")

            // Send the request
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    print("Error fetching boardrooms: \(error.localizedDescription)")
                    completion([])
                    return
                }

                guard let data = data else {
                    print("No data received for boardrooms")
                    completion([])
                    return
                }

                // Decode the response
                do {
                    let boardRooms = try JSONDecoder().decode(BoardRooms.self, from: data)
                    completion(boardRooms.records)
                } catch {
                    print("Error decoding boardrooms: \(error.localizedDescription)")
                    completion([])
                }
            }.resume()
        }
    
    
    //MARK: Function to fetch booking for the logged in user
    func fetchBookings(for employeeID: String, completion: @escaping ([BookingsRecord]) -> Void) {
        
        guard let url = URL(string: "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings") else {
            print("Invalid URL")
            completion([])
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to connect: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            // Decode the response
            do {
                let bookingResponse = try JSONDecoder().decode(Bookings.self, from: data)
                let filteredBookings = bookingResponse.records.filter { $0.fields.employeeID == employeeID }
                DispatchQueue.main.async {
                    completion(filteredBookings)
                }
            } catch {
                print("Decoding failed: \(error)")
                completion([])
            }
        }.resume()
    }
    
    
    //MARK: Function to book a board room
    func bookBoardRoom(boardroomID: String, selectedDate: String, completion: @escaping (Bool, String?) -> Void) {
        
        guard let loggedInUserID = loggedInUser?.id else {
            completion(false, "User not logged in")
            return
        }
        
        let dateComponents = DateComponents(year: Calendar.current.component(.year, from: Date()),
                                            month: Calendar.current.component(.month, from: Date()),
                                            day: Int(selectedDate))
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            completion(false, "Invalid date")
            return
        }
        
        let booking = BookingField(
            employeeID: "\(loggedInUserID)",
            boardroomID: boardroomID,
            date: date.timeIntervalSince1970
        )
        
        guard let url = URL(string: "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings") else {
            completion(false, "Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            //  Wrap BookingField inside BookingsRecord then decod
            let bookingData = ["records": [["fields": booking]]]
            
            let jsonData = try JSONEncoder().encode(bookingData)
            request.httpBody = jsonData
        } catch {
            completion(false, "Failed to encode booking data")
            return
        }
        
        // Perform the actual API request
        URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if error == nil {
                            self.bookedDates.append(selectedDate) // ✅ Update booked dates
                            completion(true, nil)
                        } else {
                            completion(false, error?.localizedDescription)
                        }
                    }
        }.resume()
    }
    
    func fetchBookedDates(for boardroomID: String) {
            guard let url = URL(string: "https://api.airtable.com/v0/appElKqRPusTLsnNe/bookings") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer pat7E88yW3dgzlY61.2b7d03863aca9f1262dcb772f7728bd157e695799b43c7392d5faf4f52fcb001", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else { return }

                do {
                    let decodedData = try JSONDecoder().decode(Bookings.self, from: data)
                    let calendar = Calendar.current
                    
                    DispatchQueue.main.async {
                            self.bookedDates = decodedData.records.compactMap { record in
                                if record.fields.boardroomID == boardroomID {
                                    let date = Date(timeIntervalSince1970: record.fields.date)
                                    return "\(calendar.component(.day, from: date))"
                                }
                                return nil
                        }
                    }
                } catch {
                    print("Error decoding bookings: \(error)")
                }
            }.resume()
        }
    
    
        
    }

