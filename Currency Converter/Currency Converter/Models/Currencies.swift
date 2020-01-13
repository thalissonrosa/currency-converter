//
//  Currencies.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

struct Currencies: Codable {
    
    var currencies: Dictionary<String, String>
}

extension Currencies {
    var array: [Currency] {
        let array = currencies.map { Currency(name: $0.value,
                                              code: $0.key) }
        return array.sorted { $0.name < $1.name }
    }
}
