//
//  BazaarListViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 28/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class VendorListViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var resultData : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nibName = UINib(nibName: "VendorListCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "VendorListCell")
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if let data = resultData {
            if let tempStr = data.object(forKey: "name") as? String {
                if tempStr.isEmpty == false {
                    self.navigationItem.title = tempStr
                }
                
            }
            
        }
        self.perform("GetNoticeBoard")
    }
    
    @IBAction func BtnAddVendorClick(_ sender: AnyObject){
        let rootObj: AddVendorViewController = AddVendorViewController(nibName: "AddVendorViewController", bundle: nil)
        rootObj.resultData = resultData
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "VendorListCell") as? VendorListCell {
                    cell.data = tempData
                    self.ComplainsCells.add(cell)
                }
                
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        if let cell = ComplainsCells.object(at: indexPath.row) as? VendorListCell {
            return cell.frame.size.height
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? VendorListCell {
                return cell
            }
        }
        return UITableViewCell()
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? VendorListCell {
            if let tempData = cell.data {
                let objRoot: VendorDetailsViewController = VendorDetailsViewController(nibName: "VendorDetailsViewController", bundle: nil)
                objRoot.resultData = tempData
                self.navigationController?.pushViewController(objRoot, animated: true)
            }
        }
        
    }
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard()
    {
        var catagoryId = "0"
        if let data = resultData {
            if let tempStr = data.object(forKey: "catID") as? String {
                catagoryId = tempStr
                
            }
            
        }
        
        let urlStr = String(format: "%@?view=vendor&page=vendorlist&userID=%@&societyID=%@&catID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,catagoryId])
        //        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"49", "1","0"])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "vendor_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.CreateCell(bannerList)
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
