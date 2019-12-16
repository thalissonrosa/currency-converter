//
//  AppStrings.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 15/12/19.
//

import UIKit

enum AppStrings: String {
    case notApplicable
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
