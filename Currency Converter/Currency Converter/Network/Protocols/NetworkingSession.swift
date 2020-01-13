//
//  NetworkingSession.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 16/12/19.
//

import Foundation

protocol NetworkingSession {
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}
