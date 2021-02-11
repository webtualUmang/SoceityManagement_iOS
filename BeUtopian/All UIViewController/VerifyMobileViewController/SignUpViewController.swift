//
//  VerifyMobileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 02/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, BSKeyboardControlsDelegate {

    var keyboard: BSKeyboardControls!
    @IBOutlet var txtName : UITextField!
    @IBOutlet var txtEmail : UITextField!
    @IBOutlet var txtMobile : UITextField!
    var mobileNumberStr : String = ""
    var StateResult = NSArray()
    
    @IBAction func verifyClick(_ sender : UIButton){
//        StateViewController
        self.InsertEmailResult()
    }
    @IBAction func backClick(_ sender : UIButton){
        self.navigationController?.popFadeViewController()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.txtName.text = "mike"
//        self.txtEmail.text = "mike@gmail.com"
        self.view.backgroundColor = NSTheme().GetNavigationBGColor()
        // Do any additional setup after loading the view.
        keyboard = BSKeyboardControls(fields: [self.txtName,self.txtEmail])
        keyboard.delegate = self
        
        self.GetStateResult()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.txtMobile.text = self.mobileNumberStr
        self.txtMobile.isEnabled = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func SetupFinalResult(){
        finalResult.setObject(mobileNumberStr, forKey: "phone" as NSCopying)
        finalResult.setObject(mobileNumberStr, forKey: "other_phone" as NSCopying)
        finalResult.setObject(self.txtName.text!, forKey: "first_name" as NSCopying)
        finalResult.setObject(self.txtEmail.text!, forKey: "email" as NSCopying)
    }
    func InsertEmailResult()
    {
        var nameStr = ""
        if let tempStr = self.txtName.text {
            nameStr = tempStr
        }
        if nameStr.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please enter your name.")
            return
        }

        
        var emailStr = ""
        if let tempStr = self.txtEmail.text {
            emailStr = tempStr
        }
        if emailStr.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please enter email address.")
            return
        }

        self.view.endEditing(true)
        self.SetupFinalResult()
        
        let urlStr = String(format: "%@?view=app_download&apptype=member&memail=%@", arguments: [kMainDomainUrl,emailStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async {
                                let objRoot: StateViewController = StateViewController(nibName: "StateViewController", bundle: nil)
                                objRoot.stateResult = NSArray(array: self.StateResult)
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }
                        }
                    }
                    
                }
                
                //                if isLoginSuccess == false {
                //                     appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                //                }
                
            }else{
                if data is NSDictionary {
                    appDelegate.TNMErrorMessage(kAppName, message: kSomethingWrongMessage)
                    
                }
                
            }
        }
        
    }
    
    func GetStateResult()
    {

        let urlStr = String(format: "%@?view=state&page=list", arguments: [kMainDomainUrl])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let stateResult = userDetails.object(forKey: "state_list") as? NSArray {
                                self.StateResult = NSArray(array: stateResult)
                            }                            
                        }
                    }
                    
                }
                
                //                if isLoginSuccess == false {
                //                     appDelegate.TNMErrorMessage(kAppName, message: "Invalid Email or Password, Please check your details and try again.")
                //                }
                
            }else{
                if data is NSDictionary {
                    appDelegate.TNMErrorMessage(kAppName, message: kSomethingWrongMessage)
                    
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
