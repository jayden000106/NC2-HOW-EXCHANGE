//
//  ViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/29.
//

import UIKit

class ViewController: UIViewController {
    private let selectableLine = 1
    private let moneyUnitCase = MonetaryUnit.allCases.map({ unit in
        unit.rawValue
    })
    
    @IBOutlet weak private var exchangeView: UIView!
    @IBOutlet weak private var takeButtonView: UIView!
    @IBOutlet weak private var selectButtonView: UIView!
    
    @IBOutlet weak private var fromTextField: UITextField!
    @IBOutlet weak private var toTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAppearence()
        setPickerView()
        fetchUnit()
    }
    
    private func setViewAppearence() {
        setNavigationBar()
        
        exchangeView.layer.cornerRadius = 20
        exchangeView.layer.applyFigmaShadow()
        
        takeButtonView.layer.cornerRadius = 20
        takeButtonView.layer.applyFigmaShadow()
        selectButtonView.layer.cornerRadius = 20
        selectButtonView.layer.applyFigmaShadow()
    }
    
    private func setNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    // Picker마다 태그를 설정해서 Delegate에서 선택한 TextField 변경
    // https://stackoverflow.com/questions/27642164/how-to-use-two-uipickerviews-in-one-view-controller
    private func setPickerView() {
        let fromPickerView = UIPickerView()
        fromPickerView.tag = 1
        fromPickerView.delegate = self
        fromTextField.inputView = fromPickerView
        
        let toPickerView = UIPickerView()
        toPickerView.tag = 2
        toPickerView.delegate = self
        toTextField.inputView = toPickerView
    }
    
    private func fetchUnit() {
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
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        if fromTextField.text == toTextField.text {
            let sameUnitAlert = UIAlertController(title: "같은 화폐 단위 선택", message: "같은 화폐 단위를 선택하셨습니다,\n다른 화폐 단위를 선택해주세요!", preferredStyle: UIAlertController.Style.alert)
            let confirmAlertAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            sameUnitAlert.addAction(confirmAlertAction)
            present(sameUnitAlert, animated: true, completion: nil)
        } else {
            UserDefaults.standard.set(fromTextField.text, forKey: "from")
            UserDefaults.standard.set(toTextField.text, forKey: "to")
            
            guard let selectViewController = storyboard?.instantiateViewController(withIdentifier: "SelectViewController") else { return }
            navigationController?.pushViewController(selectViewController, animated: true)
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return selectableLine
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moneyUnitCase.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return moneyUnitCase[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            fromTextField.text = moneyUnitCase[row]
            fromTextField.resignFirstResponder()
        } else {
            toTextField.text = moneyUnitCase[row]
            toTextField.resignFirstResponder()
        }
    }
}
