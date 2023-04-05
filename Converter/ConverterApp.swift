//
//  ConverterApp.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import SwiftUI

@main
struct ConverterApp: App {
    var body: some Scene {
        WindowGroup {
            let service = ConversionService()
            let viewModel = ConverterViewModel(currencies: Currency.allCases, service: service)
            let _ = viewModel.addMoney(1000, currency: .usd)
            ConverterScreen(viewModel: viewModel)
        }
    }
}
