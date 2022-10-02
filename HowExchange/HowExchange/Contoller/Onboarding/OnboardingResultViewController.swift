//
//  OnboardingResultViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/09/18.
//

import UIKit

class OnboardingResultViewController: UIViewController {
    
    @IBOutlet private weak var previousButtonView: UIView!
    @IBOutlet private weak var nextButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAppearence()
    }
    
    private func setViewAppearence() {
        setNavigationBar()
        
        previousButtonView.layer.applyFigmaShadow()
        nextButtonView.layer.applyFigmaShadow()
        previousButtonView.layer.cornerRadius = 20
        nextButtonView.layer.cornerRadius = 20
    }
    
    private func setNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction private func previousButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func nextButtonTapped(_ sender: UIButton) {
        let nextStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = nextStoryboard.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(nextViewController, animated: true)
        navigationController?.isNavigationBarHidden = false
    }
}
