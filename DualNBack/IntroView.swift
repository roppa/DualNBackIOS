//
//  IntroView.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//
import SwiftUI

struct IntroView: View {
    @Binding var n: Int
    @Binding var gameDuration: Int
    var startGame: () -> Void
    
    var body: some View {
        VStack {
            Text("Dual N-Back Game")
                .font(.largeTitle)
                .padding()
            
            HStack {
                Text("Set N-back Level:")
                TextField("N-back Level", value: $n, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding()
            
            HStack {
                Text("Set Game Duration (seconds):")
                TextField("Game Duration", value: $gameDuration, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            .padding()
            
            Button(action: startGame) {
                Text("Start")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
