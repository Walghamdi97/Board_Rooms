//
//  SignInView.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 19/07/1446 AH.
//

import SwiftUI

struct SignInView: View {
    @State private var jobNumber: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var navigateToMainScreen: Bool = false
    @State private var showAlert: Bool = false
    @EnvironmentObject var empLogin: LoginViewModel
    
    var body: some View {
        NavigationView{
            Group{
                if navigateToMainScreen {
                    HomePageView()
                } else {
                    
                    
                    ZStack{
                        Image("backgroundImage")
                            .resizable()
                            
                            //.scaledToFill()
                            .frame(width: .infinity, height: 400)
                            .edgesIgnoringSafeArea(.top)
                            //.ignoresSafeArea()
                            
                            //.edgesIgnoringSafeArea(.all)
                            //.padding(.bottom, 400)
                        
                        VStack(spacing: 20){
                            Text("Welcome back! Glad to see you, Again!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.pigOrange)
                            
                            
                            TextField("Enter Your Job Number", text: $jobNumber)
                                .padding()
                                .frame(width: 360.0, height: 50.0)
                                .background((Color.white).cornerRadius(8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 0.3)
                                )
                                .keyboardType(.numberPad)
                            
                            //.padding(.all)
                            
                            ZStack {
                                if isPasswordVisible {
                                    TextField("Enter your password", text: $password)
                                        .padding()
                                        .frame(width: 360.0, height: 50.0)
                                        .background(Color(.white))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                } else {
                                    SecureField("Enter your password", text: $password)
                                        .padding()
                                        .frame(width: 360.0, height: 50.0)
                                        .background(Color(.white))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray, lineWidth: 0.3)
                                        )
                                }
                                
                                // Eye Icon for Password Toggle
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.black)
                                    }
                                    .padding(.trailing, 25)
                                }
                            }
                            
                            
                            
                            Button(action: {
                                empLogin.authinticateUser(id: Int(jobNumber) ?? 0, password: password){ success in
                                    if success {
                                        print("Login successful")
                                        navigateToMainScreen = true
                                    } else {
                                        showAlert = true
                                    }
                                }
                                
                            }) {
                                
                                Text("Login")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 360.0, height: 50.0)
                                    .background((Color.darkBlue).cornerRadius(8))
                            }.padding()
                            Spacer()
                            
                        }.padding()
                            .padding(.top, 100)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Login Failed"),
                                    message: Text(empLogin.errorMessage ?? "Unknown error"),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        
                    }//.ignoresSafeArea()
                    
                    //.edgesIgnoringSafeArea(.top)
                    .background(Color.background)// end of ZStack
                }
            }
            
        } // End of navigationView
    }
}

#Preview {
    SignInView()
}
