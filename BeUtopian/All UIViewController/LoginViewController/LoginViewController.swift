//
//  LoginViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 11/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,BSKeyboardControlsDelegate {

    @IBOutlet var txtEmail : SkyFloatingLabelTextField!
    @IBOutlet var txtPassword : SkyFloatingLabelTextField!
    @IBOutlet var btnPassword : UIButton!
    
    
    var keyboard: BSKeyboardControls!
    
    @IBAction func loginClick(_ sender : AnyObject){
        
        self.TNMLogin()
        
//        print(txtEmail.text)
    }
    @IBAction func registerClick(_ sender : AnyObject){

    }
    @IBAction func forgotClick(_ sender : AnyObject){
        
    }
    @IBAction func showPasswordClick(_ sender : AnyObject){
        if sender.tag != 1 {
            self.btnPassword.tag = 1
            self.txtPassword.isSecureTextEntry = false
        }else{
            self.txtPassword.isSecureTextEntry = true
            self.btnPassword.tag = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.txtEmail.text = "pratik@thedezine.in"
//        self.txtPassword.text = "admin123"
//        self.txtEmail.text = "9510069163"
//        self.txtPassword.text = "admin12345"
//        self.txtEmail.text = "29virag@gmail.com"
        self.txtEmail.text = "9510069163"
        
        self.txtPassword.text = "123"

        keyboard = BSKeyboardControls(fields: [self.txtEmail,txtPassword])
        keyboard.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        DispatchQueue.main.async {
            CopyData().removeDatabase()
            CopyData().coyDatabase()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func TNMLogin()
    {
        if(txtEmail.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter username.")
            return
        }
        if(txtPassword.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter password.")
            return
        }
        self.view.endEditing(true)
        
        
        let urlStr = String(format: "%@?view=login&page=signin&user=%@&password=%@", arguments: [kMainDomainUrl,self.txtEmail.text!,self.txtPassword.text!])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                var isLoginSuccess : Bool = false
                print(data)
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let userData = userDetails.object(forKey: "select_society") as? NSArray {
                                isLoginSuccess = true
                                
                                DispatchQueue.main.async
                                    {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let objRoot:SelectSocityViewController = storyboard.instantiateViewController(withIdentifier: "SelectSocityViewController") as! SelectSocityViewController
                                        
                                        
                             
                                    objRoot.userMobileNumber = self.txtEmail.text
                                    objRoot.societyList = NSArray(array: userData)
                                    let navigate = UINavigationController(rootViewController: objRoot)
                                    appDelegate.SetNavigationBar(navigate)
                                    appDelegate.window?.rootViewController = navigate
                                        
                                        
                                        
                                }
                            }else{
                                self.LoginDidFinish(userDetails)
                            }
                            
                        }else{
                            if let msgCode = userDetails.object(forKey: "message") as? String {
                                appDelegate.TNMErrorMessage(kAppName, message: msgCode)
                            }
                        }
                    }
                    
                }
               
//                if isLoginSuccess == false {
//                     appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
//                }
                
            }else{
                if let json = data as? NSDictionary {
                    appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
//                    if let messageStr = json.objectForKey(kMessage) as? String {
//                        dispatch_async(dispatch_get_main_queue()) {
//                            appDelegate.PulseHideProgress()
//                            //                            appDelegate.TNMErrorMessage("", message: messageStr)
//                            appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
//                        }
//                        
//                    }
                }
                
            }
        }
        
    }

    func LoginDidFinish(_ userDetails : NSDictionary){
        if let userData = userDetails.object(forKey: "user_detail") as? NSArray {
            if userData.count > 0 {
                if userData.count == 1 {
                    if let SaveData = userData.object(at: 0) as? NSDictionary {
                        print(SaveData)
//                        isLoginSuccess = true
                        
                        let newData = GetNewDicationary(SaveData)
                        if let userId = newData.object(forKey: "userID") as? String {
                            appDelegate.LoginUserID = userId
                        }
                        if let socity = newData.object(forKey: "societyID") as? String {
                            appDelegate.SocietyID = socity
                        }
                        
                        //MakeHomeDeightCall
                        self.HomeDelightUserLogin(newData)
                        
                        
                        setLoginUser(newData)
                        DispatchQueue.main.async {
                            let objRoot: HomeRootViewController = HomeRootViewController(nibName: "HomeRootViewController", bundle: nil)
                            let navigate = UINavigationController(rootViewController: objRoot)
                            appDelegate.SetNavigationBar(navigate)
                            appDelegate.window?.rootViewController = navigate
//                            self.sidePanelController?.centerPanel = navigate
                        }
                    }
                }else{
//                    isLoginSuccess = true
                    
                    DispatchQueue.main.async
                        {
                            
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let objRoot:SelectSocityViewController = storyboard.instantiateViewController(withIdentifier: "SelectSocityViewController") as! SelectSocityViewController
                                                 
                       // let objRoot: SelectSocityViewController = SelectSocityViewController(nibName: "SelectSocityViewController", bundle: nil)
                        objRoot.societyList = NSArray(array: userData)
                        let navigate = UINavigationController(rootViewController: objRoot)
                        appDelegate.SetNavigationBar(navigate)
                        appDelegate.window?.rootViewController = navigate
//                        self.sidePanelController?.centerPanel = navigate
                    }
                    
                }
                
            }
            
        }
    }
    
    func HomeDelightUserLogin(_ userDetails : NSDictionary){
        print("HomeDelightUserLogin ===== ", userDetails)
        
        if let userid = UserDefaults.standard.value(forKey: "HomeDelightUserID") as? String {
            appDelegate.homeUserId = userid
            if userid.isEmpty == false {
                return
            }
        }
        
        var strEmail = "jiven@beutopian.com"
        var strFirstName = "jiven"
        var strLastName = "Iphone"
        var strMobileNo = "8000993047"
        
        
        
        if let strTemp = userDetails.object(forKey: "email") as? String {
            strEmail = strTemp
        }
        if let strTemp = userDetails.object(forKey: "firstname") as? String {
            strFirstName = strTemp
        }
        if let strTemp = userDetails.object(forKey: "lastname") as? String {
            strLastName = strTemp
        }
        if let strTemp = userDetails.object(forKey: "phone") as? String {
            strMobileNo = strTemp
        }
        
        //        {"device_id":"","email":"","first_name":"","last_name":"","mobile_type":"SmartSociety_Android","mobileno":"","password":"","user_name":""}
        
        let urlStr = String(format: "%@?device_id=%@&email=%@&first_name=%@&last_name=%@&mobile_type=%@&mobileno=%@&password=%@&user_name=%@", arguments: [kGetSmartsocietySignup, iDeviceToken, strEmail, strFirstName, strLastName, "SmartSociety_iOS", strMobileNo, "123456", strFirstName])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            
            if succeeded == true {
                print(data)
                
                if let userDetails = data as? NSDictionary{
                    if let userId = userDetails.object(forKey: "user_id") as? String {
                        UserDefaults.standard.set(userId, forKey: "HomeDelightUserID")
                        UserDefaults.standard.synchronize()
                        if let userid = UserDefaults.standard.value(forKey: "HomeDelightUserID") as? String {
                            appDelegate.homeUserId = userid
                        }
                    }
                }
            }
        }
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
