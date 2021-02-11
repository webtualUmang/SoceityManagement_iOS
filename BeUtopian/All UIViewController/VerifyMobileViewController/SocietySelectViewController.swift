//
//  SocietySelectViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 05/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class SocietySelectViewController: UIViewController, LBZSpinnerDelegate,BSKeyboardControlsDelegate {
    var keyboard: BSKeyboardControls!
    var blockResult = NSArray()
    var flatResult = NSArray()
    @IBOutlet var spinnerBlock : LBZSpinner!
    @IBOutlet var spinnerFlat : LBZSpinner!
    @IBOutlet var spinnerYouAre : LBZSpinner!
    
    @IBOutlet var lblSociety : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var txtUnit : UITextField!
    var areaResult : String = ""
    
    var blockID : String = ""
    var flat_typeID : String = ""
    var userType = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        keyboard = BSKeyboardControls(fields: [self.txtUnit])
        keyboard.delegate = self
        DispatchQueue.main.async {
            self.SetupSppiner()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Select your property"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let left = UIBarButtonItem(image: UIImage(named: "Back_button"), style: .plain, target: self, action: "BackClick")
        self.navigationItem.leftBarButtonItem = left
    }
    
    func BackClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func SetupSppiner(){
        if spinnerBlock != nil {
            var listResult : [String] = []
            
            for data in blockResult {
                if let tempData = data as? NSDictionary {
                    if let tempStr = tempData.object(forKey: "block_name") as? String {
                        listResult.append(tempStr)
                    }
                }
            }
            spinnerBlock.updateList(listResult)
            spinnerBlock.delegate = self
        }else{
            self.perform("SetupSppiner", with: nil, afterDelay: 0.1)
            return
        }
        
        if spinnerFlat != nil {
            var listResult : [String] = []
            
            for data in flatResult {
                if let tempData = data as? NSDictionary {
                    if let tempStr = tempData.object(forKey: "flat_type_name") as? String {
                        listResult.append(tempStr)
                    }
                }
            }
            spinnerFlat.updateList(listResult)
            spinnerFlat.delegate = self
        }
        
        if spinnerYouAre != nil {
            let listResult : [String] = ["owner","tenant"]
            
            spinnerYouAre.updateList(listResult)
            spinnerYouAre.delegate = self
        }
        
        if lblSociety != nil {
            if let tempStr = finalResult.object(forKey: "societyName") as? String {
                self.lblSociety.text = tempStr
            }
            if let tempStr = finalResult.object(forKey: "city_name") as? String {
                self.lblAddress.text = String(format: "%@, %@", arguments: [tempStr,selectedStateName])
            }
            
        }
    }
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String) {
        var spinnerName = ""
        if spinner == spinnerBlock { spinnerName = "customer" }
        
        print("Spinner : \(spinnerName) : { Index : \(index) - \(value) }")
        
        //GetFalts
        if spinner == spinnerFlat {
            self.flat_typeID = value
//            if flatResult.count > index {
//                if let tempData = flatResult.objectAtIndex(index) as? NSDictionary {
//                    if let tempStr = tempData.objectForKey("flat_typeID") as? String {
//                        self.flat_typeID = tempStr
//                    }
//                }
//            }
        }else if spinner == spinnerBlock {
            self.blockID = value
//            if blockResult.count > index {
//                if let tempData = blockResult.objectAtIndex(index) as? NSDictionary {
//                    if let tempStr = tempData.objectForKey("blockID") as? String {
//                        self.blockID = tempStr
//                    }
//                }
//            }
        }else if spinner == spinnerYouAre {
            self.userType = value
        }

        
    }
    func spinnerOpenClick() {
        print("open Click")
    }
    @IBAction func nextClick(_ sender : UIButton){
        self.finalizeSetup()
    }
    
    func finalizeSetup(){
        
        
        self.view.endEditing(true)
        var societyID = ""
        if let tempStr = finalResult.object(forKey: "societyID") as? String {
            societyID = tempStr
        }
        
        var societyName = ""
        if let tempStr = finalResult.object(forKey: "societyName") as? String {
            societyName = tempStr
        }
        
        var phone = ""
        if let tempStr = finalResult.object(forKey: "phone") as? String {
            phone = tempStr
        }
        var email = ""
        if let tempStr = finalResult.object(forKey: "email") as? String {
            email = tempStr
        }
        var first_name = ""
        if let tempStr = finalResult.object(forKey: "first_name") as? String {
            first_name = tempStr
        }
        var last_name = ""
        if let tempStr = finalResult.object(forKey: "last_name") as? String {
            last_name = tempStr
        }
        var flat_no = ""
        if let tempStr = self.txtUnit.text {
            flat_no = tempStr
        }
        
        if self.blockID.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please select your block")
            return
        }
        if self.flat_typeID.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please select flat type")
            return
        }
        if flat_no.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please enter flat no")
            return
        }
        if self.userType.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please select type")
            return
        }
        let paramStr = String(format: "societyID=%@&societyName=%@&phone=%@&email=%@&first_name=%@&last_name=%@&area=%@&blockID=%@&flat_typeID=%@&type=%@&flat_no=%@", arguments: [societyID,societyName,phone,email,first_name,last_name,self.areaResult,self.blockID,self.flat_typeID,self.userType,flat_no])
        
        
        let urlStr = String(format: "%@?view=join_society&page=join_society&%@", arguments: [kMainDomainUrl,paramStr])
        
//        let escapedString = urlStr.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        let escapedString = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed)
        
        print(urlStr)
        TNMWSMethod(nil, url: escapedString!, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
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
                                if let tempStr = finalResult.object(forKey: "phone") as? String {
                                    objRoot.mobileNumberStr = tempStr
                                }
                                
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                let objRoot: ThanksViewController = ThanksViewController(nibName: "ThanksViewController", bundle: nil)
                                
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }

//
//                            if let msgCode = userDetails.objectForKey("message") as? String {
//                                appDelegate.TNMErrorMessage(kAppName, message: msgCode)
//                            }
                            
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
