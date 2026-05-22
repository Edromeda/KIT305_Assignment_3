//
//  Room.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//


import Foundation

struct Room {
    var id: String
    var name: String
    var labourCost: Double
    
    init(id: String, name: String, labourCost: Double) {
        self.id = id
        self.name = name
        self.labourCost = labourCost
    }
    
    init?(id: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let labourCost = data["labourCost"] as? Double else { return nil }
        self.id = id
        self.name = name
        self.labourCost = labourCost
    }
}