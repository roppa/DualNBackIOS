//
//  ContentView.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var n = 2
    @State private var gameDuration = 60
    @State private var showIntro = true
    @State private var showGame = false
    @State private var showOverview = false
    @State private var rounds: [Round] = []
    @State private var userInputHistory: [[String: Any?]] = []
    @State private var currentRound = 0
    @State private var stats: [Stats] = loadStats() // Load stats on app launch
    @State private var playerPositionResponse: Int?
    @State private var playerLetterResponse: String?
    @State private var player: AVAudioPlayer? // State variable for AVAudioPlayer
    @State private var buttonsEnabled = false // State variable to enable/disable buttons
    @State private var initialDelayCompleted = false // State variable for initial delay

    var body: some View {
        VStack {
            if showIntro {
                IntroView(n: $n, gameDuration: $gameDuration, startGame: startGame)
            } else if showGame {
                GameView(n: $n, rounds: $rounds, currentRound: $currentRound, playerPositionResponse: $playerPositionResponse, playerLetterResponse: $playerLetterResponse, buttonsEnabled: $buttonsEnabled, initialDelayCompleted: $initialDelayCompleted, nextRound: nextRound, endGame: endGame)
            } else if showOverview {
                OverviewView(stats: $stats, playAgain: showIntroScreen)
            }
        }
        .padding()
    }

    func startGame() {
        showIntro = false
        showGame = true
        showOverview = false

        rounds = []
        for _ in 0...Int(Double(gameDuration) / 3.0) {
            rounds.append(generateRound())
        }
        userInputHistory = []
        currentRound = 0
        buttonsEnabled = false // Disable buttons initially
        initialDelayCompleted = false // Set initial delay state to false

        // Add initial delay before starting the game
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1 second initial delay
            initialDelayCompleted = true // Set initial delay state to true
            nextRound()
        }
    }

    func nextRound() {
        if currentRound >= rounds.count {
            endGame()
            return
        }

        // Capture user input after the round is displayed and sound is played
        if currentRound >= n {
            captureUserInput()
            buttonsEnabled = true // Enable buttons after reaching n
        } else {
            buttonsEnabled = false // Keep buttons disabled
        }

        // Update the grid and play sound simultaneously
        DispatchQueue.main.async {
            playSound(letter: rounds[currentRound].letter)
            currentRound += 1
        }

        // Wait for the duration of the round before proceeding to the next round
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            nextRound()
        }
    }

    func captureUserInput() {
        let round = rounds[currentRound - 1] // Capture input for the previous round
        var userInput: [String: Any?] = [:]

        if let position = playerPositionResponse {
            userInput["position"] = position
        }
        if let letter = playerLetterResponse {
            userInput["letter"] = letter
        }

        userInputHistory.append(userInput)

        playerPositionResponse = nil
        playerLetterResponse = nil
    }

    func endGame() {
        showIntro = false
        showGame = false
        showOverview = true

        let results = dualNBack(history: rounds, userInput: userInputHistory, n: n)
        let gameStats = percentageCorrect(results: results, n: n)
        stats.append(gameStats)
        saveStats(stats: stats) // Save stats when the game ends
    }

    func showIntroScreen() {
        showIntro = true
        showGame = false
        showOverview = false
    }

    func playSound(letter: String) {
        guard let url = Bundle.main.url(forResource: letter, withExtension: "mp3") else {
            print("Failed to find sound file \(letter).mp3")
            return
        }

        do {
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.play()
            player = newPlayer // Assign the new player to the state variable
        } catch {
            print("Failed to play sound \(letter).mp3: \(error.localizedDescription)")
        }
    }
}
