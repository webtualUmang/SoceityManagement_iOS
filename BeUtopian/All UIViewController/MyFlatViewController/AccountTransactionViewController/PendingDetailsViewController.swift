//
//  PendingTransactionViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 10/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class PendingDetailsViewController: UIViewController {

    @IBOutlet var lblMsg1: UILabel!
    @IBOutlet var lblMsg2: UILabel!
    
    @IBOutlet var lblInvoiceNo: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblDueDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblAmount1: UILabel!
    @IBOutlet var lblDics: UILabel!

    @IBOutlet var BtnSendMail: UIButton!
    @IBOutlet var BtnHelp: UIButton!
    
    var invoiceID: String = ""
    var page = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        GetPendingDetails(appDelegate.FlatID)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegate.SetNavigationBar(self.navigationController!)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Invoice Detail"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func BtnSendEmailInvoiceClick(_ sender: AnyObject){
        SetEmailInvoice(appDelegate.EmailID)
    }
    
    @IBAction func BtnHelpClick(_ sender: AnyObject)
    {
       
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objRoot:SupportViewController = storyboard.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
        
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
    func CreateCell(_ Data : NSArray)
    {
        
        if let tempData = Data.object(at: 0) as? NSDictionary {
            
            if let tempStr = tempData.object(forKey: "message1") as? String {
                lblMsg1.text = tempStr
                
            }
            if let tempStr = tempData.object(forKey: "message2") as? String {
                lblMsg2.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "invoice_number") as? String {
                lblInvoiceNo.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "invoice_amount") as? String {
                lblAmount.text = String(format: "₹%@", arguments: [tempStr])
                lblAmount1.text = String(format: "₹%@", arguments: [tempStr])
            }
            if let tempStr = tempData.object(forKey: "due_date") as? String {
                
                lblDueDate.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "title") as? String {
                lblTitle.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "desc") as? String {
                lblDics.text = tempStr
            }
        }
    }
    

    
    //MARK:- Get Flat MemberList -
    func GetPendingDetails(_ flatId : String){
     
        
        let urlStr = String(format: "%@?view=income_invoice&page=%@&userID=%@&societyID=%@&flatID=%@&invoiceID=%@", arguments: [kMainDomainUrl,self.page,appDelegate.LoginUserID, appDelegate.SocietyID,flatId, invoiceID])
        print(urlStr)
        
        
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            print(ResultData)
                           if self.page == "completed_detail"
                            {
                                if let bannerList = ResultData.object(forKey: "income_list_completed") as? NSArray
                                {
                                    DispatchQueue.main.async
                                        {
                                        self.CreateCell(bannerList)
                                    }
                                }
                            }
                            else
                            {
                                if let bannerList = ResultData.object(forKey: "income_list_pending") as? NSArray
                                {
                                    DispatchQueue.main.async
                                        {
                                        self.CreateCell(bannerList)
                                    }
                                }
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

    //MARK:- SetEmailInvoice -
    func SetEmailInvoice(_ email : String){
  
        
        let urlStr = String(format: "%@?view=income_invoice&page=mail&userID=%@&societyID=%@&email=%@&invoiceID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,email, invoiceID])
        print(urlStr)
        
        
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            print(ResultData)
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
