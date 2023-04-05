//
//  ExchangeView.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import SwiftUI

struct ConverterContentView: View {
    @Binding var currencies: [Currency]
    @Binding var value: Double
    let kind: Kind
    @Binding var selectedCurrency: Currency

    var body: some View {
        HStack {
            Image(systemName: kind.icon)
                .foregroundColor(kind.color)
                .font(.system(size: 32.0))
            Text("\(kind.title)")
            Spacer()
            DecimalTextField(value: $value)
            .keyboardType(.decimalPad)
            .frame(width: 100)
            .disabled(!kind.isEditable)
            .multilineTextAlignment(.trailing)
            .foregroundColor(kind.color)

            Picker("", selection: $selectedCurrency) {
                ForEach(currencies, id: \.self) { selection in
                    Text(selection.rawValue)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 80)
        }
    }
}

struct ConverterContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterContentView(currencies: .constant(Currency.allCases), value: .constant(0.0), kind: .sell, selectedCurrency: .constant(.eur))
    }
}

enum Kind {
    case sell
    case receive
    
    var icon: String {
        switch self {
        case .sell:
            return "arrow.up.square.fill"
        case .receive:
            return "arrow.down.square.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .sell:
            return .red
        case .receive:
            return .green
        }
    }
    
    var title: String {
        switch self {
        case .sell:
            return "Sell"
        case .receive:
            return "Receive"
        }
    }
    
    var isEditable: Bool {
        switch self {
        case .sell:
            return true
        case .receive:
            return false
        }
    }
}
