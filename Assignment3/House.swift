//
//  House.swift
//  Assignment3
//
//  Created by Chris Edrom Luchavez on 18/5/2026.
//
import Foundation

struct House {
    var id: String
    var customerName: String
    var address: String
    
    init(id: String, customerName: String, address: String) {
        self.id = id
        self.customerName = customerName
        self.address = address
    }
    
    init?(id: String, data: [String: Any]) {
        guard let customerName = data["customerName"] as? String,
              let address = data["address"] as? String else { return nil }
        self.id = id
        self.customerName = customerName
        self.address = address
    }
}
