//
//  ConverterTests.swift
//  Currency ConverterTests
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import XCTest
@testable import Currency_Converter

class ConverterTests: XCTestCase {
    
    var cache: CurrencyConverterCache!

    override func setUp() {
        // The CurrencyConverterCache is not automatically making a request to the live rates data, since on the app we'll only do it when the user selects a currency. That's why we have to make the loadRates() call here.
        let request = RealTimeRatesAPI()
        let mockSession = MockNetworkingSession()
        guard let jsonData = JSONUtils.jsonDataFromFile(name: "rates") else {
            fatalError("JSON not found or invalid JSON file")
        }
        mockSession.data = jsonData
        let ratesLoader = APILoader(apiRequest: request, urlSession: mockSession)
        cache = CurrencyConverterCache(realTimeRatesLoader: ratesLoader)
        let expectation = self.expectation(description: "Proper response")
        cache.loadRates { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Failure getting rates")
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testConvertUSDtoBRL() {
        let from = "USD"
        let to = "BRL"
        let value = 10.0
        let convertedValue = cache.convert(value: value, from: from, to: to)
        XCTAssertEqual(convertedValue, 41.08404)
    }
    
    func testConvertBRLtoUSD() {
        let from = "BRL"
        let to = "USD"
        let value = 10.0
        let convertedValue = cache.convert(value: value, from: from, to: to)
        XCTAssertEqual(convertedValue, 2.434035211726987)
    }
    
    func testConvertBRLtoCND() {
        let from = "BRL"
        let to = "CAD"
        let value = 10.0
        let convertedValue = cache.convert(value: value, from: from, to: to)
        XCTAssertEqual(convertedValue, 3.204711610640044)
    }
}
