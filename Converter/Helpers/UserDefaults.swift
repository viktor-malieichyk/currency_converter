//
//  UserDefaults.swift
//  Converter
//
//  Created by Viktor Malieichyk on 05.04.2023.
//

import Foundation

extension UserDefaults {
    func setValue<T: RawRepresentable>(_ value: T?, forKey key: String) where T.RawValue == String {
        if let value = value {
            set(value.rawValue, forKey: key)
        } else {
            removeObject(forKey: key)
        }
    }
    
    func getValue<T: RawRepresentable>(forKey key: String) -> T? where T.RawValue == String {
        if let rawValue = string(forKey: key), let value = T(rawValue: rawValue) {
            return value
        } else {
            return nil
        }
    }
}
