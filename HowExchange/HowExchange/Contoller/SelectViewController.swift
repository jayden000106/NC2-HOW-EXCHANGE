//
//  SelectViewController.swift
//  HowExchange
//
//  Created by 정지혁 on 2022/08/30.
//

import UIKit
import PhotosUI

class SelectViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAlbumPermission()
        
        confirmButton.isEnabled = false
        
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
//
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        self.present(picker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let image = imageView.image else { return }
        
        let destination = segue.destination as! CalculateViewController
        destination.image = image
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func checkAlbumPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: { status in
            switch status {
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            case .restricted, .notDetermined:
                print("not selected")
            default:
                break
            }
        })
    }
}

extension SelectViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.confirmButton.isEnabled = true
                    }
                }
            })
        }
    }
}
