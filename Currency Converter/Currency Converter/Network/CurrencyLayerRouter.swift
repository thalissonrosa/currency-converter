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
        switch self {
        case .getCurrencies, .getRates:
            guard let key = accessKey else {
                assertionFailure("Missing accessKey")
                return []
            }
            return [URLQueryItem(name: "access_key", value: key)]
        }
    }
}

//MARK: Private variables/methods
private extension CurrencyLayerRouter {
    
    var accessKey: String? {
        guard let path = Bundle.main.path(forResource: "API", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String : String] else {
                return nil
        }
        return dictionary["AccessKey"]
    }
}
