//
//  Router.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation

protocol Router {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var parameters: [URLQueryItem] { get }
}
