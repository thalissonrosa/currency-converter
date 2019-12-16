//
//  ExchangeRateCollectionViewCell.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

class ExchangeRateCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ExchangeRateCell"
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    //MARK: A
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumFractionDigits = 3
        return numberFormatter
    }()

    //MARK: Outlets
    @IBOutlet var currencyNameLabel: UILabel!
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var convertedValueLabel: UILabel!
    
    func configure(name: String?, code: String?, value: Double?) {
        currencyNameLabel.text = name
        currencyCodeLabel.text = code
        if let value = value {
            convertedValueLabel.text = numberFormatter.string(from: NSNumber(value: value))
        } else {
            convertedValueLabel.text = AppStrings.notApplicable.localized
        }
    }
}
