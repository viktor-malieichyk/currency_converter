//
//  ConversionRequest.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import Foundation


/*
 http://api.evp.lt/currency/commercial/exchange/{fromAmount}-{fromCurrency}/{toCurrency}/latest
 */

struct ConversionRequest {
    let amount: Double
    let fromCurrency: Currency
    let toCurrency: Currency
}
