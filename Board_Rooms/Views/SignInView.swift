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
    var body: some View {
        ZStack{
            Image("backgroundImage")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, 400)
            VStack{
            
            //Spacer()
//                Rectangle()
//                    .fill(Color.background)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .edgesIgnoringSafeArea(.all)
                    
            }
            VStack(spacing: 20){
                Text("Welcome back! Glad to see you, Again!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color.pigOrange)
                
                
                TextField("Enter Your Job Number", text: $jobNumber)
                    .padding()
                    .frame(width: 360.0, height: 50.0)
                    .background((Color.white).cornerRadius(8))
                    
                    //.padding(.all)
                
                TextField("Enter Your Password", text: $password)
                    .padding()
                    .frame(width: 360.0, height: 50.0)
                    .background((Color.white).cornerRadius(8))
                    //.padding(.all, -10)
                
                Button(action: {
                    
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
            
            VStack{
                
            }
//            VStack(alignment: .leading, spacing: 20){
//                Text("Sign In")
//                    .font(.system(size: 30, weight: .bold, design: .default))
//                    .foregroundColor(.white)
//                
//                TextField("Email", text: .constant(""))
//            }
        }.background(Color.background)
    }
}

#Preview {
    SignInView()
}
