//
//  OnboardingExchangeViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/09/18.
//

import UIKit

class OnboardingExchangeViewController: UIViewController {
    
    @IBOutlet weak var nextButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonView()
    }
    
    private func setButtonView() {
        nextButtonView.layer.applyFigmaShadow()
    }
    
}
