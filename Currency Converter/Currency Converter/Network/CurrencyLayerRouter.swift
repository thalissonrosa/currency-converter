//
//  CurrencyLayerRouter.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import UIKit

enum CurrencyLayerRouter: Router {
    case getRates
    case getCurrencies
    
    var scheme: String {
        switch self {
        case .getCurrencies, .getRates:
            return "http"
        }
    }
    
    var host: String {
        switch self {
        case .getCurrencies, .getRates:
            return "apilayer.net"
        }
    }
    
    var path: String {
        switch self {
        case .getCurrencies:
            return "/api/list"
        case .getRates:
            return "/api/live"
        }
    }
    
    var method: String {
        switch self {
        case .getCurrencies, .getRates:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem] {
        let accessKey = "287c59bfe411876ee490d32c307d5c82"
        switch self {
        case .getCurrencies, .getRates:
            return [URLQueryItem(name: "access_key", value: accessKey)]
        }
    }
}
