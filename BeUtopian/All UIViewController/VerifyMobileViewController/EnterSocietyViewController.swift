//
//  VerifyMobileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 02/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class EnterSocietyViewController: UIViewController,BSKeyboardControlsDelegate {

    var keyboard: BSKeyboardControls!
    
    @IBOutlet var txtOTP : UITextField!
    
    @IBAction func verifyClick(_ sender : UIButton){
        self.InsertFinalResult()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = NSTheme().GetNavigationBGColor()
       
        
        keyboard = BSKeyboardControls(fields: [self.txtOTP])
        keyboard.delegate = self
       
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    @IBAction func backClick(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func InsertFinalResult()
    {
        
        
        if(self.txtOTP.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter society name.")
            return
        }
        finalResult.setObject(self.txtOTP.text!, forKey: "societyName" as NSCopying)
        let param = serializeParams(finalResult)
        self.view.endEditing(true)
        
        
        let urlStr = String(format: "%@?view=join&page=join&%@", arguments: [kMainDomainUrl,param])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
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
                                if let phoneStr = finalResult.object(forKey: "phone") as? String {
                                    objRoot.mobileNumberStr = phoneStr
                                }else{
                                    objRoot.mobileNumberStr = ""
                                }
                                
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }
                            
                        }else{
                            if let msgCode = userDetails.object(forKey: "message") as? String {
                                appDelegate.TNMErrorMessage(kAppName, message: msgCode)
                            }
                            
                        }
                    }
                    
                }
                
                
            }else{
                if let json = data as? NSDictionary {
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
