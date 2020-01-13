//
//  RealTimeRates.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import Foundation

class RealTimeRates: Codable {

    var source: String
    var timestamp: Double
    var quotes: Dictionary<String, Double>
}
