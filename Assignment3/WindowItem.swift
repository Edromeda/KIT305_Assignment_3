//
//  WindowItem.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 22/5/2026.
//
import Foundation

struct WindowItem {
    var id: String
    var name: String
    var widthMm: Double
    var heightMm: Double
    var productId: String?
    var productName: String?
    var productPricePerSqm: Double?
    var selectedVariant: String?
    
    init(id: String, name: String, widthMm: Double, heightMm: Double, productId: String? = nil, productName: String? = nil, productPricePerSqm: Double? = nil, selectedVariant: String? = nil) {
        self.id = id
        self.name = name
        self.widthMm = widthMm
        self.heightMm = heightMm
        self.productId = productId
        self.productName = productName
        self.productPricePerSqm = productPricePerSqm
        self.selectedVariant = selectedVariant
    }
    
    init?(id: String, data: [String: Any]) {
        guard let name = data["name"] as? String,
              let widthMm = data["widthMm"] as? Double,
              let heightMm = data["heightMm"] as? Double else { return nil }
        self.id = id
        self.name = name
        self.widthMm = widthMm
        self.heightMm = heightMm
        self.productId = data["productId"] as? String
        self.productName = data["productName"] as? String
        self.productPricePerSqm = data["productPricePerSqm"] as? Double
        self.selectedVariant = data["selectedVariant"] as? String
    }
    
    var areaSqm: Double { return (widthMm / 1000) * (heightMm / 1000) }
    var effectiveRate: Double { return productPricePerSqm ?? 50.0 }
}
