//
//  GameView.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//

import SwiftUI

struct GameView: View {
    @Binding var n: Int
    @Binding var rounds: [Round]
    @Binding var currentRound: Int
    @Binding var playerPositionResponse: Int?
    @Binding var playerLetterResponse: String?
    @Binding var buttonsEnabled: Bool
    @Binding var initialDelayCompleted: Bool
    var nextRound: () -> Void
    var endGame: () -> Void

    var body: some View {
        VStack {
            Text("N = \(n)")
                .font(.largeTitle)
                .padding()

            GridView(currentRound: $currentRound, rounds: $rounds, initialDelayCompleted: $initialDelayCompleted)
                .padding()

            HStack {
                Button(action: {
                    if currentRound >= n {
                        playerLetterResponse = rounds[currentRound - n].letter
                    }
                }) {
                    Text("Sound")
                        .padding()
                        .background(buttonsEnabled ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!buttonsEnabled)

                Button(action: {
                    if currentRound >= n {
                        playerPositionResponse = rounds[currentRound - n].position
                    }
                }) {
                    Text("Position")
                        .padding()
                        .background(buttonsEnabled ? Color.orange : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!buttonsEnabled)
            }
            .padding()
        }
    }
}
