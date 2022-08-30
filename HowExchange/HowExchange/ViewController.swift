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
    
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var takeButtonView: UIView!
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exchangeView.layer.cornerRadius = 20
        exchangeView.layer.applyFigmaShadow()
        
        takeButtonView.layer.cornerRadius = 20
        takeButtonView.layer.applyFigmaShadow()
        
        let fromPickerView = UIPickerView()
        fromPickerView.tag = 1
        fromPickerView.delegate = self
        fromTextField.inputView = fromPickerView
        
        let toPickerView = UIPickerView()
        toPickerView.tag = 2
        toPickerView.delegate = self
        toTextField.inputView = toPickerView
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
