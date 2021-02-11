//
//  PendingTransactionViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 10/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class PendingHelpViewController: UIViewController, BSKeyboardControlsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var BtnPhoto: UIButton!
    @IBOutlet var txtType: UITextField!
    @IBOutlet var txtQuery: UITextField!
    
    var invoiceID: String = ""
    var keyboard: BSKeyboardControls!
     var imagePicker = UIImagePickerController()
    var strfileUrl: URL?
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        keyboard = BSKeyboardControls(fields: [txtType,txtQuery])
        keyboard.delegate = self
        
        DispatchQueue.main.async{
            self.imagePicker.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegate.SetNavigationBar(self.navigationController!)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Help / Support"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func BtnSumbitClick(_ sender: AnyObject){
        SetSumbit(appDelegate.EmailID)
    }
    
    @IBAction func BtnAttacehmentClick(_ sender: AnyObject){
        
        let refreshAlert = UIAlertController(title: "Select File", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Take pictrure using Camera", style: .default, handler: { (action: UIAlertAction!) in
            
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert = UIAlertView(title: "No Camera", message: "Sorry, this device has no camera", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action: UIAlertAction!) in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        self.navigationController?.present(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            
            self.imageView.image = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//
//        if let pickedImage = info[.originalImage] as? UIImage
//               {
//
//                self.imageView.image = pickedImage
//
//
//               }
//
//               dismiss(animated: true, completion: nil)
//    }
  
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    //MARK:- SetEmailInvoice -
    func SetSumbit(_ email : String)
    {
   
        
        let urlStr = String(format: "%@?view=income_invoice&page=mail&userID=%@&societyID=%@&email=%@&invoiceID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,email, invoiceID])
        
        print(urlStr)
    //    appDelegate.TNMErrorMessage("", message: messageStr)

        
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true
            {
                print(data)
                
                if let ResultData = data as? NSDictionary
                {
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            print(ResultData)
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                        }
                        else{
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                        }
                    }
                }
                
                
            }else
            {
                if let json = data as? NSDictionary
                {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        view.endEditing(true)
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
