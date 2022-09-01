//
//  CalculateViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/09/01.
//

import UIKit
import Vision

class CalculateViewController: UIViewController {
    var image: UIImage!
    var recognizedDoubles: [Double] = []
    var calculatedDoubles: [Double] = []
    var resultUnit = ResultUnit(KRW: 0.0573, USD: 0.0000426, JPY: 0.00591, EUR: 0.0000427)
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var resultTableHeaderView: UIView!
    @IBOutlet weak var changeUnitButtonView: UIView!
    @IBOutlet weak var changePhotoButtonView: UIView!
    @IBOutlet weak var resultTableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        resultTableView.layer.cornerRadius = 20
        resultTableView.layer.applyFigmaShadow()
        resultTableHeaderView.layer.cornerRadius = 20
        
        changeUnitButtonView.layer.cornerRadius = 20
        changeUnitButtonView.layer.applyFigmaShadow()
        
        changePhotoButtonView.layer.cornerRadius = 20
        changePhotoButtonView.layer.applyFigmaShadow()
        
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
                    
                    self.resultTableView.delegate = self.self
                    self.resultTableView.dataSource = self.self
                    self.resultTableView.showsVerticalScrollIndicator = false
                    self.resultTableView.separatorStyle = .none
                    if self.calculatedDoubles.count != 0 {
                        self.resultTableView.heightAnchor.constraint(equalToConstant: CGFloat(self.recognizedDoubles.count * 40 + 20)).isActive = true
                        self.scrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: self.scrollView.contentSize.height + CGFloat(self.recognizedDoubles.count * 40 + 20 - 400)).isActive = true
                    }
                    self.resultTableView.isUserInteractionEnabled = false
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
    
    @IBAction func changeUnitButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func changeMenuButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CalculateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recognizedDoubles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        
        cell.fromLabel.text = String(recognizedDoubles[indexPath.row])
        cell.toLabel.text = String(calculatedDoubles[indexPath.row])
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
