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

    //MARK: Outlets
    @IBOutlet private var currencyNameLabel: UILabel!
    @IBOutlet private var currencyCodeLabel: UILabel!
    @IBOutlet private var convertedValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
