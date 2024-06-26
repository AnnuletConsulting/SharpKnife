//
//  Item.swift
//  SharpKnife
//
//  Created by Walt Moorhouse on 6/26/24.
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
