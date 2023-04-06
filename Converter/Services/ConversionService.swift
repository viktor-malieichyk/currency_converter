//
//  ConversionService.swift
//  Converter
//
//  Created by Viktor Malieichyk on 04.04.2023.
//

import Foundation

enum ConversionError: Error {
    case invalidURL
    case requestError
    case decodingError
}

private let baseURL = "http://api.evp.lt/currency/commercial/exchange/"

class ConversionService {
    func convert(_ request: ConversionRequest, _ completion: @escaping (Result<ConversionResult, Error>) -> Void) {
        let urlString = baseURL + request.toURLParameters()
        guard let url = URL(string: urlString) else {
            return completion(.failure(ConversionError.invalidURL))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                return completion(.failure(ConversionError.requestError))
            }
            
            guard let result = try? JSONDecoder().decode(ConversionResult.self, from: data) else {
                completion(.failure(ConversionError.decodingError))
                return
            }
            if result.currency == .unknown {
                completion(.failure(ConversionError.decodingError))
            } else {
                completion(.success(result))
            }
        }
        
        task.resume()
    }
}

private extension ConversionRequest {
    func toURLParameters() -> String {
        return "\(amount)-\(fromCurrency)/\(toCurrency)/latest"
    }
}
