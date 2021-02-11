//
//  StateViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 03/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class CitySocietyViewController: UIViewController {

    
    @IBOutlet var tableview : UITableView!

    var ComplainsCells = NSMutableArray()
    var resultData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "StateCell", bundle: nil)
        self.tableview .register(nibName, forCellReuseIdentifier: "StateCell")
        
        self.GetCityResult()
//        self.performSelector("GetCityResult", withObject: nil, afterDelay: 0.1)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Select Society"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let left = UIBarButtonItem(image: UIImage(named: "Back_button"), style: .plain, target: self, action: "BackClick")
        self.navigationItem.leftBarButtonItem = left
    }
    
    func BackClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func GetCityResult()
    {

        var stateId = "0"
        if let tempStr = resultData.object(forKey: "cityID") as? String {
            stateId = tempStr
        }else if let tempStr = resultData.object(forKey: "cityID") as? NSNumber {
            stateId = tempStr.stringValue
        }
        
        let urlStr = String(format: "%@?view=society_list&page=list&cityID=%@", arguments: [kMainDomainUrl,stateId])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let stateResult = userDetails.object(forKey: "society_list") as? NSArray {
                                DispatchQueue.main.async {
                                    self.CreateCell(stateResult)
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                
                                let objRoot: EnterSocietyViewController = EnterSocietyViewController(nibName: "EnterSocietyViewController", bundle: nil)
                                
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }
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

    
    func CreateCell(_ resultList : NSArray){
        
        if self.tableview != nil {
            ComplainsCells = NSMutableArray()
            
            for data in resultList {
                if let tempData = data as? NSDictionary {
                    if let cell = self.tableview.dequeueReusableCell(withIdentifier: "StateCell") as? StateCell {
                        if let tempStr = tempData.object(forKey: "society_name") as? String {
                            cell.lableTitle.text = tempStr
                        }
                        cell.data = tempData
                        ComplainsCells.add(cell)
                    }
                    
                }
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }else{
            self.perform("CreateCell", with: nil, afterDelay: 0.1)
        }
        
    }


    //MARK: - TableView Delegate Method
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? StateCell {
                return cell.frame.size.height
            }
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? StateCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? StateCell {
            DispatchQueue.main.async {
                if let tempData = cell.data {
                    var societyName = ""
                    if let tempStr = tempData.object(forKey: "society_name") as? String {
                        societyName = tempStr
                    }
                    var societyId = ""
                    if let tempStr = tempData.object(forKey: "societyID") as? String {
                        societyId = tempStr
                    }
                    var areaStr = ""
                    if let tempStr = tempData.object(forKey: "area") as? String {
                        areaStr = tempStr
                    }
                    self.InsertFinalResult(societyName, soceityID: societyId, areaStr: areaStr)
                }
                
            }
            
        }
    }
    func SocietyNotRegistered(_ data : NSDictionary){
        let objRoot: OTPViewController = OTPViewController(nibName: "OTPViewController", bundle: nil)
        if let otpStr = data.object(forKey: "otp") as? String {
            objRoot.resultOTP = otpStr
        }
        if let otpStr = data.object(forKey: "otp") as? NSNumber {
            objRoot.resultOTP = otpStr.stringValue
        }
        if let phoneStr = finalResult.object(forKey: "phone") as? String {
            objRoot.mobileNumberStr = phoneStr
        }else{
            objRoot.mobileNumberStr = ""
        }
        
        self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
    }
    func InsertFinalResult(_ societyName : String, soceityID : String, areaStr : String)
    {
        
        finalResult.setObject(societyName, forKey: "societyName" as NSCopying)
        finalResult.setObject(soceityID, forKey: "societyID" as NSCopying)
        
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
                                
                                if soceityID == "0" || soceityID.isEmpty == true {
                                    self.SocietyNotRegistered(userDetails)
                                }else{
                                    DispatchQueue.main.async {
                                        
                                        let objRoot: SocietySelectViewController = SocietySelectViewController(nibName: "SocietySelectViewController", bundle: nil)
                                        if let blockResult = userDetails.object(forKey: "society_blocks") as? NSArray {
                                            objRoot.blockResult = NSArray(array: blockResult)
                                        }
                                        if let blockResult = userDetails.object(forKey: "society_flat_types") as? NSArray {
                                            objRoot.flatResult = NSArray(array: blockResult)
                                        }
                                        objRoot.areaResult = areaStr
                                        self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                        
                                    }
                                    
                                    
                                }
                               
                                
                            }
                            
                        }else{
                            DispatchQueue.main.async {
                                let objRoot: ThanksViewController = ThanksViewController(nibName: "ThanksViewController", bundle: nil)
                                
                                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                                
                            }
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
