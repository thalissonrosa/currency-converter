//
//  RequestHandler.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation

protocol RequestHandler {
    
    func makeRequest(from router: Router) throws -> URLRequest
}

extension RequestHandler {
    
    func makeRequest(from router: Router) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        guard let url = components.url else { throw ServiceError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = router.method
        return urlRequest
    }
}
