//
//  FloorSpace.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//


import Foundation

struct FloorSpace {
    var id: String
    var name: String
    var widthMm: Double
    var heightMm: Double
    
    init(id: String, name: String, widthMm: Double, heightMm: Double) {
        self.id = id
        self.name = name
        self.widthMm = widthMm
        self.heightMm = heightMm
    }
    
    init?(id: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let widthMm = data["widthMm"] as? Double,
              let heightMm = data["heightMm"] as? Double else { return nil }
        self.id = id
        self.name = name
        self.widthMm = widthMm
        self.heightMm = heightMm
    }
    
    var areaSqm: Double {
        return (widthMm / 1000) * (heightMm / 1000)
    }
}