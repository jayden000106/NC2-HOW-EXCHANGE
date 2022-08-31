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
    
    @IBOutlet weak var changeUnitButtonView: UIView!
    @IBOutlet weak var retakePhotoButtonView: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var resultTableViewHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        resultTableView.layer.cornerRadius = 20
        resultTableView.layer.applyFigmaShadow()
        resultTableViewHeader.layer.cornerRadius = 20
        
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
                    
                    self.resultTableView.delegate = self.self
                    self.resultTableView.dataSource = self.self
                    self.resultTableView.updateConstraints()
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

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recognizedDoubles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        
        cell.fromLabel.text = String(recognizedDoubles[indexPath.row])
        cell.toLabel.text = String(calculatedDoubles[indexPath.row])
        
        return cell
    }
}

