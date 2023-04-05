//
//  ConverterScreen.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import SwiftUI
import Combine

struct ConverterScreen: View {
    @ObservedObject private var viewModel: ConverterViewModel
    @State private var enteredAmount: Decimal = 0
    
    init(viewModel: ConverterViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("MY BALANCES")
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))) {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(viewModel.balances
                                .map { Balance(currency: $0.key, value: $0.value) }
                                .sorted(using: KeyPathComparator(\.value, order: .reverse)) )
                            { balance in
                                BalanceCardView(title: balance.currency.rawValue, value: String(format: "%.2f", balance.value))
                                    .frame(width: 150, height: 60)
                                    .frame(minWidth: 150, maxWidth: .infinity)
                            }
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                Section(header: Text("CURRENCY EXCHANGE")) {
                    ConverterContentView(currencies: $viewModel.currencies, value:  $viewModel.sellValue, kind: .sell, selectedCurrency: $viewModel.sellCurrency)
                    ConverterContentView(currencies: $viewModel.currencies, value:  $viewModel.receiveValue, kind: .receive, selectedCurrency: $viewModel.receiveCurrency)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Currency converter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color.blue,
                for: .navigationBar)
            
            Text(viewModel.errorDescription)
                .foregroundColor(.red)
            Spacer()
            CustomButton(title: "Convert") {
                viewModel.transferFunds()
            }
            .disabled(viewModel.state == .loading)
            .padding(24)
        }
        .alert(isPresented: $viewModel.showConversionInfo) {
            Alert(title: Text("Currency converted"),
                  message: Text(viewModel.lastConversion?.message ?? ""),
                  dismissButton: .default(Text("Done"), action: {
                viewModel.showConversionInfo = false
            }))
        }

    }
}

struct ConverterScreen_Previews: PreviewProvider {
    static var previews: some View {
        let service = ConversionService()
        let viewModel = ConverterViewModel(currencies: Currency.allCases, service: service)
        let _ = viewModel.addMoney(1000, currency: .usd)
        ConverterScreen(viewModel: viewModel)
    }
}



struct DecimalTextField: View {
    @Binding var value: Double
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        TextField("0", value: $value, formatter: formatter)
            .keyboardType(.decimalPad)
            .onReceive(Just(value)) { newValue in
                print("### \(newValue)")
                if value != newValue {
                    value = newValue
                }
            }
    }
}
