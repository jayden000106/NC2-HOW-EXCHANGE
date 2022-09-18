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
        
        navigationController?.isNavigationBarHidden = true;
        
        setButtonView()
    }
    
    private func setButtonView() {
        previousButtonView.layer.applyFigmaShadow()
        nextButtonView.layer.applyFigmaShadow()
        previousButtonView.layer.cornerRadius = 20
        nextButtonView.layer.cornerRadius = 20
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let nextViewController = storyboard?.instantiateViewController(withIdentifier: "OnboardingResultViewController") else { return }
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
