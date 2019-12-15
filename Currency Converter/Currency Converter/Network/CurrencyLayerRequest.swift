//
//  CurrencyLayerRequest.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import Foundation


enum CurrencyError: Error {
    case invalidURL(String)
    case requestError(String)
    case genericError(String)
}

protocol APIInfo {
    var url: String { get }
}

struct CurrencyLayerAPI: APIInfo {
    var url: String {
        return "http://apilayer.net/api/live?access_key=287c59bfe411876ee490d32c307d5c82"
    }
}

struct CurrencyLayerProvider {
    
    let apiInfo: APIInfo
    
    func getCurrencies(_ completion: @escaping (_ restaurants: Result<Currencies, Error>) -> Void) {
        guard let url = URL(string: "http://apilayer.net/api/list?access_key=287c59bfe411876ee490d32c307d5c82") else {
            completion(.failure(CurrencyError.invalidURL(apiInfo.url)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CurrencyError.genericError("No data available")))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let parsedResponse = try decoder.decode(Currencies.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(parsedResponse))
                }
            } catch let parseError {
                completion(.failure(parseError))
            }
        }
        task.resume()
    }
    
    func getRates(_ completion: @escaping (_ restaurants: Result<RealTimeRates, Error>) -> Void) {
        guard let url = URL(string: apiInfo.url) else {
            completion(.failure(CurrencyError.invalidURL(apiInfo.url)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CurrencyError.genericError("No data available")))
                }
                return
            }
            do {
                let decoder = JSONDecoder()
                let parsedResponse = try decoder.decode(RealTimeRates.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(parsedResponse))
                }
            } catch let parseError {
                completion(.failure(parseError))
            }
        }
        task.resume()
    }
}
