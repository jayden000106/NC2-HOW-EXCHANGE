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
    var resultUnit = ResultUnit(KRW: 0.0573, USD: 0.0000426, JPY: 0.00591, EUR: 0.0000427)
    
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
                    for string in recognizedStrings {
                        if let double = Double(string) {
                            var tmp = double
                            tmp *= 1000
                            self.recognizedDoubles.append(tmp)
                        }
                    }
                    
                    if let data = UserDefaults.standard.data(forKey: "unit") {
                        let decoder = JSONDecoder()
                        do {
                            let unit = try decoder.decode(ParseResult.self, from: data)
                            self.resultUnit = unit.rates
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    for double in self.recognizedDoubles {
                        self.calculatedDoubles.append(self.resultUnit.KRW * double)
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
