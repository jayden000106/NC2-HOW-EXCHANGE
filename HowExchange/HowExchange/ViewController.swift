//
//  ViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/29.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var takeButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exchangeView.layer.cornerRadius = 20
        exchangeView.layer.applyFigmaShadow()
        
        takeButtonView.layer.cornerRadius = 20
        takeButtonView.layer.applyFigmaShadow()
    }
}
