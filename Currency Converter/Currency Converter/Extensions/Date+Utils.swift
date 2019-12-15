//
//  Date+Utils.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import Foundation

extension Date {

    func minutes(from date: Date) -> Int {
      return abs(Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0)
    }
}
