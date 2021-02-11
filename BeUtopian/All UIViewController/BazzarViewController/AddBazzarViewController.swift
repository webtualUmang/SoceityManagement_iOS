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

class AddBazzarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BSKeyboardControlsDelegate,RegardingPopupDelegate {
    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var headerView : UIView!
    
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var btnOffering: UIButton!
    @IBOutlet var btnLooking: UIButton!
    @IBOutlet var btnNegotiable: UIButton!
    @IBOutlet var btnShowPhone: UIButton!
    @IBOutlet var lblCatagory: UILabel!
    @IBOutlet var lblAddType: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var txtTitle: UITextField!
    @IBOutlet var txtDesc: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    
    var keyboard: BSKeyboardControls!
    
    
    var popup: KOPopupView?
    
    var category_list = NSArray()
    var flat_list = [["title":"Rent"],["title":"Buy"],["title":"Sell"]]
    
    var datePicker : UIDatePicker = UIDatePicker()
    
    var catID = ""
    var flatID = ""
    var negotible = "No"
    var phone_show = "No"
    var cate_type = "give"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.imageView.clipsToBounds = true
        
        
        
        // Do any additional setup after loading the view.
        let rightbtn = UIBarButtonItem(title: "POST", style: .plain, target: self, action:#selector(self.PostComplain))
        
        self.navigationItem.rightBarButtonItem = rightbtn
        
        btnOffering.set(image: UIImage(named: "check_blue"), title: " I am offering", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        btnLooking.set(image: UIImage(named: "un_check"), title: " I am looking for", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        btnNegotiable.set(image: UIImage(named: "uncheckbox"), title: " Negotiable", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        btnShowPhone.set(image: UIImage(named: "uncheckbox"), title: " Show Phone", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
        
        keyboard = BSKeyboardControls(fields: [self.txtTitle,self.txtDesc,self.txtPrice,self.txtName,self.txtEmail,self.txtPhone])
        keyboard.delegate = self
        // self.GetCatagoryType()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.title = "Post New Add"
        
        DispatchQueue.main.async
            {
                self.tableview.tableHeaderView = self.headerView
        }
    }
    
    @objc func PostComplain()
    {
        let mobile = self.txtPhone.text ?? ""
        if self.catID == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please select category")
            return
        }
        else if self.flatID == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please select type")
            return
        }
        else if self.txtTitle.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter title")
            return
        }
        else if self.txtDesc.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter description")
            return
        }
        else if self.txtPrice.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter price")
            return
        }
        else if self.txtName.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter name")
            return
        }
        else if self.txtEmail.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter email")
            return
        }
        else if !self.isValidEmail(self.txtEmail.text ?? "")
        {
            appDelegate.TNMErrorMessage("", message:"Please enter valid email")
            return
        }
        else if self.txtPhone.text ?? "" == ""
        {
            appDelegate.TNMErrorMessage("", message:"Please enter phone number")
            return
        }
        else if mobile.count < 10
        {
            appDelegate.TNMErrorMessage("", message:"Please enter valid phone number")
            return
        }
        else if self.lblDate.text ?? "" == "Select Valid Till"
               {
                   appDelegate.TNMErrorMessage("", message:"Please select valid till date")
                   return
               }
        //        self.navigationController?.popViewControllerAnimated(true)
        self.AddComplain()
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    //MARK:- Regard Popups -
    @IBAction func flatClick(_ sender : UIButton)
    {
        self.OpenFlatPopups()
    }
    @IBAction func regardClick(_ sender : UIButton)
    {
        self.OpenRegardPopups()
        
    }
    func OpenRegardPopups()
    {
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        let mainFrame = UIScreen.main.bounds
        popup?.tag = 0
        let regardView = CompainRegarding.instanceFromNib()
        regardView.resultKey = "name"
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
        if (popup == nil)
        {
            popup = KOPopupView()
        }
        let mainFrame = UIScreen.main.bounds
        popup?.tag = 1
        let regardView = CompainRegarding.instanceFromNib()
        regardView.resultKey = "title"
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
    
    func SelectRegardOption(_ data: NSDictionary)
    {
        print(data)
        if self.popup?.tag == 0
        {
            self.lblCatagory.text = data["name"] as? String ?? ""
            
            if let tempStr = data.object(forKey: "catID") as? String
            {
                self.catID = tempStr
            }
        }
        else
        {
            self.lblAddType.text = data["title"] as? String ?? ""
            if let tempStr = data.object(forKey: "title") as? String
            {
                self.flatID = tempStr
            }
        }
        self.popup?.hide(animated: true)
    }
    @IBAction func PickerClick(_ sender: UIButton)
    {
        self.CreatePickerTag(sender.tag)
    }
    func CreatePickerTag(_ tag : Int)
    {
        let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        viewDatePicker.backgroundColor = UIColor.clear
        
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        
        
        self.datePicker.datePickerMode = UIDatePicker.Mode.date
        self.datePicker.locale = Locale(identifier: "en_GB")
        self.datePicker.minimumDate = NSDate() as Date
        
        
        
        self.datePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        self.datePicker.tag = tag
        
        viewDatePicker.addSubview(self.datePicker)
        
        
        let alertController = UIAlertController(title:"Select Valid Till", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        
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
        
        
        
    }
    @objc func handleDatePicker(_ sender: UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.lblDate.text = dateFormatter.string(from: sender.date)
        
    }
    func setDate(_ tag : Int)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.lblDate.text = dateFormatter.string(from: datePicker.date)
    }
    //MARK: - UIButton Click Event
    @IBAction func AdTypeClick(_ sender : UIButton){
        if(sender == btnOffering)
        {
            btnOffering.set(image: UIImage(named: "check_blue"), title: " I am offering", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            
            btnLooking.set(image: UIImage(named: "un_check"), title: " I am looking for", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.cate_type = "give"
            
        }
        else{
            btnOffering.set(image: UIImage(named: "un_check"), title: " I am offering", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            
            btnLooking.set(image: UIImage(named: "check_blue"), title: " I am looking for", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            self.cate_type = "want"
            
        }
    }
    
    @IBAction func NegotiableClick(_ sender: UIButton){
        
        if(sender.isSelected == false){
            btnNegotiable.set(image: UIImage(named: "check_box_blue"), title: " Negotiable", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            btnNegotiable.isSelected = true
            self.negotible = "Yes"
            
        }else{
            btnNegotiable.set(image: UIImage(named: "uncheckbox"), title: " Negotiable", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            btnNegotiable.isSelected = false
            self.negotible = "No"
            
            
        }
    }
    @IBAction func ShowPhoneClick(_ sender: UIButton){
        
        if(sender.isSelected == false){
            btnShowPhone.set(image: UIImage(named: "check_box_blue"), title: " Show Phone", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            btnShowPhone.isSelected = true
            self.phone_show = "Yes"
            
        }else{
            btnShowPhone.set(image: UIImage(named: "uncheckbox"), title: " Show Phone", titlePosition: .right, additionalSpacing: 5, state: UIControl.State())
            btnShowPhone.isSelected = false
            self.phone_show = "No"
            
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
//        {
//            self.imageView.image = pickedImage
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
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        self.view.endEditing(true)
    }
    
    //MARK:- API Delegate -
    
    
    func AddComplain()
    {
        
        
        
        let urlStr = String(format: "%@?view=bazar&page=add", arguments: [kMainDomainUrl])
        // http://sms.thewebtual.com/mapp/index.php?view=profile&page=user_update
      //  http://sms.thewebtual.com/mapp/index.php?view=bazar&page=add"
        
     //   catID:18
       // desc:personal
       // email:t@t.com
       // for:Rent
       // negotiable:Yes
        //page:add
      //  phone:123456123
       // post:ttt
       // price:123
       // show_no:Yes
       // societyID:62
       // title:fff
       // type:give
       // userID:2939
       // valid:24-08-2020
        //view:bazar
        //uploaded_file:
        let requestBody:NSDictionary = ["userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"type":self.cate_type,"catID":self.catID,"for":self.flatID,"title":self.txtTitle.text ?? "","desc":self.txtDesc.text ?? "","price":self.txtPrice.text ?? "","negotiable":self.negotible,"post":self.txtName.text ?? "","email":self.txtEmail.text ?? "","phone":self.txtPhone.text ?? "","show_no":self.phone_show,"valid":self.lblDate.text ?? ""]
        
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
                    NotificationCenter.default.post(name:NSNotification.Name("Bazzar_list"), object: nil)
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
