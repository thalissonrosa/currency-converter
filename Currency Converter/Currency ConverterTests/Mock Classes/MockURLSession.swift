//
//  MockURLSession.swift
//  Currency ConverterTests
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation
@testable import Currency_Converter

class MockURLSession: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}



