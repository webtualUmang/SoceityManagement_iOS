//
//  VerifyMobileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 02/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController,BSKeyboardControlsDelegate {
    
    var keyboard: BSKeyboardControls!
    @IBOutlet var labelMobile : UILabel!
    
    @IBOutlet var lblTermsNPrivacy : UILabel!
    
    var resultOTP : String = ""
    var mobileNumberStr : String = ""
    
    @IBOutlet var txtOTP : UITextField!
    
    @IBAction func verifyClick(_ sender : UIButton){
        if resultOTP == txtOTP.text {
            self.TNMLogin()
        }else{
            appDelegate.TNMErrorMessage("", message: "Invalid OTP!")
        }
        
    }
    @IBAction func contactClicked(_ sender:UIButton)
    {
        if let url = URL(string: "tel://9978619808"),
        UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10, *) {
             UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
                 // add error message here
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = NSTheme().GetNavigationBGColor()
        
        let attribute = [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 14.0), NSAttributedString.Key.foregroundColor : NSTheme().GetNavigationBGColor(),
                         NSAttributedString.Key.underlineStyle : 1 ] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string:"Don't  receive the code?")
        
        let buttonTitleStr = NSMutableAttributedString(string:" Contact Us", attributes:attribute)
        attributedString.append(buttonTitleStr)
        
        lblTermsNPrivacy.attributedText = attributedString
        
        keyboard = BSKeyboardControls(fields: [self.txtOTP])
        keyboard.delegate = self
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(OTPViewController.PhoneCall))
        lblTermsNPrivacy.isUserInteractionEnabled = true
        lblTermsNPrivacy.addGestureRecognizer(tap1)
    }
    @objc func PhoneCall(){
        if let url = URL(string: "tel://07948010211"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.labelMobile.text = mobileNumberStr
        self.navigationItem.title = "OTP"
        self.navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }
    
    @IBAction func backClick(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func TNMLogin()
    {
        if(txtOTP.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter OTP.")
            return
        }
        
        self.view.endEditing(true)
        
        
        let urlStr = String(format: "%@?view=verify_user&page=match&phone=%@&otp=%@", arguments: [kMainDomainUrl,self.mobileNumberStr,self.txtOTP.text!])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0"
                        {
                            if let userData = userDetails.object(forKey: "select_society") as? NSArray
                            {
                                
                                
                                DispatchQueue.main.async
                                    {
                                        
                                        
                                        
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let objRoot:SelectSocityViewController = storyboard.instantiateViewController(withIdentifier: "SelectSocityViewController") as! SelectSocityViewController
                                        
                                        objRoot.userMobileNumber = self.labelMobile.text
                                        objRoot.societyList = NSArray(array: userData)
                                        let navigate = UINavigationController(rootViewController: objRoot)
                                        appDelegate.SetNavigationBar(navigate)
                                        //                                    self.sidePanelController?.centerPanel = navigate
                                        appDelegate.window?.rootViewController = navigate
                                }
                            }else{
                                self.LoginDidFinish(userDetails)
                            }
                            
                        }else{
                            DispatchQueue.main.async
                                {
                                    let objRoot: ThanksViewController = ThanksViewController(nibName: "ThanksViewController", bundle: nil)
                                    
                                    self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                    
                            }
                            //                            if let msgCode = userDetails.objectForKey("message") as? String {
                            //                                appDelegate.TNMErrorMessage(kAppName, message: msgCode)
                            //                            }
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
                    
                    DispatchQueue.main.async {
                        
                        
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let objRoot:SelectSocityViewController = storyboard.instantiateViewController(withIdentifier: "SelectSocityViewController") as! SelectSocityViewController
                        
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
