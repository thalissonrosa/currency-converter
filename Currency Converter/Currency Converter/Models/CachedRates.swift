//
//  CachedRates.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation

class CachedRates {
    var source: String
    var date: Date
    var rates: Dictionary<String, Double>
    
    var array: [Rate] {
        let array = rates.map { (key, value) -> Rate in
            let to = String(key.suffix(Currency.currencyCodeLength))
            return Rate(from: source, to: to, rate: value)
        }
        return array.sorted { $0.to < $1.to }
    }
    
    init(rates: Dictionary<String, Double>, source: String, date: Date) {
        self.source = source
        self.rates = rates
        self.date = date
    }
}
