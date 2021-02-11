//
//  AddLostFoundVC.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 24/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class AddLostFoundVC: UIViewController,TNMKeyboardControlsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate
{
    @IBOutlet var btnLost: UIButton!
    @IBOutlet var btnFound: UIButton!
    @IBOutlet var txtName:UITextField!
    @IBOutlet var txtMobileNumber:UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textviewDesc: UITextView!
    var keyboard: TNMKeyboardControls!
    let imagePicker = UIImagePickerController()
    var screen_name = ""
    var islost = "1"
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.viewSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.title = "Add Lost & Found"
          self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action:nil)
      
    }
    @objc func dismissView()
       {
           self.dismiss(animated: true)
           {
               
           }
       }
    func viewSetup()
    {
        imagePicker.delegate = self
        
        textviewDesc.text = "Item Description"
        textviewDesc.textColor = UIColor.lightGray
        textviewDesc.autocorrectionType = .no
        textviewDesc.delegate = self
        
        let rightbtn = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(self.PostComplain))
        
        self.navigationItem.rightBarButtonItem = rightbtn
        self.keyboard = TNMKeyboardControls(fields: [txtName,textviewDesc,txtMobileNumber])
              
              keyboard.delegate = self
              
        btnLost.set(image: UIImage(named: "check_blue"), title: " Lost", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        btnFound.set(image: UIImage(named: "un_check"), title: " Found", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
    }
    @objc func PostComplain()
       {
          let mobile = self.txtMobileNumber.text ?? ""

            if self.txtName.text ?? "" == ""
           {
               appDelegate.TNMErrorMessage("", message:"Please enter name")
               return
           }
           else if self.textviewDesc.text ?? "" == ""
           {
               appDelegate.TNMErrorMessage("", message:"Please enter description")
               return
           }
           else if self.txtMobileNumber.text ?? "" == ""
           {
               appDelegate.TNMErrorMessage("", message:"Please enter mobile number")
               return
           }
            else if mobile.count < 8
            {
                appDelegate.TNMErrorMessage("", message:"Please enter valid mobile number")
                return
            }
           
        self.AddLost_found()
         //  self.AddComplain()
       }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton)
       {
           
           
           let optionMenu = UIAlertController(title: nil, message: "Choose Photo", preferredStyle: .actionSheet)
           
           let saveAction = UIAlertAction(title: "Choose from Gallery", style: .default, handler: {(alert: UIAlertAction!) -> Void in
               print("Gallery")
               
               self.imagePicker.allowsEditing = false
               self.imagePicker.sourceType = .photoLibrary
               self.present(self.imagePicker, animated: true, completion: nil)
           })
           
           let deleteAction = UIAlertAction(title: "Take picture using Camera", style: .default, handler:{(alert: UIAlertAction!) -> Void in
               print("Camera")
               if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                   self.imagePicker.allowsEditing = false
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
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
                           
            self.dismiss(animated: true, completion: nil);
            
        }
//        dismiss(animated: true, completion: nil)
    }
    
//       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//           if let pickedImage = info[.originalImage] as? UIImage
//           {
//               imageView.contentMode = .scaleAspectFit
//               imageView.image = pickedImage
//
//               self.dismiss(animated: true, completion: nil);
//           }
//
//       }
    
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
    @IBAction func BtnFilterSelect(_ sender:UIButton)
       {
           if(sender.tag == 0){
            self.btnLost.set(image: UIImage(named: "check_blue"), title: " Lost", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
               
               self.btnFound.set(image: UIImage(named: "un_check"), title: " Found", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.islost = "1"
           }
           else
           {
            self.btnLost.set(image: UIImage(named: "un_check"), title: " Lost", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
               
            self.btnFound.set(image: UIImage(named: "check_blue"), title: " Found", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.islost = "0"

           }
       }
    //MARK:- TextView -
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: - Keyboard Event -
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        keyboard.activeField = textField
    }
    func keyboardControls(_ keyboardControls: TNMKeyboardControls!, selectedField field: UIView!, in direction: TNMKeyboardControlsDirection) {
        //        self.tableview.scrollRectToVisible(field.frame, animated: true)
    }
    func keyboardControlsDonePressed(_ keyboardControls: TNMKeyboardControls!) {
        view.endEditing(true)
    }
   
    func AddLost_found()
       {
           
           
           
           let urlStr = String(format: "%@", arguments: [kMainDomainUrl])
           // http://sms.thewebtual.com/mapp/index.php?view=profile&page=user_update
           
      //   view:lostfound
        // page:add
        // societyID:64
       //  userID:2972
       //  itemname:Key
        // description:My Key is lost
        // islost:1
           
        let requestBody:NSDictionary = ["view":"lostfound","page":"add","userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"itemname":self.txtName.text ?? "","description":self.textviewDesc.text ?? "","mobile":self.txtMobileNumber.text ?? "","islost":self.islost]
           
           let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
           let imageArray = NSMutableArray()
           
           var imagedata = Data();
           
           if self.imageView.image != nil
           {
            imagedata = self.imageView.image!.jpegData(compressionQuality: 0.5) ?? Data()
//            imagedata = self.imageView.image?.UIImageJPEGRepresentation(compressionQuality: 0.5) ?? Data()
               imageArray.add(imagedata)
           }
           
           self.JsonAdsPostImageRequest(APINAME:requestUrl, ParamDict:requestBody as NSDictionary, ImageData:imageArray,key:"itemphoto",view:self, completion:
               {
                   
                   result in
                   print(result)
                   if result["msgcode"]  as? String ?? "1" == "0"
                   {
                       if let message = result.object(forKey: "message") as? String
                       {
                           appDelegate.TNMErrorMessage("", message:message)
                       }
                    if self.islost == "1"
                    {
                        NotificationCenter.default.post(name:NSNotification.Name("lost_list"), object: nil)
                    }
                    else
                    {
                        NotificationCenter.default.post(name:NSNotification.Name("found_list"), object: nil)
                    }
                    
                   }
                   else
                   {
                       if let message = result.object(forKey: "message") as? String
                       {
                           appDelegate.TNMErrorMessage("", message:message)
                           
                       }
                   }
                   
           })
           
           
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
