//
//  AddMyFlatMemberViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 25/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class AddVehiclesViewController: UIViewController, BSKeyboardControlsDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var BtnTwo: UIButton!
    @IBOutlet var BtnFour: UIButton!
    
    @IBOutlet var txtVehicleNo: UITextField!
    @IBOutlet var txtStickerNo: UITextField!
    @IBOutlet var txtModel: UITextField!
    
    var strType: String?
    var flatId: String = ""
    var isAdd: Bool = false
    
    var keyboard: BSKeyboardControls!
    
    var data: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Add Vehicle"
        
        keyboard = BSKeyboardControls(fields: [txtVehicleNo,txtStickerNo,txtModel])
        keyboard.delegate = self
        
        if(isAdd == false){
            
            strType = "2_wheeler"
            
            BtnTwo.set(image: UIImage(named: "check_blue"), title: "Two Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            BtnFour.set(image: UIImage(named: "un_check"), title: "Four Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
        }
        else{
            SetData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let right = UIBarButtonItem(title: "Post", style: .plain, target: self, action:#selector(self.BtnPost) )
        self.navigationItem.rightBarButtonItem = right
    }
    
    @objc func BtnPost(){
        
        if(isAdd == true){
            print(data)
            if let strTemp = data!.object(forKey: "vehicle_ID") as? String {
                EditVehicle(strTemp)
            }
        }
        else{
            
            if(txtVehicleNo.text == ""){
                appDelegate.TNMErrorMessage("", message: "Please enter vechicle Number")
                return
            }
            
            AddVehicle()
        }
    }
    
    func SetData(){
        
        if let strTemp = data!.object(forKey: "vehicle_no") as? String {
            txtVehicleNo.text = strTemp
        }
        if let strTemp = data!.object(forKey: "sticker_no") as? String {
            txtStickerNo.text = strTemp
        }
        
        if let strTemp = data!.object(forKey: "make_model") as? String {
            txtModel.text = strTemp
        }

        if let strTemp = data!.object(forKey: "type") as? String {
            
            if(strTemp == "2_wheeler"){
                
                strType = "2_wheeler"
                
                BtnTwo.set(image: UIImage(named: "check_blue"), title: "Two Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
                BtnFour.set(image: UIImage(named: "un_check"), title: "Four Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            }
            else{
                
                strType = "4_wheeler"
                
                BtnTwo.set(image: UIImage(named: "un_check"), title: "Two Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
                BtnFour.set(image: UIImage(named: "check_blue"), title: "Four Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            }
        }
    }

    @IBAction func BtnTypeClick(_ sender: AnyObject) {
        let btn = sender as? UIButton
        
        if(btn?.tag == 0){
            
            strType = "2_wheeler"
            
            BtnTwo.set(image: UIImage(named: "check_blue"), title: "Two Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            BtnFour.set(image: UIImage(named: "un_check"), title: "Four Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
        }
        else{
            
            strType = "4_wheeler"
            
            BtnTwo.set(image: UIImage(named: "un_check"), title: "Two Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
            BtnFour.set(image: UIImage(named: "check_blue"), title: "Four Wheeler", titlePosition: .right, additionalSpacing: 15, state: UIControl.State())
        }
    }
    
    @IBAction func BtnDateClick(_ sender: AnyObject) {
            
        let alertController = UIAlertController(title: "Set date", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
            
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Done", style: .default)
            { (action) in
                
               
            }
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true)
            {
                // ...
            }
    }
    
    //MARK:- Add Flat Member -
    func AddVehicle(){


        
        if(txtVehicleNo.text == ""){
            txtVehicleNo.text = "-"
        }
        if(txtStickerNo.text == ""){
            txtStickerNo.text = "-"
        }
        if(txtModel.text == ""){
            txtModel.text = "-"
        }
        if(strType == ""){
            strType = "2_wheeler"
        }
        
        
        let urlStr = String(format: "%@?view=my_parking&page=add_vehicle&userID=%@&societyID=%@&flatID=%@&vehicle_no=%@&sticker_no=%@&make_model=%@&type=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID,txtVehicleNo.text!, txtStickerNo.text!, txtModel.text!, strType!])
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
    
    func EditVehicle(_ vehicleid: String){

        
        
       let urlStr = String(format: "%@?view=my_parking&page=edit_vehicle&userID=%@&societyID=%@&flatID=%@&vehicle_ID=%@&vehicle_no=%@&sticker_no=%@&make_model=%@&type=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID,vehicleid,txtVehicleNo.text!, txtStickerNo.text!, txtModel.text!, strType!])
        
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

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        view.endEditing(true)
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
