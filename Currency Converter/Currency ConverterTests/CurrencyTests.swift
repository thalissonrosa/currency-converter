//
//  Currency_ConverterTests.swift
//  Currency ConverterTests
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import XCTest
@testable import Currency_Converter

class CurrencyTests: XCTestCase {
    
    var currenciesLoader: APILoader<CurrenciesAPI>!
    var request: CurrenciesAPI!

    override func setUp() {
        request = CurrenciesAPI()
        let mockSession = MockNetworkingSession()
        guard let jsonData = JSONUtils.jsonDataFromFile(name: "currencies") else {
            fatalError("JSON not found or invalid JSON file")
        }
        mockSession.data = jsonData
        currenciesLoader = APILoader(apiRequest: request, urlSession: mockSession)
    }
    
    func testRequestBuild() {
        do {
            let urlRequest = try request.makeRequest(from: CurrencyLayerRouter.getCurrencies)
            XCTAssertTrue(urlRequest.url?.scheme == "http")
            XCTAssertTrue(urlRequest.url?.host == "apilayer.net")
            XCTAssertTrue(urlRequest.url?.path == "/api/list")
        } catch {
            XCTFail("Error creating request")
        }
    }
    
    func testOkResponseParse() {
        var response: Currencies?
        let expectation = self.expectation(description: "Proper response")
        
        currenciesLoader.request(router: CurrencyLayerRouter.getCurrencies) { (result) in
            switch result {
            case let .success(currencies):
                response = currencies
            case .failure(_):
                response = nil
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(response?.currencies)
    }
}
