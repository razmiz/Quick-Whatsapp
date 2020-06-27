//
//  ViewController.swift
//  Clipboard Test
//
//  Created by Raz on 06/06/2020.
//  Copyright © 2020 Raz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var openInWhatsappButton: UIButton!
    
    //MARK: Properties
    let activityIndicator = UIActivityIndicatorView()
    
    var countries = [Country](){
        didSet{
            getUserCurrentCountry()
        }
    }
    var currentCountryPosition = 0
    
    var userPhoneNumber = ""
    var telephoneToWhatsapp = "" {
        didSet{
            phoneLabel.text = "+\(telephoneToWhatsapp)"
        }
    }
    var userChosenCountryCode = ""{
        didSet{
            telephoneToWhatsapp = "\(userChosenCountryCode) \(userPhoneNumber)"
        }
    }
    var pickerData: [String] = [String](){
        didSet{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.pickerView.reloadAllComponents()
                self.pickerView.selectRow(self.currentCountryPosition, inComponent: 0, animated: true)
                self.setUserChosenCountryCode(country: (self.countries[self.currentCountryPosition]))
            }
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.setup(view: pickerView)
        getCountriesCodes()
        configurePage()
        setKeyboard()
    }
    
    //MARK: functions
    func getCountriesCodes() {
        DataSource().parseCountriesFromJson { (countries) in
            self.countries = countries
            self.configurePickerData()
        }
    }
    
    func configurePage(){
        configureButton()
        configureTextField()
        configurePickerView()
    }
    
    func configurePickerData() {
        pickerData.removeAll()
        countries.forEach({ (country) in
            pickerData.append(country.name)
        })
    }
    
    private func configureButton(){
        openInWhatsappButton.layer.cornerRadius = 10
        openInWhatsappButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    private func configureTextField(){
        userTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)),
                                for: .editingChanged)
        userTextField.layer.cornerRadius = 5
        userTextField.layer.masksToBounds = true
        userTextField.layer.borderColor = UIColor.darkGray.cgColor
        userTextField.layer.borderWidth = 0.5
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let phoneNumber = getPhoneNumber(stringToGenerate: textField.text!)
        userPhoneNumber = phoneNumber
        telephoneToWhatsapp = "\(userChosenCountryCode) \(userPhoneNumber)"
    }
    
    func setKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getPhoneNumber(stringToGenerate: String) -> String {
        var phoneNumber = stringToGenerate
        if phoneNumber.contains("+") {
            let stringIndext: String.Index = phoneNumber.firstIndex(of: "+")!
            phoneNumber.remove(at: stringIndext)
        }
        
        if phoneNumber.hasPrefix("0"){
            phoneNumber.remove(at: phoneNumber.firstIndex(of: "0")!)
        }
        
        return phoneNumber.replacingOccurrences(of: " ", with: "")
    }
    
    func getUserCurrentCountry(){
        guard let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String else { return }
        for (index,country) in countries.enumerated() {
            if country.code == countryCode {
                currentCountryPosition = index
            }
        }
    }
    
    func setUserChosenCountryCode(country: Country){
        var countryCode = country.dialCode
        if countryCode.contains("+") {
            if let stringIndext = countryCode.firstIndex(of: "+"){
                countryCode.remove(at: stringIndext)
            }
        }
        userChosenCountryCode = countryCode.replacingOccurrences(of: " ", with: "")
    }
    
    //MARK: Actions
    @IBAction func openWhatsappButtonTapped(_ sender: UIButton) {
        let string = telephoneToWhatsapp.replacingOccurrences(of: " ", with: "")
        guard let urlString = URL(string: "https://wa.me/\(string)") else { return }
        
        if UIApplication.shared.canOpenURL(urlString) {
            UIApplication.shared.open(urlString, options: [:], completionHandler: nil)
        }else{
            print("cannot open url: \(urlString)")
        }
    }
}

//MARK: handle PickerView
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = countries[row]
        setUserChosenCountryCode(country: country)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        pickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pickerLabel.textAlignment = .center
        pickerLabel.text = pickerData[row]
        
        pickerView.subviews.forEach {
            $0.frame.size.height = 0.8
            $0.backgroundColor = UIColor.black
        }
        
        return pickerLabel
    }
    
    func configurePickerView(){
        pickerView.layer.cornerRadius = 5
        pickerView.layer.borderColor = UIColor.darkGray.cgColor
        pickerView.layer.borderWidth = 0.5
    }
    
    
}

//MARK: Extensions - limit the number of characters in the textField to 10
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        let currentText = textField.text ?? ""
        //
        //        guard let stringRange = Range(range, in: currentText) else { return false }
        //        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        //        return updatedText.count <= 10
        
        return range.location < 10
    }
}
