//
//  CurrencyLayerAPIs.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import UIKit

struct CurrenciesAPI: APIHandler {
    
    func parseResponse(data: Data) throws -> Currencies {
        let decoder = JSONDecoder()
        return try decoder.decode(Currencies.self, from: data)
    }
}

struct RealTimeRatesAPI: APIHandler {
    
    func parseResponse(data: Data) throws -> RealTimeRates {
        let decoder = JSONDecoder()
        return try decoder.decode(RealTimeRates.self, from: data)
    }
}
