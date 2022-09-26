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
        setViewAppearence()
    }
    
    private func setViewAppearence() {
        setNavigationBar()
        
        nextButtonView.layer.applyFigmaShadow()
        nextButtonView.layer.cornerRadius = 20
    }
    
    private func setNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingPicViewController") else { return }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
