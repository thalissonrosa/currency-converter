//
//  CurrencyConverterCache.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import Foundation

final class CurrencyConverterCache {
    
    //MARK: Variables
    private let minimumRequestInterval = 30
    private var realTimeAPI: APILoader<RealTimeRatesAPI>
    private var currenciesAPI: APILoader<CurrenciesAPI>
    private var cache = NSCache<NSString, CachedRates>()
    private var lastRequestedCurrency: String?
    
    //MARK: Init
    init(realTimeRatesLoader: APILoader<RealTimeRatesAPI> = APILoader(apiRequest: RealTimeRatesAPI()),
         currenciesLoader: APILoader<CurrenciesAPI> = APILoader(apiRequest: CurrenciesAPI())) {
        self.realTimeAPI = realTimeRatesLoader
        self.currenciesAPI = currenciesLoader
    }
    
    //MARK: Public Methods
    /**
    Returns the rates for a given currency code. Since the free plan of CurrencyLayer uses USD as the default and doesn't support changing it, we'll not pass the currency code to the API.

    - parameter completion: The completion handler to call when the request is complete.
    - parameter currencyCode: The code of the currency
    */
    func loadRates(currencyCode: String = "USD", _ completion: @escaping (_ rates: Result<[Rate], Error>) -> Void) {
        if let cachedRates = cache.object(forKey: currencyCode as NSString),
            cachedRates.date.minutes(from: Date()) < minimumRequestInterval {
            lastRequestedCurrency = currencyCode
            completion(.success(cachedRates.array))
            return
        }
        
        realTimeAPI.request(router: CurrencyLayerRouter.getRates) { [weak self] (result: Result<RealTimeRates, Error>) in
            switch result {
            case let .success(response):
                let dataToCache = CachedRates(rates: response.quotes, source: response.source, date: Date())
                let rateArray = dataToCache.array
                self?.lastRequestedCurrency = currencyCode
                self?.cache.setObject(dataToCache, forKey: currencyCode as NSString)
                completion(.success(rateArray))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func loadCurrencies(_ completion: @escaping (_ currencies: Result<[Currency], Error>) -> Void) {
        currenciesAPI.request(router: CurrencyLayerRouter.getCurrencies) { (result: Result<Currencies, Error>) in
            switch result {
            case let .success(currencies):
                completion(.success(currencies.array))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func convert(value: Double, from: String, to: String) -> Double? {
        guard let currencyCode = lastRequestedCurrency,
            let cachedRates = cache.object(forKey: currencyCode as NSString) else { return nil }
        
        //Keys for the rates are on the format FROM+TO, for example, from USD to BRL, the key is USDBRL
        if let rate = cachedRates.rates[from+to] {
            return value * rate
        }
        if let rate = cachedRates.rates[from+to] {
            return value / rate
        }
        
        //When there's no direct conversion available, we'll have to do an extra step. For example, BRL to CAD is not avaible but USD to BRL is. In this scenario we'll first convert BRL to USD and then USD to CAD.
        let source = currencyCode
        guard let valueInSource = cachedRates.rates[source+from] else { return nil }
        
        let convertedValue = value / valueInSource
        return convert(value: convertedValue, from: source, to: to)
    }
}
