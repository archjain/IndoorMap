//
//  CameraViewController.swift
//  IndoorMap
//
//  Created by Archit Jain on 10/26/17.
//  Copyright © 2017 Estimote, Inc. All rights reserved.
//

import UIKit
//import Alamofire

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var pickedImaged: UIImageView!
    
    @IBOutlet weak var xcord: UITextField!
    @IBOutlet weak var ycord: UITextField!
    @IBOutlet weak var stackNo: UITextField!
    @IBOutlet weak var itemNo: UITextField!
    @IBOutlet weak var poNo: UITextField!
    
    var prevVC: BarcodeViewController!
    var xcordPassed = ""
    var ycordPassed = ""
    var barcodeRead = ""
    
    // view load
    override func viewDidLoad() {
        super.viewDidLoad()
        if(prevVC != nil){
            prevVC.dismiss(animated: false, completion: nil)
        }
        //coordinates taken from view controller
        xcord.text = xcordPassed
        ycord.text = ycordPassed
        if barcodeRead.count==18 {
            stackNo.text =  barcodeRead
        }
        else if barcodeRead.count==15 {
            itemNo.text = barcodeRead
        }
        else{
        
        }
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // to pick from library
    @IBAction func libraryAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    //opens the camera
    @IBAction func cameraAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    //sends image to web service
    @IBAction func saveAction(_ sender: Any) {
        if pickedImaged.image != nil
        {
            let imageData = UIImageJPEGRepresentation(pickedImaged.image!, 0.6)
            let compressedJpegImage = UIImage(data:imageData!)
        
            //  UIImageWriteToSavedPhotosAlbum(compressedJpegImage!, nil, nil, nil)
            let resturl = "http://10.164.11.67/ICS/PW/UploadImage"
            let strBase64 = imageData?.base64EncodedString(options: .endLineWithLineFeed)
            //print(strBase64)
            let xcordVal = xcord.text
            let ycordVal = ycord.text
            let stackVal = stackNo.text
            let itemVal = itemNo.text
            let poVal = poNo.text
            
            var request = NSMutableURLRequest(url: NSURL(string: resturl)! as URL)
            request.httpMethod = "POST"
         
            var bodyData="imageString="+strBase64!
            bodyData+="&xcord="+xcordVal!
            bodyData+="&ycord="+ycordVal!
            bodyData+="&stackNo="+stackVal!
            bodyData+="&itemNo="+itemVal!
            bodyData+="&poNo="+poVal!
            
            request.httpBody = bodyData.data(using: String.Encoding.utf8);

        
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main)
            {
                (response, data, error) in
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
                if NSString(data: data!, encoding: String.Encoding.utf8.rawValue) == "1"{
                    self.saveNotice(title: "Successful", message: "Image has been saved successfully")
                }else if NSString(data: data!, encoding: String.Encoding.utf8.rawValue) == "-1"{
                    self.saveNotice(title: "Error", message: "Stack Number can't be empty")
                }
                else if NSString(data: data!, encoding: String.Encoding.utf8.rawValue) == "-2"{
                    self.saveNotice(title: "Error", message: "Stack Id Not Found")
                }
                else if NSString(data: data!, encoding: String.Encoding.utf8.rawValue) == "-3"{
                    self.saveNotice(title: "Error", message: "Item Id not found")
                }
                else{
                     self.saveNotice(title: "Error", message: "Something went wrong with the request")
                }
                //print(response.)
            }
        
        }else{
            self.saveNotice(title: "Error", message: "Picture has to be taken before saving data")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo : [NSObject : AnyObject]!) {
        pickedImaged.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // image passed successfully. to be used after handling response
    func saveNotice(title:String, message: String){
        let alertControl = UIAlertController(title: title, message:message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .default, handler:nil)
        alertControl.addAction(defaultAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    

}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
