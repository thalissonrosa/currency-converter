//
//  URLSession+NetworkingSession.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 16/12/19.
//

import Foundation

extension URLSession: NetworkingSession {
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
    }
}
