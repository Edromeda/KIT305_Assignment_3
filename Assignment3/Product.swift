//
//  Product.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 24/5/2026.
//


import Foundation

struct Product {
    var id: String
    var name: String
    var description: String
    var pricePerSqm: Double
    var category: String
    var variants: [String]
    var minWidth: Double?
    var maxWidth: Double?
    var minHeight: Double?
    var maxHeight: Double?
    
    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String,
              let description = dict["description"] as? String,
              let pricePerSqm = dict["price_per_sqm"] as? Double,
              let category = dict["category"] as? String,
              let variants = dict["variants"] as? [String] else { return nil }
        self.id = id
        self.name = name
        self.description = description
        self.pricePerSqm = pricePerSqm
        self.category = category
        self.variants = variants
        self.minWidth = dict["min_width"] as? Double
        self.maxWidth = dict["max_width"] as? Double
        self.minHeight = dict["min_height"] as? Double
        self.maxHeight = dict["max_height"] as? Double
    }
}