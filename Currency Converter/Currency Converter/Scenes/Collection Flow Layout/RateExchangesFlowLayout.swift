//
//  ExchangeRateFlowLayout.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

final class ExchangeRateFlowLayout: UICollectionViewFlowLayout {
    
    //MARK: - Private Variables
    private let maxNumColumns: Int = 2
    private let cellHeight: CGFloat = 98.0
    
    // MARK: - Overrides
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let separatorSpace = minimumInteritemSpacing * CGFloat(maxNumColumns - 1)
        let availableWidth = collectionView.bounds.width - separatorSpace
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}
