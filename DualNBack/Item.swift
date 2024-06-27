//
//  Item.swift
//  DualNBack
//
//  Created by Mark Robson on 27/06/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
