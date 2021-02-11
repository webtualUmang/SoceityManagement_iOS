//
//  SupportViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 17/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, BSKeyboardControlsDelegate {
    
    let imagePicker = UIImagePickerController()
    @IBOutlet var txtType : UITextField!
    @IBOutlet var txtDesc : UITextField!
    @IBOutlet var imageView:UIImageView!
    
    var keyboard: BSKeyboardControls!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = "Help / Support"
        keyboard = BSKeyboardControls(fields: [txtType,txtDesc])
        keyboard.delegate = self
        self.imagePicker.delegate = self
    }
    
    @IBAction func SubmitClick(_ sender : UIButton){
        self.AddHelpAndSupport()
    }
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Photo", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Choose from Gallery", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            print("Gallery")
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let deleteAction = UIAlertAction(title: "Take picture using Camera", style: .default, handler:{(alert: UIAlertAction!) -> Void in
            print("Camera")
            
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertView(title: "No Camera", message: "Sorry, this device has no camera", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{(alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        
        
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            self.imageView.image = pickedImage
            self.imageView.clipsToBounds = true
            
        }
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//        if let pickedImage = info[.originalImage] as? UIImage
//        {
//            self.imageView.image = pickedImage
//            self.imageView.clipsToBounds = true
//
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Event -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        self.view.endEditing(true)
    }
    func GetJson(_ param : NSDictionary) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            
            // here "decoded" is of type `AnyObject`, decoded from JSON data
            //            let string = (data: jsonData, encoding: NSUTF8StringEncoding)
            let tempStr = String(data: jsonData, encoding: String.Encoding.utf8)
            return tempStr!
            //Returns "http://nshipster.com/ios9/" URL
        } catch let error as NSError {
            print(error)
        }
        return ""
    }
    func AddHelpAndSupport()
    {
        var titleStr = ""
        
        if let tempStr = self.txtType.text {
            titleStr = tempStr
        }
        if titleStr.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please enter type")
            return
        }
        var descption = ""
        
        if let tempStr = self.txtDesc.text {
            descption = tempStr
        }
        if descption.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please enter descption")
            return
        }
        
        
        //        (Post Data :&page=add&userID=1&societyID=1&catID=1&flatID=1&complaint_type=personal&title=test&description=test&urgent=Yes&uploaded_file)
        
        //        let urlStr = String(format: "%@?view=helpdesk&page=add&userID=%@&societyID=%@&catID=%@&complaint_type=%@&title=%@&description=%@&urgent=%@&uploaded_file=", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,self.catID,self.complainType,titleStr,descption,self.urgent])
        
        let urlStr = String(format: "%@?view=help", arguments: [kMainDomainUrl])
        
       // http://sms.thewebtual.com/mapp/index.php?view=help
        let requestBody:NSDictionary = ["userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"type":titleStr,"message":descption,"view":"help"]
        print(requestBody)
        
        //        userID
        //        societyID
        //        type
        //        message
        //        uploaded_file
        
        let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let imageArray = NSMutableArray()
        
        var imagedata = Data();
        
        if self.imageView.image != nil
        {
            imagedata = self.imageView.image!.jpegData(compressionQuality: 0.5) ?? Data()
//            imagedata = self.imageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
            imageArray.add(imagedata)
        }
        print(imageArray.count)
        self.JsonAdsPostImageRequest(APINAME:requestUrl, ParamDict:requestBody as NSDictionary, ImageData:imageArray,key:"uploaded_file",view:self, completion:
            {
                
                result in
                print(result)
                if result["msgcode"]  as? String ?? "1" == "0"
                {
                    if let message = result.object(forKey: "message") as? String
                    {
                        appDelegate.TNMErrorMessage("", message:message);
                    }
                }
                else
                {
                    if let message = result.object(forKey: "message") as? String
                    {
                        appDelegate.TNMErrorMessage("", message:message);
                        
                    }
                    
                }
        })
                //  print(requestUrl ?? "default value")
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}
