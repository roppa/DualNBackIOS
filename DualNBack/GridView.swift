//
//  GridView.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//

import SwiftUI

struct GridView: View {
    @Binding var currentRound: Int
    @Binding var rounds: [Round]
    @Binding var initialDelayCompleted: Bool

    var body: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        Rectangle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(shouldHighlightCell(row: row, col: col) ? .yellow : .clear)
                            .border(Color.black, width: 1)
                    }
                }
            }
        }
    }
    
    private func shouldHighlightCell(row: Int, col: Int) -> Bool {
        guard initialDelayCompleted, currentRound > 0, currentRound <= rounds.count else {
            return false
        }
        return rounds[currentRound - 1].position == row * 3 + col
    }
}
