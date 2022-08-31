//
//  ResultViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/31.
//

import UIKit
import Vision

class ResultViewController: UIViewController {
    var image: UIImage!
    var recognizedDoubles: [Double] = []
    var calculatedDoubles: [Double] = []
    
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
        
        if let cgImage = image.cgImage {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                DispatchQueue.main.async {
                    print(recognizedStrings)
                    
                    for string in recognizedStrings {
                        if let double = Double(string) {
                            self.recognizedDoubles.append(double)
                        }
                    }
                    
                    print(self.recognizedDoubles)
                    
                    for price in self.recognizedDoubles {
                        var number = price
                        if number < 1000 {
                            number *= 1000
                        }
                        self.calculatedDoubles.append(number / 20)
                    }
                    
                    print(self.calculatedDoubles)
                }
            }
            
            recognizeTextRequest.recognitionLevel = .accurate
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try requestHandler.perform([recognizeTextRequest])
                } catch {
                    print(error)
                }
            }
        }
    }
}
