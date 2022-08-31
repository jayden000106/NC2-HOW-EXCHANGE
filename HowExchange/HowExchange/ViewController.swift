//
//  ViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/29.
//

import UIKit

class ViewController: UIViewController {
    let selectableLine = 1
    let caseList = MonetaryUnit.allCases.map({ unit in
        unit.rawValue
    })
    
//    var resultUnit: ResultUnit = ResultUnit(KRW: 0.0573, USD: 0.0000426, JPY: 0.00591, EUR: 0.0000427)
    
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var takeButtonView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exchangeView.layer.cornerRadius = 20
        exchangeView.layer.applyFigmaShadow()
        
        takeButtonView.layer.cornerRadius = 20
        takeButtonView.layer.applyFigmaShadow()
        selectButtonView.layer.cornerRadius = 20
        selectButtonView.layer.applyFigmaShadow()
        
        let fromPickerView = UIPickerView()
        fromPickerView.tag = 1
        fromPickerView.delegate = self
        fromTextField.inputView = fromPickerView
        
        let toPickerView = UIPickerView()
        toPickerView.tag = 2
        toPickerView.delegate = self
        toTextField.inputView = toPickerView
        
//        fetchUnit()
    }
    
    func fetchUnit() {
        let semaphore = DispatchSemaphore(value: 0)
        
        let url = "https://api.apilayer.com/exchangerates_data/latest?symbols=KRW,USD,JPY,EUR&base=VND"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(Storage().apiKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            UserDefaults.standard.set(data, forKey: "unit")
            
//            let decoder = JSONDecoder()
//            do {
//                let unit = try decoder.decode(ParseResult.self, from: data)
//                self.resultUnit = unit.rates
//
//            } catch {
//                print(error.localizedDescription)
//            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return selectableLine
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return caseList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return caseList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            fromTextField.text = caseList[row]
            fromTextField.resignFirstResponder()
        } else {
            toTextField.text = caseList[row]
            toTextField.resignFirstResponder()
        }
    }
}
