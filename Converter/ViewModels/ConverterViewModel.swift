//
//  ConverterViewModel.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import Foundation

enum ConverterError: LocalizedError {
    case nothingToConvert
    case notEnoughMoney
    case wrongAmount
    case serviceError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .nothingToConvert:
            return "Nothing to convert"
        case .notEnoughMoney:
            return "Not enough money"
        case .wrongAmount:
            return "Worng amount"
        case .serviceError(message: let message):
            return "Service error: \(message)"
        }
    }
}

enum ModelState {
    case none, loading, success, failed
}

class BaseViewModel: ObservableObject {
    @Published var state: ModelState = .none
}

struct Balance: Identifiable {
    let id = UUID()
    
    let currency: Currency
    let value: Double
}

class ConverterViewModel: BaseViewModel {
    private var service: ConversionService
    
    private let debounceInterval: TimeInterval = 0.5
    private var debounceTimer: Timer?
    
    var conversionNumber: Int = 0
    let conversionFee: Double = 0.007
    let numberOfFreeConversions = 5
    func calculateFee(for sum: Double) -> Double {
        if conversionNumber < numberOfFreeConversions {
            return 0
        }
        return sum * conversionFee
    }
    
    @Published var balances: [Currency: Double]
    @Published var currencies: [Currency]
    
    @Published var sellValue: Double = 0.0 {
        didSet {
            convertWithDelay()
        }
    }
    @Published var sellCurrency: Currency {
        didSet {
            UserDefaults().setValue(sellCurrency, forKey: "sellCurrency")
            convertWithDelay()
        }
    }
    
    @Published var receiveValue: Double = 0.0
    @Published var receiveCurrency: Currency {
        didSet {
            UserDefaults().setValue(receiveCurrency, forKey: "receiveCurrency")
            convertWithDelay()
        }
    }
    
    @Published var error: ConverterError?
    var lastConversion: ConversionInfo? = nil
    @Published var showConversionInfo: Bool = false
    
    var errorDescription: String {
        return error?.localizedDescription ?? ""
    }
    
    init(currencies: [Currency], service: ConversionService) {
        self.service = service
        self.currencies = currencies
        self.balances = currencies.reduce(into: [:]) { dict, currency in
            dict[currency] = 0.0
        }
        
        self.sellCurrency = UserDefaults().getValue(forKey: "sellCurrency") ?? .usd
        self.receiveCurrency = UserDefaults().getValue(forKey: "receiveCurrency") ?? .eur
        super.init()
        print(sellCurrency)
        print(receiveCurrency)
    }
    
    func addMoney(_ value: Double, currency: Currency) {
        if let currentBalance = balances[currency] {
            balances[currency] = currentBalance + value
        } else {
            currencies.append(currency)
            balances[currency] = value
        }
    }
    
    func convertWithDelay() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval, repeats: false) { _ in
            self.convert(changeBalance: false)
        }
    }
    
    fileprivate func processConversion(request: ConversionRequest, result: ConversionResult) {
        let fee = calculateFee(for: sellValue)
        
        let currentRecivingBalance = self.balances[result.currency] ?? 0.0
        self.balances[result.currency] = currentRecivingBalance + result.amount
        self.conversionNumber += 1
        
        let currentSellingBalance = self.balances[request.fromCurrency] ?? 0.0
        self.balances[request.fromCurrency] = currentSellingBalance - request.amount - self.calculateFee(for: request.amount)
        
        self.lastConversion = .init(request: request, result: result, comission: fee)
        self.showConversionInfo = true
    }
    
    fileprivate func convert(changeBalance: Bool = true) {
        let conversionRequest = ConversionRequest(amount: sellValue, fromCurrency: sellCurrency, toCurrency: receiveCurrency)
        error = nil
        
        service.convert(conversionRequest) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.state = .success
                
                switch result {
                case let .success(conversionResult):
                    if changeBalance {
                        self.processConversion(request: conversionRequest, result: conversionResult)
                    }
                    self.receiveValue = conversionResult.amount
                case let .failure(error):
                    self.state = .failed
                    self.error = .serviceError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func transferFunds() {
        if sellCurrency == receiveCurrency || sellValue <= 0.0{
            error = .nothingToConvert
            return
        }
        if sellValue + calculateFee(for: sellValue) <= balances[sellCurrency] ?? 0.0 {
            convert()
        } else {
            error = .notEnoughMoney
        }
    }
}
