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
    
    private var recognizedDoubles: [Double] = []
    private var calculatedDoubles: [Double] = []
    private var resultUnit = ResultUnit(KRW: 0.0573, USD: 0.0000426, JPY: 0.00591, EUR: 0.0000427)
    
    @IBOutlet weak private var scrollView: UIScrollView!
    @IBOutlet weak private var stackView: UIStackView!
    
    @IBOutlet weak private var buttonStackView: UIStackView!
    @IBOutlet weak private var resultTableView: UITableView!
    @IBOutlet weak private var resultTableHeaderView: UIView!
    @IBOutlet weak private var changeUnitButtonView: UIView!
    @IBOutlet weak private var changePhotoButtonView: UIView!
    @IBOutlet weak private var resultTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak private var progressView: UIProgressView!
    @IBOutlet weak private var progressContainerView: UIView!
    
    @IBOutlet weak private var fromLabel: UILabel!
    @IBOutlet weak private var toLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewAppearence()
        excuteTextRecognize()
    }
    
    private func setViewAppearence() {
        setNavigationBar()
        
        resultTableView.layer.cornerRadius = 20
        resultTableView.layer.applyFigmaShadow()
        resultTableHeaderView.layer.cornerRadius = 20
        
        changeUnitButtonView.layer.cornerRadius = 20
        changeUnitButtonView.layer.applyFigmaShadow()
        
        changePhotoButtonView.layer.cornerRadius = 20
        changePhotoButtonView.layer.applyFigmaShadow()
        
        fromLabel.text = UserDefaults.standard.string(forKey: "from")
        toLabel.text = UserDefaults.standard.string(forKey: "to")
    }
    
    private func setNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    // Vison의 텍스트 인식 기능 사용
    // https://medium.com/@yossabourne/how-to-perform-text-recognition-in-swift-using-vision-f0dc4029cf37
    private func excuteTextRecognize() {
        if let cgImage = image.cgImage {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeTextRequest = VNRecognizeTextRequest { (request, error) in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                print(recognizedStrings)
                
                DispatchQueue.main.async {
                    for string in recognizedStrings {
                        let trimmedString = self.trimString(string)
                        print(trimmedString)
                        if let double = Double(trimmedString) {
                            var tmp = double
                            if tmp < 1000 {
                                tmp *= 1000
                            }
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
                    if self.calculatedDoubles.count > 4 {
                        print(self.calculatedDoubles)
                        self.resultTableView.heightAnchor.constraint(equalToConstant: CGFloat(self.recognizedDoubles.count * 40 + 20)).isActive = true
                        self.scrollView.contentLayoutGuide.heightAnchor.constraint(equalToConstant: self.scrollView.contentSize.height + CGFloat(self.recognizedDoubles.count * 40 + 20 - 400)).isActive = true
                    }
                    self.resultTableView.isUserInteractionEnabled = false
                }
            }
            
            recognizeTextRequest.recognitionLevel = .accurate
            recognizeTextRequest.progressHandler = { (request, double, error) in
                print("progress : \(double)")
                DispatchQueue.main.async {
                    self.progressView.progress = Float(double)
                    if double >= 1 {
                        self.progressContainerView.layer.opacity = 0
                    }
                }
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try requestHandler.perform([recognizeTextRequest])
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func trimString(_ string: String) -> String {
        var trimmed = string
        if string.contains("vnd") || string.contains("VND") {
            let range = string.index(string.startIndex, offsetBy: string.count - 4)
            trimmed = String(trimmed[..<range])
        }
        return trimmed
    }
    
    @IBAction private func changeUnitButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func changeMenuButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension CalculateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recognizedDoubles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as! ResultTableViewCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        cell.fromLabel.text = numberFormatter.string(for: recognizedDoubles[indexPath.row])
        cell.toLabel.text = numberFormatter.string(for: calculatedDoubles[indexPath.row])
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
