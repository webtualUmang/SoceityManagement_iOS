//
//  PurchaseOrderDetails.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class PurchaseOrderDetails: UIViewController, PurchaseDetailsCellDelegate {


    var TermsCell: NSMutableArray = NSMutableArray()
    @IBOutlet var tableview: UITableView!
    var isApproval: String?
    
    var PurchaseOrderData : NSDictionary?
    var releaseNumber : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "PurchaseDetailsCell", bundle: nil)
        self.tableview .register(nibName, forCellReuseIdentifier: "PurchaseDetailsCell")
        
        DispatchQueue.main.async {
            self.CreateCell()
            
        }
        
//        self.performSelector("setTableviewFrame")
        // Do any additional setup after loading the view.
    }
    func setTableviewFrame(){
        if self.isApproval != nil {
            if(self.isApproval == "Approved"){
                self.tableview.frame = self.view.bounds
            }
        }
        
    }
    func CreateCell(){
        
        TermsCell = NSMutableArray()
        
        if let data = self.PurchaseOrderData {
            let cell: PurchaseDetailsCell! = self.tableview.dequeueReusableCell(withIdentifier: "PurchaseDetailsCell") as? PurchaseDetailsCell
            cell.delegate = self
            print(data)
            cell.data = data
           
            cell.viewController = self
            TermsCell.add(cell)
         
            
            //Set Order Status
            /* Old Conditional Code
            if let data = self.PurchaseOrderData {
//                print(data)
                if let isApproved = data.objectForKey("IsApproved") as? NSNumber {
                    if isApproved == 1 {
                        self.performSelector("setTableviewFrame")
                    }else {
                        if let isApproved = data.objectForKey("IsDeclined") as? NSNumber {
                            if isApproved == 1 {
                                self.performSelector("setTableviewFrame")
                            }
                        }
                    }
                }
                
            }
            */
            //New Conditional Code
            self.perform("setTableviewFrame")
        }
        
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
        
    }
    
    //Cell delegate
    func reloadTableviewSize(_ cell: PurchaseDetailsCell) {
        DispatchQueue.main.async {
            self.TermsCell = NSMutableArray()
            self.TermsCell.add(cell)
            self.tableview.reloadData()
        }
        
    }
    
    
    //MARK: - Button Delegate Methods
    
    func BtnPurchaseDetailsCall(_ cell: PurchaseDetailsCell) {
        
        if let tempData = cell.data {
            if let tempStr = tempData.object(forKey: "RequestedEmployeeTelephone") as? String {
                self.iPhoneCall(tempStr)
            }else if let tempStr = tempData.object(forKey: "RequestedEmployeeTelephone") as? NSNumber {
                self.iPhoneCall(tempStr.stringValue)
            }
        }

    }
    func iPhoneCall(_ phoneNumber : String){
        if phoneNumber.isEmpty == false {
            let trimmedString = phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let telStr = String(format: "telprompt://%@", arguments: [trimmedString])
            print(telStr)
            
            if let url = URL(string: telStr) {
                if(UIApplication.shared.canOpenURL(url)){
                    UIApplication.shared.openURL(url)
                }
                else{
                    let alert: UIAlertView = UIAlertView(title: "Alert", message: "Call facility is not available!!!", delegate: nil, cancelButtonTitle: "ok")
                    alert.show()
                }
            }
            
            
        }else{
            appDelegate.TNMErrorMessage("", message: "This user currently has no phone number setup")
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
        let cell = TermsCell.object(at: indexPath.row) as? PurchaseDetailsCell
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
