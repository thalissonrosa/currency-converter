//
//  CurrencyConverterViewController.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet private var valueInputTextField: UITextField!
    @IBOutlet private var currencySelectorTextField: UITextField! {
        didSet {
            let picker = UIPickerView()
            picker.dataSource = self
            picker.delegate = self
            currencySelectorTextField.inputView = picker
        }
    }
    @IBOutlet private var exchangeRatesCollectionView: UICollectionView! {
        didSet {
            let layout = ExchangeRateFlowLayout()
            exchangeRatesCollectionView.collectionViewLayout = layout
            exchangeRatesCollectionView.dataSource = self
            exchangeRatesCollectionView.register(ExchangeRateCollectionViewCell.nib,
                forCellWithReuseIdentifier: ExchangeRateCollectionViewCell.identifier)
        }
    }
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

//MARK: CollectionView Data Source
extension CurrencyConverterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ExchangeRateCollectionViewCell.identifier,
            for: indexPath) as? ExchangeRateCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}

//MARK: PickerView Delegate
extension CurrencyConverterViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Teste"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

//MARK: PickerView Data Source
extension CurrencyConverterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        1
    }
    
    
}
