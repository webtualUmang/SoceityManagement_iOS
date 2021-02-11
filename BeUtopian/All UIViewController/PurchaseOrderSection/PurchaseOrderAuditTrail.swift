//
//  PurchaseOrderAuditTrail.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class PurchaseOrderAuditTrail: UIViewController, UIGestureRecognizerDelegate, PurchaseAuditTrailCellDelegate {


    var TermsCell: NSMutableArray = NSMutableArray()
    @IBOutlet var tableview: UITableView!
    
    var releaseNumber : String?
    var isApproval: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "PurchaseAuditTrailCell", bundle: nil)
        self.tableview .register(nibName, forCellReuseIdentifier: "PurchaseAuditTrailCell")
        
        self.perform("setTableviewFrame")
//        self.performSelector("GetPurchaseOrderAuditDetails")
        self.perform("GetPurchaseOrderAuditDetails:", with: false)
        
        // Do any additional setup after loading the view.
    }
    func setTableviewFrame(){
        if self.isApproval != nil {
            if(self.isApproval == "Approved"){
                self.tableview.frame = self.view.bounds
            }
        }

    }
    //MARK:- GetPurchaseOrderAuditDetails -
    func GetPurchaseOrderAuditDetails(_ isComment : Bool)
    {
        
        var tempReleaseNumber = "0"
        if let tempStr = releaseNumber {
            tempReleaseNumber = tempStr
        }
       
        let urlStr = String(format: "%@/api/%@/PurchasingSystem/GetPurchaseOrderAuditDetails?releaseNumber=%@&companyID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,tempReleaseNumber,appDelegate.CompanyID])
        print(urlStr)
        
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
//                print(data)
                if let listData = data as? NSArray {
                    DispatchQueue.main.async {
                        self.CreateCell(listData, isComment: isComment)
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
    
    func CreateCell(_ listOfAuditData : NSArray, isComment : Bool){
        
        TermsCell = NSMutableArray()
        
        for item in listOfAuditData {
            
            if let data = item as? NSDictionary {
                let cell: PurchaseAuditTrailCell! = self.tableview.dequeueReusableCell(withIdentifier: "PurchaseAuditTrailCell") as? PurchaseAuditTrailCell
                cell.delegate = self
                cell.data = data
                
//                let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "labelAction:")
//                cell.lblDetail.addGestureRecognizer(tap)
//                cell.lblDetail.userInteractionEnabled = true
//                tap.delegate = self
                                
                TermsCell.add(cell)
            }
            
        }
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
            if isComment == true {
                if self.TermsCell.count > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.tableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
            
            
        }
    }

    
    
    
    //MARK: - Button Delegate Methods
    
    func BtnPurchaseAuditTrailCall(_ cell: PurchaseAuditTrailCell) {
        if let tempData = cell.data {
            if let tempStr = tempData.object(forKey: "Telephone") as? String {
                if tempStr.isEmpty == false {
                    let trimmedString = tempStr.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
                    
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
                    
                    
                }
                
            }
        }
        
    }
    
    // Receive action
    func labelAction(_ gr:UITapGestureRecognizer)
    {
        let searchlbl:UILabel = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
        print(searchlbl.text)
        
        let notify: JSNotifier = JSNotifier(title: "James Collins left a comment on - Purchase order - Ref: #2814757")
        notify.accessoryView = UIImageView(image: UIImage(named: "notifiicon"))
        notify.show()
    }
    
    //MARK: - TableView Delegate Method
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TermsCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        let cell = TermsCell.object(at: indexPath.row) as? PurchaseAuditTrailCell
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
