//
//  BoardRoomsModel.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 21/07/1446 AH.
//

import Foundation


struct Root: Codable {
    let employees: [Employees]
    let boardRooms: [BoardRooms]
    let bookings: [Bookings]
}

// MARK EMPLOYEE
struct EmployeeField: Codable {
    let id: Int
    let jobTitle: String
    let name: String
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
           case id
           case jobTitle = "job_title"
           case name
           case email
           case password
       }
}

struct EmployeeRecord: Codable {
    let id: String
    let createdTime: String
    let fields: EmployeeField
}
struct Employees: Codable {
    let records: [EmployeeRecord]
}

// MARK BOARD ROOM
struct BoardRoomField: Identifiable,Codable {
    let id: String
    let name: String
    let floorNo: Int
    let seatNo: Int
    let description: String
    let facilities: [String]
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case floorNo = "floor_no"
            case seatNo = "seat_no"
            case description
            case facilities
            case imageURL = "image_url"
        }
    
    init(id: String, name: String, floorNo: Int, seatNo: Int, description: String, facilities: [String], imageURL: String){
        self.id = id
        self.name = name
        self.floorNo = floorNo
        self.seatNo = seatNo
        self.description = description
        self.facilities = facilities
        self.imageURL = imageURL
    }
}

struct BoardRoomsRecord: Codable{
    let id: String
    let createdTime: String
    let fields: BoardRoomField
    
    init(id: String, createdTime: String, fields: BoardRoomField) {
            self.id = id
            self.createdTime = createdTime
            self.fields = fields
        }
}

struct BoardRooms: Codable {
    let records: [BoardRoomsRecord]
}

// MARK BOOKING
struct BookingField: Codable {
    let employeeID: String
    let boardroomID: String
    let date: TimeInterval
    
    enum CodingKeys: String, CodingKey {
            case employeeID = "employee_id"
            case boardroomID = "boardroom_id"
            case date
        }
}

struct BookingsRecord: Identifiable ,Codable {
    let id: String
    let createdTime: String
    let fields: BookingField
}

struct Bookings: Codable {
    let records: [BookingsRecord]
}

