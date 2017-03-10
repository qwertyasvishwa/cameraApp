//
//  ViewController.swift
//  CameraApp
//
//  Created by Vishwa Raj on 03/02/17.
//  Copyright © 2017 Vishwa Raj. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var  chosenImage = UIImage()
    let picker = UIImagePickerController()
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .full   Screen
            present(picker,animated: true,completion: nil)
        }
        else {
            noCamera()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        myImageView.contentMode = .scaleAspectFit //3
        chosenImage.accessibilityValue = "me"
        myImageView.image = chosenImage //4
        
        dismiss(animated:true, completion: nil) //5
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnAction(_ sender: UIButton) {
        
        let imageData = UIImageJPEGRepresentation(myImageView.image!, 0.9)
        debugPrint(imageData!)
        Alamofire.upload(
            multipartFormData:{ multipartFormData in
                multipartFormData.append(imageData!, withName: "userfile",fileName: "photo1.jpeg",mimeType: "image/*")
                multipartFormData.append("Hello".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "imgdesc")
        }, usingThreshold:UInt64.init(),
                         to:"http://vishwaraj.xyz/upload/store_image.php",
                         method:.post,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    debugPrint(upload)
                                    debugPrint(response)
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        
        
    }
    
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

