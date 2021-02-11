//
//  MyFlatMemberViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 25/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class MyFlatMemberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    var ComplainsCells = NSMutableArray()
    @IBOutlet var tableView: UITableView!

    var popup: KOPopupView?
    var flatID : String = ""
    var data = NSDictionary()

    //Popup
    @IBOutlet var MemberView: UIView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var lblNodata: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "MyFlatMemberCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "MyFlatMemberCell")
        
        self.navigationItem.title = "My Flat"
        // Do any additional setup after loading the view.
        
//        GetFlatMemberList(flatID)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        GetFlatMemberList(appDelegate.FlatID)
    }
    
    @IBAction func BtnCloseViewClick(_ sender: AnyObject){
        popup?.hide(animated: true)
    }
    
    @IBAction func BtnEditClick(_ sender: AnyObject)
    {
        popup?.hide(animated: true)
      //  let rootObj: AddMyFlatMemberViewController = AddMyFlatMemberViewController(nibName: "AddMyFlatMemberViewController", bundle: nil)
     //   rootObj.data = data
      //  rootObj.isAdd = true
        
      //  self.navigationController?.pushViewController(rootObj, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:AddMyFlatMemberViewController = storyboard.instantiateViewController(withIdentifier: "AddMyFlatMemberViewController") as! AddMyFlatMemberViewController
        vc.data = data
        vc.isAdd = true
         self.navigationController?.pushViewController(vc, animated: true)
            
    }
    
    @IBAction func BtnDeleteClick(_ sender: AnyObject){
        popup?.hide(animated: true)
        
        print(data)
        if let strTemp = data.object(forKey: "FID") as? String {
            DeleteMember(strTemp)
        }
    }
    
    @IBAction func BtnAddMemberClick(_ sender: AnyObject)
    {
       // let rootObj: AddMyFlatMemberViewController = AddMyFlatMemberViewController(nibName: "AddMyFlatMemberViewController", bundle: nil)
//        rootObj.flatId = flatID
       // rootObj.isAdd = false
       // self.navigationController?.pushViewController(rootObj, animated: true)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc:AddMyFlatMemberViewController = storyboard.instantiateViewController(withIdentifier: "AddMyFlatMemberViewController") as! AddMyFlatMemberViewController
        vc.isAdd = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func OpenRegardPopups(){
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        
        var fname: String = ""
        var lname: String = ""
        
        if let strTemp = data.object(forKey: "Fname") as? String {
            fname = strTemp
        }
        if let strTemp = data.object(forKey: "Lname") as? String {
            lname = strTemp
        }
        lblName.text = String(format: "%@ %@", fname, lname)
        if let strTemp = data.object(forKey: "phone") as? String {
            lblNumber.text = strTemp
        }
        if let strTemp = data.object(forKey: "email") as? String {
            lblEmail.text = strTemp
        }
        if let strTemp = data.object(forKey: "gender") as? String {
            lblGender.text = strTemp
        }
        if let strTemp = data.object(forKey: "bday") as? String {
            lblDate.text = strTemp
        }

        
        popup?.handleView.addSubview(MemberView)
        
        MemberView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                        y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "MyFlatMemberCell") as? MyFlatMemberCell {
                    cell.data = tempData
                    
                    var Fname: String = ""
                    var Lname: String = ""
                    
                    if let tempStr = tempData.object(forKey: "Fname") as? String {
                        Fname = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "Lname") as? String {
                        Lname = tempStr
                    }
                
                    cell.lblName.text = String(format: "%@ %@", Fname, Lname)
                    
                    self.ComplainsCells.add(cell)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? MyFlatMemberCell {
                return cell.frame.size.height
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? MyFlatMemberCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? MyFlatMemberCell {
            
            data = cell.data!
            OpenRegardPopups()
        }
    }

    
    //MARK:- Get Flat MemberList -
    func GetFlatMemberList(_ flatId : String){
        

        
        let urlStr = String(format: "%@?view=my_flat&page=flat_members&userID=%@&societyID=%@&flatID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,flatId])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = true
                            }
                            if let bannerList = ResultData.object(forKey: "members") as? NSArray {
                                DispatchQueue.main.async {
                                    self.CreateCell(bannerList)
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.lblNodata.isHidden = false
                                self.ComplainsCells = NSMutableArray()
                                self.tableView.reloadData()
                            }
//                            if let messageStr = ResultData.objectForKey(kMessage) as? String {
//                                appDelegate.TNMErrorMessage("", message: messageStr)
//                            }
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
    
    //MARK: - Delete Member
    
    func DeleteMember(_ memberid: String){
   
        let urlStr = String(format: "%@?view=my_flat&page=delete_member&userID=%@&societyID=%@&flatID=%@&memberID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID, memberid])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            self.GetFlatMemberList(appDelegate.FlatID)
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
