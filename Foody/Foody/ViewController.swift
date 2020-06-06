//
//  ViewController.swift
//  Foody
//
//  Created by Bhavik Kothari on 2020-06-05.
//  Copyright © 2020 Bhavik Kothari. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imageView.image = userPickedimage
        
            guard let regImage = CIImage(image: userPickedimage) else{
                fatalError()
            }
            detect(image: regImage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError()
            }
            print(results)
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do{
        try handler.perform([request])
        }
        catch{
            print(error)
        }
    }

    
    @IBAction func cameraPressed(_ sender: Any) {
         present(imagePicker, animated: true, completion: nil)
    }
    
}

