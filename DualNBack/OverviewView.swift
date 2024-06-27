//
//  OverviewView.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//

import SwiftUI

struct OverviewView: View {
    @Binding var stats: [Stats]
    var playAgain: () -> Void

    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .padding()

            List(stats) { stat in
                Text("N: \(stat.n), Correct/incorrect: \(stat.correct)/\(stat.incorrect) (\(stat.percentage)%)")
            }

            Spacer()

            Link("Buy me a coffee", destination: URL(string: "https://www.buymeacoffee.com/JuWxHBA")!)
                .padding()
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)

            Spacer()

            Button(action: playAgain) {
                Text("Play Again")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
