//
//  ProfileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 18/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class MyFlatViewController: UIViewController,RegardingPopupDelegate {

    var popup: KOPopupView?
    var flatListResult = NSArray()
    var flatDetailsResult = NSArray()
    @IBOutlet var lblFlatName : UILabel!
    var flatID : String = ""
    
    //Flat Details
    @IBOutlet var lblMemberTitle : UILabel!
    @IBOutlet var lblMemberCount : UILabel!
    
    @IBOutlet var lblDocumentTitle : UILabel!
    @IBOutlet var lblDocumentCount : UILabel!
    
    @IBOutlet var lblVehicleTitle : UILabel!
    @IBOutlet var lblVehicletCount : UILabel!
    
    @IBOutlet var lblTransctionTitle : UILabel!
    @IBOutlet var lblTransctionCount : UILabel!
    
    @IBOutlet var lblVisitorTitle : UILabel!
    @IBOutlet var lblVisitorCount : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "My Flat"
        // Do any additional setup after loading the view.
        //self.perform("GetFlatList")
        self.GetFlatList()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    @IBAction func MyProfileClick(_ sender : UIButton){
         self.OpenRegardPopups()
    }
    @IBAction func MemberClick(_ sender : UIButton)
    {
        let objRoot = MyFlatMemberViewController(nibName: "MyFlatMemberViewController", bundle: nil)
        appDelegate.FlatID = self.flatID
        self.navigationController?.pushViewController(objRoot, animated: true)
        
        
     //   let storyboard = UIStoryboard(name: "Main", bundle: nil)
     //   let vc = storyboard.instantiateViewController(withIdentifier: "MyFlatMemberViewController")
     //   self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func DocumentClick(_ sender : UIButton){
        let objRoot = DocumentViewController(nibName: "DocumentViewController", bundle: nil)
        appDelegate.FlatID = self.flatID
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func VehicletClick(_ sender : UIButton){
        let objRoot = VehiclesListViewController(nibName: "VehiclesListViewController", bundle: nil)
        appDelegate.FlatID = self.flatID
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func TransactionClick(_ sender : UIButton){
        let objRoot = AccountTransactionViewController(nibName: "AccountTransactionViewController", bundle: nil)
        appDelegate.FlatID = self.flatID
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func VisitorClick(_ sender : UIButton){
        
        let objRoot = VisitorHistoryViewController(nibName: "VisitorHistoryViewController", bundle: nil)
        appDelegate.FlatID = self.flatID
        self.navigationController?.pushViewController(objRoot, animated: true)
    }

    
    
    //MARK:- Get Flat - 
    func GetFlatList(){
       
               let urlStr = String(format: "%@?view=my_flat&page=flat_list&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                           
                            if let bannerList = ResultData.object(forKey: "falt_no") as? NSArray {
                                DispatchQueue.main.async {
                                    self.flatListResult = NSArray(array: bannerList)
                                    if self.flatListResult.count > 0 {
                                        if let response = self.flatListResult.object(at: 0) as? NSDictionary {
                                            if let tempStr = response.object(forKey: "title") as? String {
                                                self.lblFlatName.text = tempStr
                                                
                                            }
                                            if let tempStr = response.object(forKey: "flatID") as? String {
                                                //SetDetails
                                                self.flatID = tempStr
                                                appDelegate.FlatID = tempStr
                                                self.GetFlatDetails(tempStr)
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                    
                                }
                                
                                
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

    //MARK:- Get Flat Details -
    func GetFlatDetails(_ flatId : String){
        
        let urlStr = String(format: "%@?view=my_flat&page=total_count1&userID=%@&societyID=%@&flatID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,flatId])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let bannerList = ResultData.object(forKey: "details") as? NSArray {
                                DispatchQueue.main.async {
                                    self.flatDetailsResult = NSArray(array: bannerList)
                                    self.setFlatDetails()
                                }
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
    func setFlatDetails(){
        for data in self.flatDetailsResult {
            if let tempData = data as? NSDictionary {
                if let tempStr = tempData.object(forKey: "sr") as? String {
                    //FirstLabel
                    if tempStr.caseInsensitiveCompare("1") == .orderedSame {
                        if let nameStr = tempData.object(forKey: "name") as? String {
                            self.lblMemberTitle.text = nameStr
                        }
                        if let countStr = tempData.object(forKey: "detail") as? String {
                            self.lblMemberCount.text = countStr
                        }
                        
                    }
                    //SecondLabel
                    if tempStr.caseInsensitiveCompare("2") == .orderedSame {
                        if let nameStr = tempData.object(forKey: "name") as? String {
                            self.lblDocumentTitle.text = nameStr
                        }
                        if let countStr = tempData.object(forKey: "detail") as? String {
                            self.lblDocumentCount.text = countStr
                        }
                        
                    }
                    //ThirdLabel
                    if tempStr.caseInsensitiveCompare("3") == .orderedSame {
                        if let nameStr = tempData.object(forKey: "name") as? String {
                            self.lblVehicleTitle.text = nameStr
                        }
                        if let countStr = tempData.object(forKey: "detail") as? String {
                            self.lblVehicletCount.text = countStr
                        }
                        
                    }
                    //FourthLabel
                    if tempStr.caseInsensitiveCompare("4") == .orderedSame {
                        if let nameStr = tempData.object(forKey: "name") as? String {
                            self.lblTransctionTitle.text = nameStr
                        }
                        if let countStr = tempData.object(forKey: "detail") as? String {
                            self.lblTransctionCount.text = countStr
                        }
                        
                    }
                    //FiveLabel
                    if tempStr.caseInsensitiveCompare("5") == .orderedSame {
                        if let nameStr = tempData.object(forKey: "name") as? String {
                            self.lblVisitorTitle.text = nameStr
                        }
                        if let countStr = tempData.object(forKey: "detail") as? String {
                            self.lblVisitorCount.text = countStr
                        }
                        
                    }
                }
            }
        }
    }

    func OpenRegardPopups(){
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        let mainFrame = UIScreen.main.bounds
        
        let regardView = CompainRegarding.instanceFromNib()
        regardView.resultKey = "title"
        regardView.lblTopTitle.text = "Select Flat"
        regardView.resultList = NSArray(array: self.flatListResult)
        regardView.CreateCell()
        regardView.delegate = self
        var frmView = regardView.bounds
        frmView.origin.x = 0
        frmView.origin.y = 0
        frmView.size.height = CGFloat((self.flatListResult.count * 44) + 60)//mainFrame.height - 100
        frmView.size.width = mainFrame.width - 60
        regardView.frame = frmView
        
        popup?.handleView.addSubview(regardView)
        
        regardView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
            y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    func SelectRegardOption(_ data: NSDictionary) {
        popup?.hide(animated: true)
        
        
        DispatchQueue.main.async {
            if let tempStr = data.object(forKey: "flatID") as? String {
                if self.flatID != tempStr {
                    self.GetFlatDetails(tempStr)
                }
                self.flatID = tempStr
                appDelegate.FlatID = tempStr
            }
            if let tempStr = data.object(forKey: "title") as? String {
                self.lblFlatName.text = tempStr
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
