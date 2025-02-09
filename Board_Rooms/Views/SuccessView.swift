//
//  SuccessView.swift
//  Board_Rooms
//
//  Created by Wejdan Alghamdi on 29/07/1446 AH.
//

import SwiftUI

struct SuccessView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        ZStack {
            Image("successBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .padding(.bottom, 400)
            
            VStack(spacing: 20){
                
                Text("Booking Successe!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.darkBlue)
                
//                VStack{
//                    Text("Your booking for Ideation Room on Sunday, March 19, 2023 is confirmed.")
//                        .font(.subheadline)
//                        .foregroundColor(.darkBlue)
//                        .multilineTextAlignment(.center)
//                    
//                }.frame(width: 358, height: 89)
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 60, height: 40)
                        
                }.buttonStyle(.borderedProminent)
                    .tint(Color.pigOrange)
                    .padding()
                
                
                
                
            }.padding()
            .padding(.top, 350)
               
            
        }.background(Color.background)
    }
}

#Preview {
    SuccessView()
}
