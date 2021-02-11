//
//  PurchaseOrderLines.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class PurchaseOrderLines: UIViewController,PurchaseLineDelegate {

    
    var TermsCell: NSMutableArray = NSMutableArray()
    @IBOutlet var tableview: UITableView!
    var releaseNumber : String?
    var isApproval: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "PurchaseLineCell", bundle: nil)
        tableview .register(nibName, forCellReuseIdentifier: "PurchaseLineCell")
        
        self.perform("GetPurchaseOrderLinesByReleaseNumber")
        // Do any additional setup after loading the view.

        self.perform("setTableviewFrame")
    }
    func setTableviewFrame(){
        if self.isApproval != nil {
            if(self.isApproval == "Approved"){
                self.tableview.frame = self.view.bounds
            }
        }
        
    }
    
    //MARK:- GetPurchaseOrderLinesByReleaseNumber -
    func GetPurchaseOrderLinesByReleaseNumber()
    {
  
        var tempReleaseNumber = "0"
        if let tempStr = releaseNumber {
            tempReleaseNumber = tempStr
        }
        let urlStr = String(format: "%@/api/%@/PurchasingSystem/GetPurchaseOrderLinesByReleaseNumber?releaseNumber=%@&companyID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,tempReleaseNumber,appDelegate.CompanyID])
        
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let listData = data as? NSArray {
                    DispatchQueue.main.async {
                        self.CreateCell(listData)
                    }
                }else{
                    if let json = data as? NSDictionary {
                        if let messageStr = json.object(forKey: kMessage) as? String {
                            appDelegate.TNMErrorMessage("", message: messageStr)
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

    func ReloadMainTableView() {
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
    func CreateCell(_ listData : NSArray){
        
        TermsCell = NSMutableArray()
        
        for item in listData {
            
            if let dic = item as? NSDictionary {
                let cell: PurchaseLineCell! = self.tableview.dequeueReusableCell(withIdentifier: "PurchaseLineCell") as? PurchaseLineCell
                cell.delegate = self
                cell.lineData = dic
                //            if let description = dic?.objectForKey("Description") as? String {
                //                cell.lblDescription.text = description
                //            }
                
                TermsCell.add(cell)
                
            }
            
            
        }
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }

    
    //MARK: - TableView Delegate Method
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TermsCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        let cell = TermsCell.object(at: indexPath.row) as? PurchaseLineCell
        return cell!.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return TermsCell.object(at: indexPath.row) as! UITableViewCell
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
