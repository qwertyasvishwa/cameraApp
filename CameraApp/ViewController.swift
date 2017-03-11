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
    var filenameDate = String()
    var filenameTime = String()
    var filename = String()
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
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
        dismiss(animated:true, completion: nil) //5
        
        let imageData = UIImageJPEGRepresentation(chosenImage, 0.7)
        debugPrint(imageData!)
        Alamofire.upload(
            multipartFormData:{ multipartFormData in
                multipartFormData.append(imageData!, withName: "userfile",fileName: self.filename ,mimeType: "image/*")
                multipartFormData.append(self.filename.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "imgdesc")
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
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        let tcalendar = NSCalendar.current
        let tdate = NSDate()
        let day = tcalendar.component(.day, from: tdate as Date)
        let month = tcalendar.component(.month, from: tdate as Date)
        let year = tcalendar.component(.year, from: tdate as Date)
        let hour = tcalendar.component(.hour, from: tdate as Date)
        let minute = tcalendar.component(.minute, from: tdate as Date)
        let seconds = tcalendar.component(.second, from: tdate as Date)
        filenameDate = "\(year)\(month)\(day)"
        filenameTime = "\(hour)\(minute)\(seconds)"
        filename = filenameDate + filenameTime
        print(filename)

    }
    
    
}
