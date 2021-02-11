//
//  EditProfileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 05/02/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit
protocol didEditProfileDelegate {
    func GetUpdatedProfile()
}
class EditProfileViewController: UIViewController,BSKeyboardControlsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate
{

    var ProfileResult : NSDictionary?
    
    var delegate : didEditProfileDelegate?
    
    var keyboard: BSKeyboardControls!
    let imagePicker = UIImagePickerController()
    var datePicker : UIDatePicker = UIDatePicker()
    @IBOutlet var btnMale : UIButton!
    @IBOutlet var btnFemale : UIButton!
    @IBOutlet var tableview : UITableView!
    @IBOutlet var headerView : UIView!
    var genderType = "male"
    
    @IBOutlet var imageContainer : UIView!
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var txtMobile : SkyFloatingLabelTextField!
    @IBOutlet var txtEmail : SkyFloatingLabelTextField!
    @IBOutlet var txtFirstName : SkyFloatingLabelTextField!
    @IBOutlet var txtLastName : SkyFloatingLabelTextField!
    @IBOutlet var txtDateOfBirth : SkyFloatingLabelTextField!
    @IBOutlet var txtOccupation : SkyFloatingLabelTextField!
    @IBOutlet var txtWebsite : SkyFloatingLabelTextField!
    @IBOutlet var txtAbout : SkyFloatingLabelTextField!
    
    var isUplod = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        keyboard = BSKeyboardControls(fields: [self.txtEmail,self.txtFirstName,self.txtLastName,self.txtOccupation,self.txtWebsite,self.txtAbout])
        keyboard.delegate = self
        
        self.imagePicker.delegate = self
        self.profileImage.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.tableview.tableHeaderView = self.headerView
            
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        }
        
        self.btnMale.set(image: UIImage(named: "check_blue"), title: " Male", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        self.genderType = "male"
        self.btnFemale.set(image: UIImage(named: "un_check"), title: " Female", titlePosition: .right, additionalSpacing: 5, state:.normal)
        
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(self.SaveClick))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        if let data = self.ProfileResult
               {
                   self.perform(#selector(self.SetUserProfileData(_:)), with: data, afterDelay: 0.2)
               }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "My Profile"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
       
    }
    @objc func SetUserProfileData(_ data : NSDictionary){
        if let tempStr = data.object(forKey: "phone") as? String {
            self.txtMobile.text = tempStr
        }
        if let tempStr = data.object(forKey: "f_name") as? String {
            self.txtFirstName.text = tempStr
        }
        if let tempStr = data.object(forKey: "l_name") as? String {
            self.txtLastName.text = tempStr
        }
        
        if let tempStr = data.object(forKey: "email") as? String {
            self.txtEmail.text = tempStr
        }
        
        if let tempStr = data.object(forKey: "occupation") as? String {
            self.txtOccupation.text = tempStr
        }
        if let tempStr = data.object(forKey: "web") as? String {
            self.txtWebsite.text = tempStr
        }
        if let tempStr = data.object(forKey: "about") as? String {
            self.txtAbout.text = tempStr
        }
        if let tempStr = data.object(forKey: "dob") as? String {
            self.txtDateOfBirth.text = tempStr
        }
        if let tempStr = data.object(forKey: "gender") as? String {
            if tempStr.caseInsensitiveCompare("male") == .orderedSame {
                self.btnMale.set(image: UIImage(named: "check_blue"), title: " Male", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
                self.genderType = "male"
                self.btnFemale.set(image: UIImage(named: "un_check"), title: " Female", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            }else{
                self.btnMale.set(image: UIImage(named: "un_check"), title: " Male", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
                self.genderType = "female"
                self.btnFemale.set(image: UIImage(named: "check_blue"), title: " Female", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            }
        }
        if let tempStr = data.object(forKey: "user_image") as? String {
            if tempStr.isEmpty == false {
                let urlString : URL = URL(string: tempStr)!
                self.profileImage.clipsToBounds = true
                self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "app-user-icon"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                    if image != nil {
                        self.profileImage.image = image
                        self.profileImage.contentMode = .scaleAspectFill
                    }
                    
                })
                
            }
        }
    }

    @objc func SaveClick(){
        self.UpdateProfile()
    }
    @IBAction func BtnGeneralSelect(_ sender: AnyObject){
        let btn = sender as? UIButton
        if(btn!.tag == 0){
            self.btnMale.set(image: UIImage(named: "check_blue"), title: " Male", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            
            self.btnFemale.set(image: UIImage(named: "un_check"), title: " Female", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.genderType = "male"
        }
        else{
            self.btnMale.set(image: UIImage(named: "un_check"), title: " Male", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            
            self.btnFemale.set(image: UIImage(named: "check_blue"), title: " Female", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.genderType = "female"
        }
    }
    
    @IBAction func loadImageButtonTapped(_ sender: UIButton) {
        
        
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
    //MARK:- Update Profile
    
    func UpdateProfile()
    {
        var f_name = ""
        
        if let tempStr = self.txtFirstName.text {
            f_name = tempStr
        }
        var l_name = ""
        if let tempStr = self.txtLastName.text {
            l_name = tempStr
        }
        var dob = ""
        if let tempStr = self.txtDateOfBirth.text {
            dob = tempStr
        }
        var occupation = ""
        if let tempStr = self.txtOccupation.text {
            occupation = tempStr
        }
        let social = ""
        
        var web = ""
        if let tempStr = self.txtWebsite.text {
            web = tempStr
        }
        var about = ""
        if let tempStr = self.txtAbout.text {
            about = tempStr
        }
        
     
        let urlStr = String(format: "%@?view=profile&page=user_update", arguments: [kMainDomainUrl])
       // http://sms.thewebtual.com/mapp/index.php?view=profile&page=user_update
        
        let requestBody = ["userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"f_name":f_name,"l_name":l_name,"dob":dob,"occupation":occupation,"social":social,"web":web,"about":about,"gender":self.genderType] as [String : Any]
        print(requestBody)
        
        
        let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let imageArray = NSMutableArray()
        
        var imagedata = Data();

        if isUplod
        {
            imagedata = self.profileImage.image!.jpegData(compressionQuality: 0.5) ?? Data()
//            imagedata = self.profileImage.image?.jpegData(compressionQuality: 0.5) ?? Data()
            imageArray.add(imagedata)
        }
        
        self.JsonAdsPostImageRequest(APINAME:requestUrl, ParamDict:requestBody as NSDictionary, ImageData:imageArray,key:"uploaded_file",view:self, completion:
                 {
                     
                     result in
                     print(result)
                     if result["msgcode"]  as? String ?? "1" == "0"
                     {
                         if let message = result.object(forKey: "message") as? String
                         {
                                                        self.TNMErrorMessage("", message: message)
                        }
                     }
                     else
                     {
                          if let message = result.object(forKey: "message") as? String
                          {
                                                        self.TNMErrorMessage("", message: message)
                                                    }
                     }
                     
             })
       
        
    }
    
    //MARK: - TNM Error Alert -
    func TNMErrorMessage(_ title : String, message : String)
    {
        var titleStr = title
        if titleStr.isEmpty == true {
            titleStr = kAppName
        }
        
        let refreshAlert = UIAlertController(title: titleStr, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        //
        //        }))
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async {
                //                if self.delegate != nil {
                //                    self.delegate?.reloadDisscutionData()
                //                }
                self.navigationController?.popFadeViewController()
                if self.delegate != nil {
                    self.delegate?.GetUpdatedProfile()
                }
                
                
            }
            
        }))
        
        DispatchQueue.main.async {
            self.present(refreshAlert, animated: true, completion: { () -> Void in
                
            })
            
        }
        
    }
    

    // MARK: - UIImagePickerControllerDelegate Methods
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            profileImage.image = pickedImage
            profileImage.contentMode = .scaleAspectFill
            profileImage.clipsToBounds = true
            self.isUplod = true
            dismiss(animated: true, completion: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
//        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//
//        if let pickedImage = info[.originalImage] as? UIImage
//            {
//                profileImage.image = pickedImage
//                profileImage.contentMode = .scaleAspectFill
//                profileImage.clipsToBounds = true
//                self.isUplod = true
//                dismiss(animated: true, completion: nil)
//
//            }
//        else {
//                // Fallback on earlier versions
//            }
//
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    


    //MARK:- Date Picker -
    @IBAction func PickerClick(_ sender: UIButton) {
        self.CreatePickerTag(sender.tag)
    }
    //MARK: Date Picker
    //--- *** ---//
    
    func CreatePickerTag(_ tag : Int)
    {
        let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        viewDatePicker.backgroundColor = UIColor.clear
        
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        self.datePicker.datePickerMode = UIDatePicker.Mode.date
        
        self.datePicker.locale = Locale(identifier: "en_GB")
        //        self.datePicker.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.ValueChanged)
        self.datePicker.addTarget(self, action: #selector(EditProfileViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        self.datePicker.tag = tag
        
        viewDatePicker.addSubview(self.datePicker)
        let titleStr = "Date Of Birth"
        
        
        let alertController = UIAlertController(title: titleStr, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.view.addSubview(viewDatePicker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Done", style: .default)
            { (action) in
                
                self.setDate(tag)
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
            {
                // ...
        }
        
        
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.txtDateOfBirth.text = dateFormatter.string(from: sender.date)
    }
    func setDate(_ tag : Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.txtDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        
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
    @objc func onKeyboardHide(_ notification: Notification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let duration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        UIView.animate(withDuration: duration, animations: { () -> Void in
            let edgeInsets  = UIEdgeInsets.zero;
            self.tableview.contentInset = edgeInsets
            self.tableview.scrollIndicatorInsets = edgeInsets
        })
    }
    @objc func onKeyboardShow(_ notification: Notification)
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
