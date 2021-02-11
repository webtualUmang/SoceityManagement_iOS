//
//  AddAddressViewController.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController, BSKeyboardControlsDelegate {

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtMobileNo: UITextField!
    @IBOutlet var txtLocation: UITextField!
    @IBOutlet var txtArea: UITextField!
    @IBOutlet var txtLandMark: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtPinCode: UITextField!
    
    @IBOutlet var btnAddress: UIButton!
    @IBOutlet var btnAhmedabad: UIButton!
    @IBOutlet var btnSurat: UIButton!
    
    var keyboard: BSKeyboardControls!
    var popup: KOPopupView?
    @IBOutlet var cityView: UIView!
 
    var arrAdd = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.tableHeaderView = headerView
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        keyboard = BSKeyboardControls(fields: [self.txtName,self.txtMobileNo,self.txtLocation,self.txtArea,self.txtLandMark,self.txtPinCode])
        keyboard.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.navigationItem.title = "Add Address"
        
        if self.navigationItem.title == "Update Address" {
            btnAddress.setTitle("Update Address", for: .normal)
        }
    }
    
    @IBAction func BtnPopupClick(sender: Any){
        self.view.endEditing(true)
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        popup?.handleView.addSubview(cityView)
        cityView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                    y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
    @IBAction func BtnSelectCityClick(sender: Any){
        
        let btnTag = sender as! UIButton
        
        if btnTag.tag == 0 {
            self.txtCity.text = "Ahmedabad"
        }
        else{
            self.txtCity.text = "Surat"
        }
        popup?.hide(animated: true)
    }
    
    @IBAction func BtnAddAddressClick(sender: Any){
        
        if self.txtName.text == "" {
            appDelegate.TNMErrorMessage("", message: "Enter Name")
            return
        }
        if self.txtLocation.text == "" {
            appDelegate.TNMErrorMessage("", message: "Enter Name")
            return
        }
        if self.txtArea.text == "" {
            appDelegate.TNMErrorMessage("", message: "Enter Area")
            return
        }
        if self.txtCity.text == "" {
            appDelegate.TNMErrorMessage("", message: "Select City")
            return
        }
        if self.txtMobileNo.text == "" {
            appDelegate.TNMErrorMessage("", message: "Enter Mobile Number")
            return
        }
        if self.txtPinCode.text == "" {
            appDelegate.TNMErrorMessage("", message: "Enter Pincode")
            return
        }
        
        let address = String(format: "%@\n%@,%@ - %@", arguments: [self.txtLocation.text!, self.txtArea.text!, txtCity.text!, self.txtPinCode.text!])
        
        let addressDics: NSDictionary = ["Name": self.txtName.text!, "MobileNo": self.txtMobileNo.text!, "Address":address]
        
        arrAdd.add(addressDics)
      
        self.AddNewAddress()
        
//        let dataStore = NSKeyedArchiver.archivedData(withRootObject: arrAdd)
//        UserDefaults.standard.set(dataStore, forKey: "AddressList")
//        UserDefaults.standard.synchronize()
//
//        self.navigationController?.popViewController(animated: true)
    }
    
    func AddNewAddress(){
        
        //{"user_id":"135","fullName":"Navin Thakur","mobileno":"9028001193","location":"pune","street_area":"pune","landmark":"pune","city_name":"Ahmedabad","pincode":"411017"}
        
        ProgressHUD.show("Loading...")
   
        
        let param: Parameters = ["user_id":appDelegate.homeUserId, "fullName":txtName.text!, "mobileno":txtMobileNo.text!, "location":txtLocation.text!, "street_area":txtArea.text!, "landmark":txtLandMark.text!, "city_name":txtCity.text!, "pincode":txtPinCode.text!]
        print(param)
        request(kAddUserAddress, method: .post, parameters: param, encoding: JSONEncoding(options: [])).responseJSON { (responseData) in
            
            print(responseData)
            ProgressHUD.dismiss()
            
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                if let resData = swiftyJsonVar.dictionary {
                    
                    if let strTemp = resData[kMessage]?.stringValue {
                        
                        if(strTemp.lowercased() == kSuccess){
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            appDelegate.TNMErrorMessage("", message: "Something went wrong please try again later.")
                        }
                    }
                    else{
                        appDelegate.TNMErrorMessage("", message: "Something went wrong please try again later.")
                    }
                }
            }
        }
    }
    
    // MARK: - Keyboard Event -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
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
            let edgeInsets  = UIEdgeInsets.init(top: 0, left: 0, bottom: (kbSize?.height)!, right: 0)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
