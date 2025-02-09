//
//  Board_RoomsApp.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 19/07/1446 AH.
//

import SwiftUI

@main
struct Board_RoomsApp: App {
    @StateObject private var loginViewModel = LoginViewModel()
    var body: some Scene {
        
        WindowGroup {
            SignInView().environmentObject(loginViewModel)
        }
    }
}
