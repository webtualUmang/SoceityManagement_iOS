//
//  CompletedTransactionViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 10/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class CompletedTransactionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var ComplainsCells = NSMutableArray()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblNodata: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "PendingTransactionCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "PendingTransactionCell")
        
        GetCompleteList(appDelegate.FlatID)
        
        // Do any additional setup after loading the view.
    }
    
    func CreateCell(_ resultList : NSArray)
       {
           
           ComplainsCells = NSMutableArray()
           for data in resultList {
               if let tempData = data as? NSDictionary {
                   if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "PendingTransactionCell") as? PendingTransactionCell {
                       cell.data = tempData
                     //  cell.delegate = self
                       
                       if let tempStr = tempData.object(forKey: "category") as? String {
                           cell.lblCategory.text = tempStr
                           cell.lblCategory.adjustsFontSizeToFitWidth = true
                       }
                       if let tempStr = tempData.object(forKey: "number") as? String {
                           cell.lblNumber.text = tempStr
                       }
                       if let tempStr = tempData.object(forKey: "title") as? String {
                           cell.lblTitle.text = tempStr
                       }
                       if let tempStr = tempData.object(forKey: "amount") as? String {
                           cell.lblAmount.text = String(format: "₹%@", arguments: [tempStr])
                       }
                       if let tempStr = tempData.object(forKey: "invoice_date") as? String {
                           
                           cell.lblInvoiceDate.text = String(format: "%@", arguments: [tempStr])
                       }
                       if let tempStr = tempData.object(forKey: "due_date") as? String {
                           cell.lblDueDate.text = String(format: "%@", arguments: [tempStr])
                       }
                       if let tempStr = tempData.object(forKey: "status") as? String {
                           cell.lblStatus.text = String(format: "%@", arguments: [tempStr])
                       }
                       if let tempStr = tempData.object(forKey: "added_by") as? String {
                           cell.lblAddedBy.text = tempStr
                       }
                       
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
            if let cell = ComplainsCells.object(at: indexPath.row) as? PendingTransactionCell {
                return cell.frame.size.height
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? PendingTransactionCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
       {
           tableView.deselectRow(at: indexPath, animated: true)
           if let cell = tableView.cellForRow(at: indexPath) as? PendingTransactionCell {
               
              // let rootObj: PendingDetailsViewController = PendingDetailsViewController(nibName: "PendingDetailsViewController", bundle: nil)
               
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let objRoot:PendingDetailsViewController = storyboard.instantiateViewController(withIdentifier: "PendingDetailsViewController") as! PendingDetailsViewController
            objRoot.page = "completed_detail"
               if let tempStr = cell.data!.object(forKey: "incomeID") as? String {
                   objRoot.invoiceID = tempStr
               }
               
               self.navigationController?.pushViewController(objRoot, animated: true)
           }
       }
    
    
    //MARK:- Get Flat MemberList -
    func GetCompleteList(_ flatId : String){

        
        let urlStr = String(format: "%@?view=income_invoice&page=completed&userID=%@&societyID=%@&flatID=%@&pagecode=0", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,flatId])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            self.lblNodata.isHidden = true
                            if let bannerList = ResultData.object(forKey: "income_list") as? NSArray
                            {
                                DispatchQueue.main.async
                                    {
                                     self.CreateCell(bannerList)
                                }
                            }
                        }
                        else{
                            self.lblNodata.isHidden = false
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
