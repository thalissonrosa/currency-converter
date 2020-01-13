//
//  MockNetworkingSession.swift
//  Currency ConverterTests
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation
@testable import Currency_Converter

class MockNetworkingSession: NetworkingSession {
    
    var data: Data?
    var error: Error?
    var response: URLResponse?
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }
}
