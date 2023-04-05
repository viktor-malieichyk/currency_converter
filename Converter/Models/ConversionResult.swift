//
//  ConversionResult.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import Foundation

/*
 {
 "amount": "49344",
 "currency": "JPY"
 }
*/

struct ConversionResult: Codable {
    let amount: Double
    let currency: Currency
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let amountString = try container.decode(String.self, forKey: .amount)
        amount = Double(amountString) ?? 0.0
        let currencyString = try container.decode(String.self, forKey: .currency)
        currency = Currency(rawValue: currencyString) ?? .unknown
    }
}
