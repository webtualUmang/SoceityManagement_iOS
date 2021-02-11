//
//  SelectSocityViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 20/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class SelectSocityViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var societyList : NSArray?
    var userMobileNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "SelectSocityCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "SelectSocityCell")
        
        //    self.perform("CreateCell", with: nil, afterDelay: 0.1)
        self.CreateCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Select Society"
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
    }
    
    func CreateCell(){
        
        ComplainsCells = NSMutableArray()
        if let lisOfData = societyList {
            for data in lisOfData {
                if let tempData = data as? NSDictionary {
                    let cell: SelectSocityCell! = self.self.tableView.dequeueReusableCell(withIdentifier: "SelectSocityCell") as? SelectSocityCell
                    if let tempStr = tempData.object(forKey: "societyName") as? String {
                        cell.lblTitle.text = tempStr
                    }else if let tempStr = tempData.object(forKey: "name") as? String {
                        cell.lblTitle.text = tempStr
                    }
                    
                    cell.data = tempData
                    ComplainsCells.add(cell)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        let cell = ComplainsCells.object(at: indexPath.row) as? SelectSocityCell
//        return cell!.frame.size.height
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? SelectSocityCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? SelectSocityCell {
            if let SaveData = cell.data {
                let newData = GetNewDicationary(SaveData)
                if let userId = newData.object(forKey: "userID") as? String {
                    appDelegate.LoginUserID = userId
                }
                if let socity = newData.object(forKey: "societyID") as? String {
                    appDelegate.SocietyID = socity
                }
                if let socity = newData.object(forKey: "id") as? String {
                    appDelegate.SocietyID = socity
                }
                
                self.TNMLogin()
                //                setLoginUser(newData)
                //                dispatch_async(dispatch_get_main_queue()) {
                //                    let objRoot: DeskBoardViewController = DeskBoardViewController(nibName: "DeskBoardViewController", bundle: nil)
                //                    let navigate = UINavigationController(rootViewController: objRoot)
                //                    appDelegate.SetNavigationBar(navigate)
                //                    self.sidePanelController?.centerPanel = navigate
                //                }
            }
        }
    }
    
    func TNMLogin()
    {
        var userMobile = ""
        if let tempStr = self.userMobileNumber {
            userMobile = tempStr
        }
        let urlStr = String(format: "%@?view=login&page=society&user=%@&society_id=%@", arguments: [kMainDomainUrl,userMobile,appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                
                print(data)
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let userData = userDetails.object(forKey: "select_society") as? NSArray {
                                
                                DispatchQueue.main.async {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let objRoot:SelectSocityViewController = storyboard.instantiateViewController(withIdentifier: "SelectSocityViewController") as! SelectSocityViewController
                                    
                                    
                                    
                                    
                               //     let objRoot: SelectSocityViewController = SelectSocityViewController(nibName: "SelectSocityViewController", bundle: nil)
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
                            //                            self.sidePanelController?.centerPanel = navigate
                            appDelegate.window?.rootViewController = navigate
                        }
                    }
                }else{
                    //                    isLoginSuccess = true
                    
                    DispatchQueue.main.async {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                       let objRoot:SelectSocityViewController = storyboard.instantiateViewController(withIdentifier: "SelectSocityViewController") as! SelectSocityViewController
                                        
                       // let objRoot: SelectSocityViewController = SelectSocityViewController(nibName: "SelectSocityViewController", bundle: nil)
                        objRoot.societyList = NSArray(array: userData)
                        let navigate = UINavigationController(rootViewController: objRoot)
                        appDelegate.SetNavigationBar(navigate)
                        //                        self.sidePanelController?.centerPanel = navigate
                        appDelegate.window?.rootViewController = navigate
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
