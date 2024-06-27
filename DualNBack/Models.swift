//
//  Models.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//

import Foundation

struct Round: Identifiable, Codable {
    var id = UUID()
    var position: Int
    var letter: String
}

struct Stats: Identifiable, Codable {
    var id = UUID()
    var correct: Int
    var incorrect: Int
    var total: Int
    var percentage: Int
    var n: Int // Add the current n
}

let letters = ["s", "t", "u", "v", "w", "x", "y", "z"]

func getRandomPosition() -> Int {
    return Int.random(in: 0..<9)
}

func getRandomLetter() -> String {
    return letters.randomElement()!
}

func generateRound() -> Round {
    return Round(position: getRandomPosition(), letter: getRandomLetter())
}

func percentageCorrect(results: [[String: Bool]], n: Int) -> Stats {
    let result = results.reduce((correct: 0, incorrect: 0, total: 0)) { (acc, curr) in
        var acc = acc
        if curr["position"] == true {
            acc.correct += 1
        } else {
            acc.incorrect += 1
        }
        if curr["letter"] == true {
            acc.correct += 1
        } else {
            acc.incorrect += 1
        }
        acc.total += 2
        return acc
    }
    return Stats(correct: result.correct, incorrect: result.incorrect, total: result.total, percentage: Int((Double(result.correct) / Double(result.total)) * 100), n: n)
}

func dualNBack(history: [Round], userInput: [[String: Any?]], n: Int) -> [[String: Bool]] {
    var results: [[String: Bool]] = []
    if history.count <= n { return results }

    for i in 0..<userInput.count {
        let currentUserInput = userInput[i]
        let previousHistoryItem = history[i]
        let nextHistoryItem = history[i + n]

        var result: [String: Bool] = ["position": false, "letter": false]

        if let userPosition = currentUserInput["position"] as? Int {
            result["position"] = userPosition == previousHistoryItem.position
        } else {
            result["position"] = nextHistoryItem.position != previousHistoryItem.position
        }

        if let userLetter = currentUserInput["letter"] as? String {
            result["letter"] = userLetter == previousHistoryItem.letter
        } else {
            result["letter"] = nextHistoryItem.letter != previousHistoryItem.letter
        }

        results.append(result)
    }

    return results
}

func saveStats(stats: [Stats]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(stats) {
        UserDefaults.standard.set(encoded, forKey: "userStats")
    }
}

func loadStats() -> [Stats] {
    if let savedStats = UserDefaults.standard.object(forKey: "userStats") as? Data {
        let decoder = JSONDecoder()
        if let loadedStats = try? decoder.decode([Stats].self, from: savedStats) {
            return loadedStats
        }
    }
    return []
}
