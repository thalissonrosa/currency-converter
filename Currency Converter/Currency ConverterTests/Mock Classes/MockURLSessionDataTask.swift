//
//  MockURLSessionDataTask.swift
//  Currency ConverterTests
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
    
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
