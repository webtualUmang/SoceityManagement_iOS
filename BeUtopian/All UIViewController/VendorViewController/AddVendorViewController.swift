//
//  AddVendorViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 06/06/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class AddVendorViewController: UIViewController, LBZSpinnerDelegate, BSKeyboardControlsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    var resultData: NSDictionary?
    
    @IBOutlet var spinnerBlock : LBZSpinner!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var hederView: UIView!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPhoneNo: UITextField!
    @IBOutlet var txtCompanyName: UITextField!
    @IBOutlet var txtServiceDisc: UITextField!
    @IBOutlet var txtEmailId: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtPinCode: UITextField!
    
    var strRate: String = ""
    var filePath: String = ""
    var imgURL: URL?
    
    var keyboard: BSKeyboardControls!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: Selector(("onKeyboardShow:")), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: Selector("onKeyboardHide:"), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        keyboard = BSKeyboardControls(fields: [self.txtName,self.txtPhoneNo,self.txtCompanyName,self.txtServiceDisc,self.txtEmailId,self.txtAddress,self.txtPinCode])
        keyboard.delegate = self
        
        imagePicker.delegate = self

        tableview.tableHeaderView = hederView
        
        var listResult : [String] = []
        
        let blockResult = ["Good", "Excellent", "Not Good"]
        
        for data in blockResult {
            listResult.append(data)
        }
        spinnerBlock.updateList(listResult)
        spinnerBlock.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
        if let data = resultData {
            if let tempStr = data.object(forKey: "name") as? String {
                if tempStr.isEmpty == false {
                    lblTitle.text = tempStr
                    self.navigationItem.title = String(format: "Add Vendor - %@", tempStr)
                }
                
            }
            
        }
        let right = UIBarButtonItem(title: "POST", style: .plain, target: self, action: Selector("AddVendor"))
        self.navigationItem.rightBarButtonItem = right
    }
    
    /*func AddVendor(){
        
        var catagoryId = "0"
        if let data = resultData {
            if let tempStr = data.objectForKey("catID") as? String {
                catagoryId = tempStr
                
            }
            
        }
        
        //(POST data:page=add&userID=1&societyID=1&catID=1&name=ABC&phone=9157195123&email=abc@gmail.com&address=Nikol,Ahmedabad&service_title=Enginner&service_detail=Computer Engg&rate=1/2/3&vendor_image)
        
      
        
        
        let urlStr = String(format: "%@?view=vendor&page=add&userID=%@&societyID=%@&catID=%@&name=%@&phone=%@&email=%@&address=%@&service_title=%@&service_detail=%@&rate=%@&vendor_image=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,catagoryId,txtName.text!, txtPhoneNo.text!, txtEmailId.text!, txtAddress.text!, lblTitle.text!, txtServiceDisc.text!, strRate, ""])

        print(urlStr)
        
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.objectForKey("msgcode") as? String {
                        if msgCode == "0" {
                            if let messageStr = ResultData.objectForKey(kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                        }
                        else{
                            if let messageStr = ResultData.objectForKey(kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                        }
                    }
                }
                
                
                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.objectForKey(kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
        
    } */
    
    func AddVendor(){
        
        /*
        var catagoryId = "0"
        if let data = resultData {
            if let tempStr = data.object(forKey: "catID") as? String {
                catagoryId = tempStr
                
            }
            
        }
        
        let urlStr = String(format: "%@?view=vendor", arguments: [kMainDomainUrl])
        
        getImage()
        
        DispatchQueue.main.async {
            appDelegate.ShowProgress(self)
        }
        
        let fileUrl = URL(fileURLWithPath: filePath)
        let imageData = self.filePath.isEmpty == true ? "" : Upload(fileUrl: fileUrl)
        print(imageData)
        
        
        do {
            let opt = try HTTP.POST(urlStr, parameters: ["page":"add","userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"catID":catagoryId,"name":txtName.text!,"phone":txtPhoneNo.text!,"email":txtEmailId.text!,"address":txtAddress.text!,"service_title":lblTitle.text!, "service_detail": txtServiceDisc.text!, "rate":strRate, "vendor_image":imageData])
            opt.start { response in
                //do things...
                
                print("opt finished: \(response.description)")
                
                if(response.statusCode == 200){
                    
                    if let json: AnyObject? = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    {
                        if let ResultData = json as? NSDictionary{
                            if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                                if msgCode == "0" {
                                    
                                    isDataAddedToSociety = true
                                    
                                    if self.filePath.isEmpty == false {
                                        do {
                                            try FileManager.default.removeItem(atPath: self.filePath)
                                        } catch {}
                                        self.filePath = ""
                                    }
                                    
                                    
                                    self.imgURL = nil
                                    if let message = ResultData.object(forKey: "message") as? String {
                                        appDelegate.TNMErrorMessage("", message: message)
                                    }
                                    
                                }
                            }
                            else{
                                self.imgURL = nil
                                if let messageStr = json!.object(forKey: kMessage) as? String {
                                    appDelegate.TNMErrorMessage("", message: messageStr)
                                }
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    appDelegate.HideProgress()
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            
            DispatchQueue.main.async {
                appDelegate.HideProgress()
            }
            
        }
        */
    }
    
    func saveImageDocumentDirectory(_ selectedImage : UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("test.jpeg")
        //let image = UIImage(named: "apple.jpg")
        print(paths)
        //let imageData = UIImagePNGRepresentation(selectedImage)
        
        let imageData = selectedImage.jpegData(compressionQuality: 0.1)
//        let imageData = selectedImage.jpegData(compressionQuality: 0.1)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImage(){
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("test.jpeg")
        
        if fileManager.fileExists(atPath: imagePAth){
            filePath = imagePAth
            //            self.imageView.image = UIImage(contentsOfFile: imagePAth)
            
        }else{
            print("No Image")
            filePath = ""
        }
    }

    
    //MARK: - Dropdown
    
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String) {
        var spinnerName = ""
        if spinner == spinnerBlock { spinnerName = "customer" }
        
        if(index == 0){
            strRate = "1"
        }
        else if(index == 1){
            strRate = "2"
        }
        else if(index == 2){
            strRate = "3"
        }
        
        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
    }
    func spinnerOpenClick() {
        print("open Click")
    }

    @IBAction func BtnSelectPhotoClick(_ sender: AnyObject){
        
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
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            saveImageDocumentDirectory(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
//    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
//               {
//                   //profileImage.contentMode = .ScaleAspectFit
//                   //profileImage.image = pickedImage
//
//                   // imageView.image = pickedImage
//
//                   /* let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
//                    let imageName         = imageUrl.lastPathComponent
//                    let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
//                    let photoURL          = NSURL(fileURLWithPath: documentDirectory)
//                    let localPath         = photoURL.URLByAppendingPathComponent(imageName!)
//                    let image             = info[UIImagePickerControllerOriginalImage]as! UIImage
//                    let data              = UIImagePNGRepresentation(image)
//
//                    data!.writeToFile(localPath.absoluteString, atomically: true)
//
//                    self.dismissViewControllerAnimated(true, completion: nil);*/
//
//                   saveImageDocumentDirectory(pickedImage)
//               }
//
//               dismiss(animated: true, completion: nil)
//    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Keyboard Event -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        self.tableview.scrollRectToVisible(field.frame, animated: true)
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        view.endEditing(true)
    }
    func onKeyboardHide(_ notification: Notification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let duration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        UIView.animate(withDuration: duration, animations: { () -> Void in
            let edgeInsets  = UIEdgeInsets.zero;
            self.tableview.contentInset = edgeInsets
            self.tableview.scrollIndicatorInsets = edgeInsets
        })
    }
    func onKeyboardShow(_ notification: Notification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let kbMain  = (userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        let kbSize = kbMain?.size
        let duration  = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double;
        UIView.animate(withDuration: duration, animations: { () -> Void in
            let edgeInsets  = UIEdgeInsets(top: 0, left: 0, bottom: (kbSize?.height)!, right: 0)
            self.tableview.contentInset = edgeInsets
            self.tableview.scrollIndicatorInsets = edgeInsets
            if (self.keyboard.activeField) != nil
            {
                self.tableview.scrollRectToVisible(self.keyboard.activeField!.frame, animated: true)
            }
        })
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
