//
//  Currency.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
    case eur = "EUR"
    case jpy = "JPY"
    case usd = "USD"
    case unknown
    
    static var allCases: [Currency] {
        return [.eur, .usd, .jpy]
    }
}
