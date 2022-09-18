//
//  OnboardingPicViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/09/18.
//

import UIKit

class OnboardingPicViewController: UIViewController {
    
    @IBOutlet weak var previousButtonView: UIView!
    @IBOutlet weak var nextButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonView()
    }
    
    private func setButtonView() {
        previousButtonView.layer.applyFigmaShadow()
        nextButtonView.layer.applyFigmaShadow()
    }
    
}
