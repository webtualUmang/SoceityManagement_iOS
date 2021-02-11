//
//  ComplainAddViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

//discussion
//compile
//help&photo

import UIKit
import AssetsLibrary



class ComplainAddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate, TNMKeyboardControlsDelegate,RegardingPopupDelegate {
    
    @IBOutlet var textviewDesc: UITextView!
    
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    @IBOutlet var lblImageName: UILabel!
    @IBOutlet var btnPersonal: UIButton!
    @IBOutlet var btnCommunity: UIButton!
    @IBOutlet var txtIssue: UITextField!
    //@IBOutlet var txtDescription: UITextField!
    var keyboard: TNMKeyboardControls!
    @IBOutlet var btnSelectIssue: UIButton!
    
    var popup: KOPopupView?
    
    var category_list = NSArray()
    var flat_list = NSArray()
    var selectCat = NSDictionary()
    var selectflat = NSDictionary()
    
    @IBOutlet var lblFlat : UILabel!
    @IBOutlet var lblRegard : UILabel!
    
    var catID = ""
    var flatID = ""
    
    var complainType = "personal"
    var urgent = "No"
    var imgURL: URL?
    var cameraBool: Bool?
    var filePath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        textviewDesc.text = "Description*"
        textviewDesc.textColor = UIColor.lightGray
        textviewDesc.autocorrectionType = .no
        textviewDesc.delegate = self
        // Do any additional setup after loading the view.
        let rightbtn = UIBarButtonItem(title: "POST", style: .plain, target: self, action: #selector(ComplainAddViewController.PostComplain))
        
        self.navigationItem.rightBarButtonItem = rightbtn
        
        btnPersonal.set(image: UIImage(named: "check_blue"), title: " Personal", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        btnCommunity.set(image: UIImage(named: "un_check"), title: " Cummunity", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        btnSelectIssue.set(image: UIImage(named: "uncheckbox"), title: " Select issue if urgent", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        self.keyboard = TNMKeyboardControls(fields: [txtIssue,textviewDesc])
        
        keyboard.delegate = self
        
        
        self.perform(#selector(ComplainAddViewController.GetCatagoryType))
        
        txtIssue.autocorrectionType = .no
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Add Complains"
    }
    override func viewWillDisappear(_ animated: Bool) {
        getImage()
        
        if self.filePath.isEmpty == false {
            do {
                try FileManager.default.removeItem(atPath: self.filePath)
            } catch {}
            self.filePath = ""
        }
        
        
    }
    @objc func PostComplain()
    {
        if self.catID.isEmpty
        {
            appDelegate.TNMErrorMessage("", message:"Please select category")
            return
        }
        else if self.txtIssue.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter issue type")
            return
        }
        else if self.textviewDesc.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter description")
            return
        }
        if self.flatID.isEmpty
        {
            appDelegate.TNMErrorMessage("", message:"Please select flat")
            return
        }
        
        
        self.AddComplain()
    }
    //MARK:- Regard Popups -
    @IBAction func flatClick(_ sender : UIButton)
    {
        if self.flat_list .count > 0 {
            self.OpenFlatPopups()
            
        }else{
            self.GetCatagoryType()
        }
    }
    @IBAction func regardClick(_ sender : UIButton){
        if self.category_list .count > 0 {
            self.OpenRegardPopups()
        }else{
            self.GetCatagoryType()
        }
    }
    func OpenRegardPopups(){
        if (popup == nil) {
            popup = KOPopupView()
        }
        let mainFrame = UIScreen.main.bounds
        
        let regardView = CompainRegarding.instanceFromNib()
        regardView.resultKey = "category_name"
        regardView.resultList = NSArray(array: self.category_list)
        regardView.CreateCell()
        regardView.delegate = self
        var frmView = regardView.bounds
        frmView.origin.x = 0
        frmView.origin.y = 0
        frmView.size.height = mainFrame.height - 100
        frmView.size.width = mainFrame.width - 60
        regardView.frame = frmView
        
        popup?.handleView.addSubview(regardView)
        
        regardView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                    y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    func OpenFlatPopups(){
        if (popup == nil) {
            popup = KOPopupView()
        }
        let mainFrame = UIScreen.main.bounds
        
        let regardView = CompainRegarding.instanceFromNib()
        regardView.resultKey = "flatNO"
        regardView.resultList = NSArray(array: self.flat_list)
        regardView.CreateCell()
        regardView.delegate = self
        var frmView = regardView.bounds
        frmView.origin.x = 0
        frmView.origin.y = 0
        frmView.size.height = mainFrame.height - 100
        frmView.size.width = mainFrame.width - 60
        regardView.frame = frmView
        
        popup?.handleView.addSubview(regardView)
        
        regardView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                    y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
    func SelectRegardOption(_ data: NSDictionary) {
        
        self.popup?.hide(animated: true)
        
        DispatchQueue.main.async
            {
                
                
                if let tempStr = data.object(forKey: "catID") as? String {
                    self.catID = tempStr
                }
                if let tempStr = data.object(forKey: "category_name") as? String {
                    self.lblRegard.text = tempStr
                }
                
                if let tempStr = data.object(forKey: "flatID") as? String {
                    self.flatID = tempStr
                }
                if let tempStr = data.object(forKey: "flatNO") as? String {
                    self.lblFlat.text = tempStr
                }
        }
        
        
        
    }
    //MARK: - UIButton Click Event
    
    @IBAction func BtnFilterSelect(_ sender: AnyObject)
    {
        let btn = sender as? UIButton
        if(btn!.tag == 0){
            btnPersonal.set(image: UIImage(named: "check_blue"), title: " Personal", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            
            btnCommunity.set(image: UIImage(named: "un_check"), title: " Cummunity", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.complainType = "personal"
        }
        else{
            btnPersonal.set(image: UIImage(named: "un_check"), title: " Personal", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            
            btnCommunity.set(image: UIImage(named: "check_blue"), title: " Community", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.complainType = "community"
        }
    }
    
    @IBAction func BtnSelectIssue(_ sender: AnyObject){
        
        let btn = sender as? UIButton
        
        if(btn?.isSelected == false){
            btnSelectIssue.set(image: UIImage(named: "check_box_blue"), title: " Select issue if urgent", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            btnSelectIssue.isSelected = true
            self.urgent = "Yes"
        }else{
            btnSelectIssue.set(image: UIImage(named: "uncheckbox"), title: " Select issue if urgent", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            btnSelectIssue.isSelected = false
            self.urgent = "No"
        }
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
            self.cameraBool = true
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
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            self.dismiss(animated: true, completion: nil)
        }
//        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let pickedImage = info[Original] as? UIImage
//        {
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = pickedImage
//
//
//
//            self.dismiss(animated: true, completion: nil);
//        }
//
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- TextView -
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description*"
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
    func AddComplain()
    {
        
        
        
        let urlStr = String(format: "%@", arguments: [kMainDomainUrl])
        // http://sms.thewebtual.com/mapp/index.php?view=profile&page=user_update
        
        //  let requestBody = ["userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"f_name":f_name,"l_name":l_name,"dob":dob,"occupation":occupation,"social":social,"web":web,"about":about,"gender":self.genderType] as [String : Any]
        //   print(requestBody)
        
        let requestBody:NSDictionary = ["view":"helpdesk","page":"add","userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"catID":self.catID,"flatID":self.flatID,"complaint_type":"personal","title":self.txtIssue.text ?? "","description":self.textviewDesc.text ?? "","urgent":self.urgent]
        
        let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let imageArray = NSMutableArray()
        
        var imagedata = Data();
        
        if self.imageView.image != nil
        {
            imagedata = self.imageView.image!.jpegData(compressionQuality: 0.5) ?? Data()
//            imagedata = self.imageView.image?.jpegData(compressionQuality: 0.5) ?? Data()
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
                        appDelegate.TNMErrorMessage("", message:message)
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
    
    // Do any additional setup after loading the view.
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyboardShow:", name: UIKeyboardWillShowNotification, object: self.view.window)
    //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyboardHide:", name: UIKeyboardWillHideNotification, object: self.view.window)
    //
    /*
     func onKeyboardHide(notification: NSNotification)
     {
     let userInfo : NSDictionary = notification.userInfo!
     let duration = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! Double
     UIView.animateWithDuration(duration, animations: { () -> Void in
     let edgeInsets  = UIEdgeInsetsZero;
     self.tableview.contentInset = edgeInsets
     self.tableview.scrollIndicatorInsets = edgeInsets
     })
     }
     func onKeyboardShow(notification: NSNotification)
     {
     let userInfo : NSDictionary = notification.userInfo!
     let kbMain  = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue
     let kbSize = kbMain.size
     let duration  = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! Double;
     UIView.animateWithDuration(duration, animations: { () -> Void in
     let edgeInsets  = UIEdgeInsetsMake(0, 0, kbSize.height, 0)
     
     self.tableview.contentInset = edgeInsets
     self.tableview.scrollIndicatorInsets = edgeInsets
     if (self.keyboard.activeField) != nil
     {
     self.tableview.scrollRectToVisible(self.keyboard.activeField!.frame, animated: true)
     }
     })
     }
     */
    //MARK:- API Delegate -
    @objc func GetCatagoryType()
    {
        
        
        let urlStr = String(format: "%@?view=helpdesk&page=complaintcategory&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            //                            if let message = ResultData.objectForKey("message") as? String {
                            //                                self.TNMErrorMessage("", message: message)
                            //                            }
                            
                            DispatchQueue.main.async
                                {
                                    if let bannerList = ResultData.object(forKey: "category_list") as? NSArray
                                    {
                                        self.category_list = NSArray(array: bannerList)
                                        if bannerList.count == 1 {
                                            if let tempData = bannerList.object(at: 0) as? NSDictionary {
                                                if let tempStr = tempData.object(forKey: "catID") as? String {
                                                    self.catID = tempStr
                                                }
                                                if let tempStr = tempData.object(forKey: "category_name") as? String {
                                                    self.lblRegard.text = tempStr
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    if let bannerList = ResultData.object(forKey: "flat_list") as? NSArray
                                    {
                                        self.flat_list = NSArray(array: bannerList)
                                        
                                        if bannerList.count == 1 {
                                            if let tempData = bannerList.object(at: 0) as? NSDictionary {
                                                if let tempStr = tempData.object(forKey: "flatID") as? String {
                                                    self.flatID = tempStr
                                                }
                                                if let tempStr = tempData.object(forKey: "flatNO") as? String {
                                                    self.lblFlat.text = tempStr
                                                }
                                            }
                                            
                                        }
                                        
                                    }
                                    
                            }
                            
                            
                            
                        }
                    }
                }
                
                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
        
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
    
    //MARK: - TNM Error Alert -
    func TNMErrorMessage(_ title : String, message : String){
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
                //                if self.delegate != nil {
                //                    self.delegate?.ReloadFacilityResult()
                //                }
                
                
            }
            
        }))
        
        DispatchQueue.main.async {
            self.present(refreshAlert, animated: true, completion: { () -> Void in
                
            })
            
        }
        
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
