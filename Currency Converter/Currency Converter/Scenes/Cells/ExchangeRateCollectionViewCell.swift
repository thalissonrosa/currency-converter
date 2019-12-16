//
//  ExchangeRateCollectionViewCell.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

class ExchangeRateCollectionViewCell: UICollectionViewCell {
    
    //MARK: Static properties
    static let identifier = "ExchangeRateCell"
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    //MARK: Private variables
    private lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp
        numberFormatter.maximumFractionDigits = 3
        numberFormatter.minimumFractionDigits = 3
        return numberFormatter
    }()

    //MARK: Outlets
    @IBOutlet var currencyCodeLabel: UILabel!
    @IBOutlet var convertedValueLabel: UILabel!
    
    //MARK: Overrides
    override func prepareForReuse() {
        currencyCodeLabel.text = nil
        convertedValueLabel.text = nil
    }
    
    override func awakeFromNib() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
    }
    
    //MARK: Public functions
    func configure(code: String?, value: Double?) {
        currencyCodeLabel.text = code
        if let value = value {
            convertedValueLabel.text = numberFormatter.string(from: NSNumber(value: value))
        } else {
            convertedValueLabel.text = AppStrings.notApplicable.localized
        }
    }
}
