//
//  ConversionInfo.swift
//  Converter
//
//  Created by Viktor Malieichyk on 05.04.2023.
//

import Foundation

struct ConversionInfo {
    let request: ConversionRequest
    let result: ConversionResult
    let comission: Double
    
    var message: String {
        return "You have converted \(request.amount) \(request.fromCurrency.rawValue) to\n" +
            "\(result.amount) \(result.currency.rawValue). Comission Fee - \(comission) \(request.fromCurrency.rawValue)."
    }
}
