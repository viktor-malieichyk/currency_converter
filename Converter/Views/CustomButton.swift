//
//  CustomButton.swift
//  Converter
//
//  Created by Viktor Malieichyk on 05.04.2023.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
