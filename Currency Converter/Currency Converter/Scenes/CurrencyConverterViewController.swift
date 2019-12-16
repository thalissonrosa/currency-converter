//
//  CurrencyConverterViewController.swift
//  Currency Converter
//
//  Created by Thalisson da Rosa on 14/12/19.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet private var loadingView: UIView!
    @IBOutlet private var convertButton: UIButton!
    @IBOutlet private var valueInputTextField: UITextField! {
        didSet {
            valueInputTextField.delegate = self
        }
    }
    @IBOutlet private var currencySelectorTextField: UITextField! {
        didSet {
            currencySelectorTextField.inputView = pickerView
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
    
    //MARK: Variables
    lazy private var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    private var currencies: [Currency] = [] {
        didSet {
            pickerView.reloadAllComponents()
            currencySelectorTextField.isEnabled = currencies.count > 0
        }
    }

    private var rates: [Rate] = [] {
        didSet {
            reloadDataIfPossible()
        }
    }
    private var selectedCurrency: Currency? {
        didSet {
            if let currency = selectedCurrency {
                getRatesFor(currency: currency)
            }
            convertButton.isEnabled = selectedCurrency != nil
        }
    }
    
    private var converterCache: CurrencyConverterCache?
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
        setupConverterCache()
        loadCurrencies()
    }
    
    //MARK: IBAction
    @IBAction func convert() {
        reloadDataIfPossible()
    }
}

//MARK: Private methods
private extension CurrencyConverterViewController {
    
    var isValidInput: Bool {
        guard let text = valueInputTextField.text, Double(text) != nil else { return false }
        return selectedCurrency != nil
    }
    
    func setupGestureRecognizer() {
        //Add a tap recognizer to dismiss the keyboard when the user taps outside
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupConverterCache() {
        converterCache = CurrencyConverterCache()
    }
    
    func loadCurrencies() {
        loadingView.isHidden = false
        converterCache?.loadCurrencies { [weak self] result in
            switch result {
            case let .success(currencies):
                self?.currencies = currencies
            case .failure(_):
                self?.displayErrorMessage(AppStrings.currenciesNotAvailable.localized)
            }
            self?.loadingView.isHidden = true
        }
    }
    
    func getRatesFor(currency: Currency) {
        converterCache?.loadRates { [weak self] result in
            switch result {
            case let .success(rates):
                self?.rates = rates
            case .failure(_):
                self?.displayErrorMessage(AppStrings.realTimeRatesNotAvailable.localized)
            }
        }
    }
    
    func reloadDataIfPossible() {
        guard isValidInput else { return }
        
        exchangeRatesCollectionView.reloadData()
    }
    
    func displayErrorMessage(_ message: String) {
        let dialog = UIAlertController(title: AppStrings.error.localized,
                                       message: message,
                                       preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: AppStrings.ok.localized, style: .cancel, handler: nil))
        present(dialog, animated: true)
    }
}

//MARK: CollectionView Data Source
extension CurrencyConverterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let text = valueInputTextField.text, !text.isEmpty, selectedCurrency != nil else { return 0 }
        
        return rates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ExchangeRateCollectionViewCell.identifier,
            for: indexPath)
        
        guard let exchangeCell =  cell as? ExchangeRateCollectionViewCell,
            let liveRates = converterCache,
            let inputValue = valueInputTextField.text,
            let fromCode = selectedCurrency?.code,
            let value = Double(inputValue) else { return UICollectionViewCell()}
        
        let toCode = rates[indexPath.item].to
        let convertedValue = liveRates.convert(value: value, from: fromCode, to: toCode)
        exchangeCell.configure(code: toCode, value: convertedValue)
        return exchangeCell
    }
}

//MARK: PickerView Delegate
extension CurrencyConverterViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencies[row]
        return currency.displayName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencies[row]
        currencySelectorTextField.text = selectedCurrency?.displayName
    }
}

//MARK: PickerView Data Source
extension CurrencyConverterViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
}

//MARK: UITextField Delegate
extension CurrencyConverterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") as NSString
        let newText = text.replacingCharacters(in: range, with: string)
        if let regex = try? NSRegularExpression(pattern: "^[0-9]*((\\.|,)[0-9]*)?$", options: .caseInsensitive) {
            return regex.numberOfMatches(in: newText, options: .reportProgress, range: NSRange(location: 0, length: (newText as NSString).length)) > 0
        }
        return false
    }
}
