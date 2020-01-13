//
//  JSONUtils.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import Foundation

final class JSONUtils {
    
    static func jsonDataFromFile(name: String) -> Data? {
        guard let path = Bundle.main.url(forResource: name, withExtension: "json") else {
            assertionFailure("JSON file not found")
            return nil
        }
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            assertionFailure("Invalid JSON file")
            return nil
        }
    }
}
