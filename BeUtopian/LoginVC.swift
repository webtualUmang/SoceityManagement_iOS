//
//  ViewController.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, BSKeyboardControlsDelegate, UIActionSheetDelegate {

    @IBOutlet var btninfo: UIButton!
    var keyboard: BSKeyboardControls!
    @IBOutlet var txtUserName: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var tableview: UITableView!
    @IBOutlet var lbldescri: UILabel!
    @IBOutlet var lblsortdescri: UILabel!
    @IBOutlet weak var smallContainerView: UIView!
    var isSelected: Bool = false
    @IBOutlet var lbltip: UILabel!
    var multipleCompanyList = NSArray()
    var UserDetailsList = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        keyboard = BSKeyboardControls(fields: [txtUserName,txtPassword])
        keyboard.delegate = self
        
        txtUserName.layer.cornerRadius = 2
        txtUserName.layer.borderWidth = 1
        txtUserName.layer.borderColor = UIColor.lightGray.cgColor
//        txtUserName.clipsToBounds = true

        txtPassword.layer.cornerRadius = 2
        txtPassword.layer.borderWidth = 1
        txtPassword.layer.borderColor = UIColor.lightGray.cgColor
//        txtPassword.clipsToBounds = true

        lblsortdescri.attributedText = SetLabelParagraphStyle(lblsortdescri.text!)
        lblsortdescri.textAlignment = .center
        
        lbldescri.attributedText = SetLabelParagraphStyle(lbldescri.text!)
        lbldescri.textAlignment = .justified
        
        
        lbltip.attributedText = SetLabelParagraphStyle(lbltip.text!)
        lbltip.textAlignment = .justified
        
        let user = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: txtUserName.frame.height))
        txtUserName.leftView = user
        txtUserName.leftViewMode = UITextField.ViewMode.always
        
        let pass = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: txtPassword.frame.height))
        txtPassword.leftView = pass
        txtPassword.leftViewMode = UITextField.ViewMode.always
        
        
        //Cache UserName
        if let userName = UserDefaults.standard.object(forKey: kCacheUserName) as? String {
            if userName != "" {
                self.txtUserName.text = userName
            }
        }
        
//        self.txtUserName.text = "karenedwards"
//        self.txtPassword.text = "D3SAp16?"
        
//        appDelegate.AuthToken = "karenedwards:D3SAp16"
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginVC.handleTap(_:)))
//        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("called")
        
        if self.isSelected == true {
            self.isSelected = false
            
            self.smallContainerView.alpha = 1.0
            
            UIView.animate(withDuration: 0.1, delay: 0.0,
                options: [],
                animations: {
                    self.smallContainerView.isHidden = true
                    self.smallContainerView.frame = CGRect(x: self.smallContainerView.frame.origin.x, y: self.btninfo.frame.origin.y + self.btninfo.frame.size.height + 15, width: self.smallContainerView.frame.size.width, height: self.smallContainerView.frame.size.height)
                    self.smallContainerView.alpha = 0.0
                    //                self.loginButton.alpha = 1.0
                },completion: nil)
        }
       
    }
    
    func SetLabelParagraphStyle(_ text: String)-> NSAttributedString {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        return attrString
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.leftBarButtonItem = nil
        
        self.navigationItem.title = "Login"
        UIApplication.shared.statusBarStyle = .lightContent
        appDelegate.SetNavigationBar(self.navigationController!)
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
    }

    //MARK: - Button Click Event
    
    @IBAction func BtnLoginClick(_ sender: AnyObject){
        
        if(txtUserName.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter username.")
            return
        }
        if(txtPassword.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter password.")
            return
        }
        self.view.endEditing(true)

//        self.GetAuthToken()
        self.perform(#selector(LoginVC.GetAuthToken))
        
//        http://aplant.desap.net/ApproveWS.asmx?op=GetToken
    }
    
    //MARK:- GetLoginTypes -
    
    @objc func GetAuthToken(){
        
        var userName = ""
        var password = ""
        if let tempStr = txtUserName.text {
            userName = tempStr
        }
        if let tempStr = txtPassword.text {
            password = tempStr
        }
        
        
        
        let tokenStr = String(format: "%@:%@", arguments: [userName,password])
        let data : NSDictionary = ["Username":tokenStr]
        
        DispatchQueue.main.async {
            appDelegate.PulseShowProgress()
        }
        
        
        let connection = UrlConnection(url: kDesapAuthDomainUrl as NSString, param: data)
        
        connection.completeBlock = {(obj : AnyObject?, connection : UrlConnection) -> Void in
            if let data : NSDictionary = obj as? NSDictionary {
                if data.object(forKey: "Status") as? String == "1" {
                    if let token = data.object(forKey: "Token") as? String {
                        appDelegate.AuthToken = token
                        
                        //Save Auth Token
                        self.SaveAutoLoginCredintial(token, keyStr: kAuthorisationToken)
                        
                        //Save Cache UserName
                        RemoveCacheObjectForKey(kCacheUserName)
                        self.SaveAutoLoginCredintial(userName, keyStr: kCacheUserName)
                        
                        
                        self.perform(#selector(LoginVC.GetADEmployeeDetails), with: nil, afterDelay: 0.1)
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.PulseHideProgress()
                            appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        appDelegate.PulseHideProgress()
                        appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                    }
                }
            }
            
        }
        connection.errorBlock = {(obj : AnyObject?, connection : UrlConnection) -> Void in
//            print(obj)
            DispatchQueue.main.async {
                appDelegate.PulseHideProgress()
                appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
            }
            if (obj?.isKind(of: NSDictionary.classForCoder()) == true){
                
            }
        }
        
    }
   
   //MARK: - GetADEmployeeDetails - 
    //Combine GetLoginTypes & GetEmployeeDetails web services
    @objc func GetADEmployeeDetails()
    {
        
        let urlStr = String(format: "%@/api/%@/Employee/GetADEmployeeDetails", arguments: [kMainDomainUrl,appDelegate.ClientTag])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let userDetails = data as? NSArray {
                    if userDetails.count > 1 {
                        self.GetActiveCompanies(userDetails)
                    }else if userDetails.count > 0 {
                        if let userData = userDetails.object(at: 0) as? NSDictionary {
                            self.RedirectToDeshBoard(userData)
                        }else{
                            DispatchQueue.main.async {
                                appDelegate.PulseHideProgress()
                                appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.PulseHideProgress()
                            appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                        }
                    }
                    
                }else{
                    DispatchQueue.main.async {
                        appDelegate.PulseHideProgress()
                        appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                    }
                }
                

            }else{
                if let json = data as? NSDictionary {
                    if (json.object(forKey: kMessage) as? String) != nil {
                        DispatchQueue.main.async {
                            appDelegate.PulseHideProgress()
//                            appDelegate.TNMErrorMessage("", message: messageStr)
                            appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                        }
                        
                    }
                }
                
            }
        }
        
    }

    func RedirectToDeshBoard(_ userData : NSDictionary){
        if let tempStr = userData.object(forKey: "CompanyID") as? NSNumber {
            appDelegate.CompanyID = tempStr.stringValue
            self.SaveAutoLoginCredintial(tempStr.stringValue, keyStr: kCompanyID)
            
        }
        //GetUserDetails
        if let tempStr = userData.object(forKey: "EmployeeID") as? NSNumber {
            appDelegate.EmployeeID = tempStr.stringValue
            
            self.SaveAutoLoginCredintial(tempStr.stringValue, keyStr: kEmployeeID)
            
            
            let newData = GetNewDicationary(userData)
            setLoginUser(newData)
            
            DispatchQueue.main.async {
                let objRoot: MainVC = MainVC(nibName: "MainVC", bundle: nil)
                let navigate = UINavigationController(rootViewController: objRoot)
//                self.sidePanelController?.centerPanel = navigate
                appDelegate.window?.rootViewController = navigate
                
            }
        }else{
            DispatchQueue.main.async {
                appDelegate.PulseHideProgress()
                appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
            }
        }

    }
    func GetActiveCompanies(_ dataList : NSArray){
        let urlStr = String(format: "%@/api/%@/Companies/GetActiveCompanies", arguments: [kMainDomainUrl,appDelegate.ClientTag])
        
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            
            DispatchQueue.main.async {
                appDelegate.PulseHideProgress()
            }
            
            if succeeded == true {
                print(data)
                if let compnies = data as? NSArray {
                    DispatchQueue.main.async {
                        self.multipleCompanyList = NSArray(array: compnies)
                        self.UserDetailsList = NSArray(array: dataList)
                    
                        self.ShowMultipleCompanyPopups(dataList, companyList: compnies)
                    }
                }else {
                    if dataList.count > 0 {
                        if let userData = dataList.object(at: 0) as? NSDictionary {
                            self.RedirectToDeshBoard(userData)
                        }else{
                            DispatchQueue.main.async {
                                appDelegate.PulseHideProgress()
                                appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            appDelegate.PulseHideProgress()
                            appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                        }
                    }
                    
                }
                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        
                        DispatchQueue.main.async {
                            appDelegate.PulseHideProgress()
                            appDelegate.TNMErrorMessage("", message: messageStr)
                        }
                    }
                }
                
            }
        }
    }

    func actionSheet(_ sheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
//        print("index %d %@", buttonIndex, sheet.buttonTitleAtIndex(buttonIndex));
        if buttonIndex > 0 {
            let newIndex = buttonIndex - 1
            if self.multipleCompanyList.count > newIndex {
                if let CompanyData = self.multipleCompanyList.object(at: newIndex) as? NSDictionary {
                    if let findId = CompanyData.object(forKey: "CompanyId") as? NSNumber {
                        //GetCompanyData
                        for data in self.UserDetailsList {
                            if let tempData = data as? NSDictionary {
                                if let dataId = tempData.object(forKey: "CompanyID") as? NSNumber {
//                                    print(findId)
//                                    print(dataId)
                                    if findId == dataId {
                                        self.RedirectToDeshBoard(tempData)
                                        break
                                    }
                                    
                                }
                            }
                        }
                    }
                }
              
            }
        }
    }
    
    func ShowMultipleCompanyPopups(_ dataList : NSArray, companyList : NSArray){
        
        let sheet: UIActionSheet = UIActionSheet()
        let title: String = "Select Company"
        sheet.title  = title
        sheet.delegate = self
        sheet.addButton(withTitle: "Cancel")
        
        for data in dataList {
            if let tempData = data as? NSDictionary {
                if let dataId = tempData.object(forKey: "CompanyID") as? NSNumber {
                    
                    for companyData in companyList {
                        if let CompDetails = companyData as? NSDictionary {
                            if let findId = CompDetails.object(forKey: "CompanyId") as? NSNumber {
                                if findId == dataId {
                                    if let compNameStr = CompDetails.object(forKey: "CompanyName") as? String {
                                        sheet.addButton(withTitle: compNameStr)
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        
        
      
        sheet.cancelButtonIndex = 0
        DispatchQueue.main.async {
            sheet.show(in: self.view);
            
        }
        
        
        /*
        let optionMenu = UIAlertController(title: "Select Company", message: nil, preferredStyle: .ActionSheet)
        
        // 2
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Deleted")
        })
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
        })
        
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
        })
        
        
        // 4
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        dispatch_async(dispatch_get_main_queue()) {
            self.presentViewController(optionMenu, animated: true, completion: { () -> Void in
                
            })

        }
        */
        
    }
    
    
    //MARK:- GetLoginTypes -
    func GetLoginTypes()
    {        
        let urlStr = String(format: "%@/api/%@/Users/GetLoginTypes", arguments: [kMainDomainUrl,appDelegate.ClientTag])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let userTypes = data as? NSArray {
                    if userTypes.count > 0 {
                        if let userData = userTypes.object(at: 0) as? NSDictionary {
                            if let tempStr = userData.object(forKey: "CompanyId") as? NSNumber {
                                appDelegate.CompanyID = tempStr.stringValue
                                self.SaveAutoLoginCredintial(tempStr.stringValue, keyStr: kCompanyID)
                                self.GetEmployeeDetails()
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
    //MARK:- GetEmployeeDetails -
    func GetEmployeeDetails()
    {
        
        let urlStr = String(format: "%@/api/%@/Employee/GetEmployeeDetails?companyId=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,appDelegate.CompanyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let userDetails = data as? NSDictionary {
                    if let tempStr = userDetails.object(forKey: "EmployeeID") as? NSNumber {
                        appDelegate.EmployeeID = tempStr.stringValue
                        
                        self.SaveAutoLoginCredintial(tempStr.stringValue, keyStr: kEmployeeID)
                        
                        
                        let newData = GetNewDicationary(userDetails)
                        setLoginUser(newData)
                        
                        DispatchQueue.main.async {
                            let objRoot: MainVC = MainVC(nibName: "MainVC", bundle: nil)
                            let navigate = UINavigationController(rootViewController: objRoot)
//                            self.sidePanelController?.centerPanel = navigate
                            appDelegate.window?.rootViewController = navigate
                        }
                    }else{
                        appDelegate.TNMErrorMessage("Invalid Email or Password", message: "Please check your entry and try again.")
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

    func SaveAutoLoginCredintial(_ valueStr : String, keyStr : String){
        UserDefaults.standard.set(valueStr, forKey: keyStr)
        UserDefaults.standard.synchronize()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelected = false
        
        smallContainerView.alpha = 1.0
        
        UIView.animate(withDuration: 0.1, delay: 0.0,
            options: [],
            animations: {
                self.smallContainerView.isHidden = true
                self.smallContainerView.frame = CGRect(x: self.smallContainerView.frame.origin.x, y: self.btninfo.frame.origin.y + self.btninfo.frame.size.height + 15, width: self.smallContainerView.frame.size.width, height: self.smallContainerView.frame.size.height)
                self.smallContainerView.alpha = 0.0
                //                self.loginButton.alpha = 1.0
            },completion: nil)
    }
    
    
    @IBAction func BtnInfoClick(_ sender: AnyObject){
                
        if isSelected == false{
            isSelected = true
            
            smallContainerView.alpha = 0.0
            
            UIView.animate(withDuration: 0.1, delay: 0.0,
                options: [],
                animations: {
                    self.smallContainerView.isHidden = false
                    self.smallContainerView.frame = CGRect(x: self.smallContainerView.frame.origin.x, y: self.btninfo.frame.origin.y + self.btninfo.frame.size.height + 15, width: self.smallContainerView.frame.size.width, height: self.smallContainerView.frame.size.height)
                    self.smallContainerView.alpha = 1.0
                    //                self.loginButton.alpha = 1.0
                },completion: nil)
        }
        else{
            isSelected = false
            
            smallContainerView.alpha = 1.0
            
            UIView.animate(withDuration: 0.1, delay: 0.0,
                options: [],
                animations: {
                    self.smallContainerView.isHidden = true
                    self.smallContainerView.frame = CGRect(x: self.smallContainerView.frame.origin.x, y: self.btninfo.frame.origin.y + self.btninfo.frame.size.height + 15, width: self.smallContainerView.frame.size.width, height: self.smallContainerView.frame.size.height)
                    self.smallContainerView.alpha = 0.0
                    //                self.loginButton.alpha = 1.0
                },completion: nil)
        }
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


}

