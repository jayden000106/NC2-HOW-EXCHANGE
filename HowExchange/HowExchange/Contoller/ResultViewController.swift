//
//  ResultViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/31.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var changeUnitButtonView: UIView!
    @IBOutlet weak var retakePhotoButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        resultView.layer.cornerRadius = 20
        resultView.layer.applyFigmaShadow()
        
        changeUnitButtonView.layer.cornerRadius = 20
        changeUnitButtonView.layer.applyFigmaShadow()
        
        retakePhotoButtonView.layer.cornerRadius = 20
        retakePhotoButtonView.layer.applyFigmaShadow()
    }
}
