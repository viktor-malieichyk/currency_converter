//
//  Balances.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import SwiftUI

struct BalanceCardView: View {
    let title: String
    let value: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).foregroundColor(Color("balanceBackground"))
            HStack {
                Text(title)
                    .font(.title2)
                Text(value)
                    .font(.title2)
            }
        }
        
    }
}
