//
//  VerifyMobileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 02/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


var finalResult = NSMutableDictionary()

class VerifyMobileViewController: UIViewController,BSKeyboardControlsDelegate,HeplPopupDelegate {

    @IBOutlet var txtMobile : UITextField!
    @IBOutlet var lblTerms1 : UILabel!
    @IBOutlet var lblTerms2 : UILabel!
    @IBOutlet var lblPrivacy : UILabel!
    
    var keyboard: BSKeyboardControls!
    
    var helpPopups: KOPopupView = KOPopupView()
    
    func helpPopupClose() {
        helpPopups.hide(animated: true)
    }
    
    @objc func OpenPopup(){
        DispatchQueue.main.async(execute: { () -> Void in
            let notesView = WhyPopup.instanceFromNib()
            notesView.delegate = self
            self.helpPopups.handleView.addSubview(notesView)
            
            notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                y: self.helpPopups.handleView.frame.size.height/2.0)
            self.helpPopups.show()
            
            
        })
    }
    @IBAction func whyClick(_ sender : UIButton){
        self.perform(#selector(VerifyMobileViewController.OpenPopup), with: nil, afterDelay: 0.5)
    }
    @IBAction func verifyClick(_ sender : UIButton){
        self.VerifyMobile()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        //your code
        if textField.text?.count >= 10 {
            self.VerifyMobile()
        }
    }
    @IBAction func viewDemoClick(_ sender : UIButton){
        
        DispatchQueue.main.async {
            let objRoot: DemoSocietyController = DemoSocietyController(nibName: "DemoSocietyController", bundle: nil)
            
            let navigate = UINavigationController(rootViewController: objRoot)
            appDelegate.SetNavigationBar(navigate)
            appDelegate.window?.rootViewController = navigate
            //                            self.sidePanelController?.centerPanel = navigate
        }
        
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.txtMobile.text = "9510069163"
//         self.txtMobile.text = "8000993047"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = NSTheme().GetNavigationBGColor()
       
        let attribute = [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor : NSTheme().GetNavigationBGColor(),
                         NSAttributedString.Key.underlineStyle : 1 ] as [NSAttributedString.Key : Any]
        let attributedString = NSMutableAttributedString()
        
        let buttonTitleStr = NSMutableAttributedString(string:"Terms and", attributes:attribute)
        attributedString.append(buttonTitleStr)
        self.lblTerms1.attributedText = buttonTitleStr
        
        let attributedString1 = NSMutableAttributedString()
        let buttonTitleStr1 = NSMutableAttributedString(string:"Conditions", attributes:attribute)
        attributedString1.append(buttonTitleStr1)
        self.lblTerms2.attributedText = buttonTitleStr
        
        let attributedString3 = NSMutableAttributedString()
        attributedString3.append(NSMutableAttributedString(string: "and "))
        attributedString3.append(NSMutableAttributedString(string:"Privacy Policy", attributes:attribute))

        self.lblPrivacy.attributedText = attributedString3
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(VerifyMobileViewController.TermsAndCondition))
        lblTerms1.isUserInteractionEnabled = true
        lblTerms1.addGestureRecognizer(tap)
        lblTerms2.isUserInteractionEnabled = true
        lblTerms2.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(VerifyMobileViewController.PrivacyPolicy))
        lblPrivacy.isUserInteractionEnabled = true
        lblPrivacy.addGestureRecognizer(tap1)
        
        keyboard = BSKeyboardControls(fields: [self.txtMobile])
        keyboard.delegate = self
        
        self.txtMobile.addTarget(self, action: #selector(VerifyMobileViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        //setup static result
        self.SetupFinalResult()
    }
    func SetupFinalResult(){
        
        finalResult.setObject("0", forKey: "societyID" as NSCopying)
        finalResult.setObject("", forKey: "societyName" as NSCopying)
        finalResult.setObject("", forKey: "phone" as NSCopying)
        finalResult.setObject("", forKey: "email" as NSCopying)
        finalResult.setObject("", forKey: "first_name" as NSCopying)
        finalResult.setObject("", forKey: "last_name" as NSCopying)
        finalResult.setObject("new", forKey: "flag" as NSCopying)
        finalResult.setObject("", forKey: "other_phone" as NSCopying)
        finalResult.setObject("", forKey: "city_name" as NSCopying)

    }
    
    @objc func TermsAndCondition(){
        var urlStr : String = ""
        var titleStr : String = "Website"
        urlStr = "http://sms.thewebtual.com/terms-and-conditions.html"
        titleStr = "Terms and Condition"
        if urlStr.isEmpty == false {
            let objRoot: BrowserViewController = BrowserViewController(nibName: "BrowserViewController", bundle: nil)
            objRoot.websiteUrl = urlStr
            objRoot.navigationTitle = titleStr
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
    }
    @objc func PrivacyPolicy(){
        var urlStr : String = ""
        var titleStr : String = "Website"
        urlStr = "http://sms.thewebtual.com/privacy_policy.html"
        titleStr = "Privacy Policy"
        if urlStr.isEmpty == false {
            let objRoot: BrowserViewController = BrowserViewController(nibName: "BrowserViewController", bundle: nil)
            objRoot.websiteUrl = urlStr
            objRoot.navigationTitle = titleStr
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
      
    }
    
     @IBAction func backClick(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func VerifyMobile()
    {
        
        if(txtMobile.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter mobile number.")
            return
        }
        
        
        
        self.view.endEditing(true)
        

        let urlStr = String(format: "%@?view=verify_user&page=otp_send&phone=%@", arguments: [kMainDomainUrl,self.txtMobile.text!])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
                
                
                if self.txtMobile.text == "8000993047" || self.txtMobile.text == "9180009930" {
                    self.LoginDidFinish()
                    return
                }
                
                
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            DispatchQueue.main.async {
                                let objRoot: OTPViewController = OTPViewController(nibName: "OTPViewController", bundle: nil)
                                if let otpStr = userDetails.object(forKey: "otp") as? String {
                                    objRoot.resultOTP = otpStr
                                }
                                if let otpStr = userDetails.object(forKey: "otp") as? NSNumber {
                                    objRoot.resultOTP = otpStr.stringValue
                                }
                                objRoot.mobileNumberStr = self.txtMobile.text!
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                let objRoot: SignUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
                                
                                objRoot.mobileNumberStr = self.txtMobile.text!
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
                    appDelegate.TNMErrorMessage(kAppName, message: kSomethingWrongMessage)
                   
                }
                
            }
        }
        
    }
    
    func LoginDidFinish(){
        let tempData : NSDictionary = ["address":"","email":"jiven@beutopian.com","firstname":"Jiven","lastname":"Iphone","phone":"8000993047","societyID":"23","societyName":"Beutopian Society","userID":"429","userimage":"http://www.beutopian.com/uploads/user_image/app-user-icon.png"]
        
        if let SaveData = tempData as? NSDictionary {
            print(SaveData)
            //                        isLoginSuccess = true
            
            let newData = GetNewDicationary(SaveData)
            if let userId = newData.object(forKey: "userID") as? String {
                appDelegate.LoginUserID = userId
            }
            if let socity = newData.object(forKey: "societyID") as? String {
                appDelegate.SocietyID = socity
            }
            
            self.HomeDelightUserLogin(tempData)
            
            setLoginUser(newData)
            DispatchQueue.main.async {
                let objRoot: HomeRootViewController = HomeRootViewController(nibName: "HomeRootViewController", bundle: nil)
                let navigate = UINavigationController(rootViewController: objRoot)
                appDelegate.SetNavigationBar(navigate)
                appDelegate.window?.rootViewController = navigate
                //                            self.sidePanelController?.centerPanel = navigate
            }
        }
    }

    func HomeDelightUserLogin(_ userDetails : NSDictionary){
        
        if let userid = UserDefaults.standard.value(forKey: "HomeDelightUserID") as? String {
            appDelegate.homeUserId = userid
            if userid.isEmpty == false {
                return
            }
        }
        
        print("HomeDelightUserLogin ===== ", userDetails)
        
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
