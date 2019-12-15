//
//  CurrencyConverterCache.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

final class CurrencyConverterCache {
    
    private let minimumRequestInterval = 30
    private var service: Service
    private var cache = NSCache<NSString, CachedRates>()
    private var currentRates: Dictionary<String, Double>?
    
    init(service: Service) {
        self.service = service
    }
    
    /**
    Returns the rates for a given currency code. Since the free plan of CurrencyLayer uses USD as the default and doesn't support changing it, we'll not pass the currency code to the API.

    - parameter completion: The completion handler to call when the request is complete.
    - parameter currencyCode: The code of the currency
    */
    func loadRates(currencyCode: String = "USD" , _ completion: @escaping (_ rates: Result<[Rate], Error>) -> Void) {
        if let cachedRates = cache.object(forKey: currencyCode as NSString),
            cachedRates.date.minutes(from: Date()) < minimumRequestInterval {
            currentRates = cachedRates.rates
            completion(.success(cachedRates.array))
            return
        }
        
        service.request(router: CurrencyLayerRouter.getRates) { [weak self] (result: Result<RealTimeRates, Error>) in
            switch result {
            case let .success(response):
                let dataToCache = CachedRates(rates: response.quotes, source: response.source, date: Date())
                let rateArray = dataToCache.array
                self?.currentRates = response.quotes
                self?.cache.setObject(dataToCache, forKey: currencyCode as NSString)
                completion(.success(rateArray))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencies(_ completion: @escaping (_ currencies: Result<[Currency], Error>) -> Void) {
        service.request(router: CurrencyLayerRouter.getCurrencies) { (result: Result<Currencies, Error>) in
            switch result {
            case let .success(currencies):
                completion(.success(currencies.array))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func convert(value: Double, from: String, to: String) -> Double {
        guard let rates = currentRates else { return -1 }
        
        if let rate = rates[from+to] {
            return value * rate
        }
        
        //Figure out the current rates source
        guard let firstKey = rates.keys.first else { return -1 }
        let source = String(firstKey.prefix(Currency.currencyCodeLength))
        guard let valueInSource = rates[source+from] else { return -1 }
        let convertedValue = value / valueInSource
        return convert(value: convertedValue, from: source, to: to)
    }
}
