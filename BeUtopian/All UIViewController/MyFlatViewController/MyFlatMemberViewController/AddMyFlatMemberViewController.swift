//
//  AddMyFlatMemberViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 25/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class AddMyFlatMemberViewController: UIViewController,BSKeyboardControlsDelegate {

    @IBOutlet var BtnMale: UIButton!
    @IBOutlet var BtnFeMale: UIButton!
    @IBOutlet var BtnDate: UIButton!
    
    @IBOutlet var txtFname: UITextField!
    @IBOutlet var txtLname: UITextField!
    @IBOutlet var txtNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    var keyboard: BSKeyboardControls!

    var strGender: String?
    var datePicker : UIDatePicker = UIDatePicker()
    var flatId: String = ""
    var isAdd: Bool = false
    
    
    var data: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "My Flat"
        keyboard = BSKeyboardControls(fields: [txtFname,txtLname,txtNumber,txtEmail])
        keyboard.delegate = self
      
       
        if(isAdd == false){
            
            strGender = "Male"
            
            BtnMale.set(image: UIImage(named: "check_blue"), title: "Male", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            BtnFeMale.set(image: UIImage(named: "un_check"), title: "Female", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
        }
        else{
            SetData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let right = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(AddMyFlatMemberViewController.BtnPost))
        self.navigationItem.rightBarButtonItem = right
    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        view.endEditing(true)
    }
    @objc func BtnPost(){
        
        if(isAdd == true){
            
            if(txtEmail.text == ""){
                appDelegate.TNMErrorMessage("", message: "Please enter Email-Id")
                return
            }
            
            if let strTemp = data!.object(forKey: "FID") as? String {
                EditMember(strTemp)
            }
        }
        else{
            
            if(txtEmail.text == ""){
                appDelegate.TNMErrorMessage("", message: "Please enter Email-Id")
                return
            }
            
            AddFlatMember()
        }
    }
    
    func SetData(){
        
        if let strTemp = data!.object(forKey: "Fname") as? String {
            txtFname.text = strTemp
        }
        if let strTemp = data!.object(forKey: "Lname") as? String {
            txtLname.text = strTemp
        }
        
        if let strTemp = data!.object(forKey: "phone") as? String {
            txtNumber.text = strTemp
        }
        if let strTemp = data!.object(forKey: "email") as? String {
            txtEmail.text = strTemp
        }
        if let strTemp = data!.object(forKey: "gender") as? String {
            
            if(strTemp == "male"){
                
                strGender = "Male"
                
                BtnMale.set(image: UIImage(named: "check_blue"), title: "Male", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
                BtnFeMale.set(image: UIImage(named: "un_check"), title: "Female", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            }
            else{
                
                strGender = "Female"
                
                BtnFeMale.set(image: UIImage(named: "check_blue"), title: "Female", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
                BtnMale.set(image: UIImage(named: "un_check"), title: "Male", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            }
        }
        if let strTemp = data!.object(forKey: "bday") as? String {
            BtnDate.setTitle(strTemp, for: UIControl.State())
        }
    }

    @IBAction func BtnGenderClick(_ sender: AnyObject) {
        let btn = sender as? UIButton
        
        if(btn?.tag == 0){
            
            strGender = "Male"
            
            BtnMale.set(image: UIImage(named: "check_blue"), title: "Male", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            BtnFeMale.set(image: UIImage(named: "un_check"), title: "Female", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
        }
        else{
            
            strGender = "Female"
            
            BtnMale.set(image: UIImage(named: "un_check"), title: "Male", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            BtnFeMale.set(image: UIImage(named: "check_blue"), title: "Female", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
        }
    }
    
    @IBAction func BtnDateClick(_ sender: AnyObject) {

            let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: 200))
            viewDatePicker.backgroundColor = UIColor.clear
            
            
            self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        self.datePicker.datePickerMode = UIDatePicker.Mode.date
            
        self.datePicker.locale = Locale(identifier: "en_GB")
           
//            self.datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
//            self.datePicker.tag = tag
            
            viewDatePicker.addSubview(self.datePicker)
            
        let alertController = UIAlertController(title: "Set date", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
            
            alertController.view.addSubview(viewDatePicker)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Done", style: .default)
            { (action) in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let dates = dateFormatter.string(from: self.datePicker.date)
                self.BtnDate.setTitle(dates, for: UIControl.State())
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true)
            {
                // ...
            }
    }
    
    //MARK:- Add Flat Member -
    func AddFlatMember(){

        if(txtFname.text == ""){
            txtFname.text = "-"
        }
        if(txtLname.text == ""){
            txtLname.text = "-"
        }
        if(txtNumber.text == ""){
            txtNumber.text = "-"
        }
        if(txtEmail.text == ""){
            txtEmail.text = "-"
        }
        if(strGender == ""){
            strGender = "Male"
        }
        if(BtnDate.titleLabel?.text == "Select Here Your Birthdate"){
            BtnDate.titleLabel?.text = "00-00-0000"
        }
        
        
        let urlStr = String(format: "%@?view=my_flat&page=add_member&userID=%@&societyID=%@&flatID=%@&Fname=%@&Lname=%@&phone=%@&email=%@&gender=%@&bday=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID, txtFname.text!, txtLname.text!, txtNumber.text!, txtEmail.text!, strGender!, (BtnDate.titleLabel?.text)!])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
//                                appDelegate.TNMErrorMessage("", message: messageStr)
                                
                                let refreshAlert = UIAlertController(title: "", message: messageStr, preferredStyle: UIAlertController.Style.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                DispatchQueue.main.async {
                                    self.present(refreshAlert, animated: true, completion: nil)
                                }
                            }
                        }
                        else{
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
    
    //MARK: - Edit Member
    
    func EditMember(_ memberid: String){

        
        let urlStr = String(format: "%@?view=my_flat&page=edit_member&userID=%@&societyID=%@&flatID=%@&Fname=%@&Lname=%@&phone=%@&email=%@&gender=%@&bday=%@&memberID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID, txtFname.text!, txtLname.text!, txtNumber.text!, txtEmail.text!, strGender!, (BtnDate.titleLabel?.text)!, memberid])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                //                                appDelegate.TNMErrorMessage("", message: messageStr)
                                
                                let refreshAlert = UIAlertController(title: "", message: messageStr, preferredStyle: UIAlertController.Style.alert)
                                
                                refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }))
                                DispatchQueue.main.async {
                                    self.present(refreshAlert, animated: true, completion: nil)
                                }
                            }
                        }
                        else{
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
    
    // MARK: - Keyboard Event -
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        keyboard.activeField = textField
//        
//        //        let searchTerm = "hihell.df/"
//    }
//    func keyboardControls(keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
//        
//    }
//    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls) {
//        self.view.endEditing(true)
//    }

    
   
    
    
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
