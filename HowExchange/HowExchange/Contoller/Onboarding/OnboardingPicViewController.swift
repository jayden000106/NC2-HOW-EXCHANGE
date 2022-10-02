//
//  OnboardingPicViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/09/18.
//

import UIKit

class OnboardingPicViewController: UIViewController {
    
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
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingResultViewController") else { return }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
