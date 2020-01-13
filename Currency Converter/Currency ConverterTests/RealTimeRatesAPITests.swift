//
//  RealTimeRatesAPITests.swift
//  Currency ConverterTests
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import XCTest
@testable import Currency_Converter

class RealTimeRatesAPITests: XCTestCase {

        var ratesLoader: APILoader<RealTimeRatesAPI>!
        var request: RealTimeRatesAPI!

        override func setUp() {
            request = RealTimeRatesAPI()
            let mockSession = MockNetworkingSession()
            guard let jsonData = JSONUtils.jsonDataFromFile(name: "rates") else {
                fatalError("JSON not found or invalid JSON file")
            }
            mockSession.data = jsonData
            ratesLoader = APILoader(apiRequest: request, urlSession: mockSession)
        }
        
        func testRequestBuild() {
            do {
                let urlRequest = try request.makeRequest(from: CurrencyLayerRouter.getRates)
                XCTAssertTrue(urlRequest.url?.scheme == "http")
                XCTAssertTrue(urlRequest.url?.host == "apilayer.net")
                XCTAssertTrue(urlRequest.url?.path == "/api/live")
            } catch {
                XCTFail("Error creating request")
            }
        }
        
        func testOkResponseParse() {
            var response: RealTimeRates?
            let expectation = self.expectation(description: "Proper response")
            
            ratesLoader.request(router: CurrencyLayerRouter.getRates) { (result) in
                switch result {
                case let .success(rates):
                    response = rates
                case .failure(_):
                    response = nil
                }
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1, handler: nil)
            XCTAssertNotNil(response?.source)
            XCTAssertNotNil(response?.quotes)
        }
    }
