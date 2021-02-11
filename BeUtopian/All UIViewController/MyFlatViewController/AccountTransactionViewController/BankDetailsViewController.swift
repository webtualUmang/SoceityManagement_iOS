//
//  PendingTransactionViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 10/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class BankDetailsViewController: UIViewController {

    @IBOutlet var lblTotalAmount: UILabel!
    @IBOutlet var lblMsg1: UILabel!
    @IBOutlet var lblMsg2: UILabel!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAccount: UILabel!
    @IBOutlet var lblBankName: UILabel!
    @IBOutlet var lblBranch: UILabel!
    @IBOutlet var lblIFSC: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCity: UILabel!

    @IBOutlet var BtnCopy: UIButton!
    
    var invoiceID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        PayAmmountDetails()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        appDelegate.SetNavigationBar(self.navigationController!)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Bank Detail"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func BtnCopyDetailClick(_ sender: AnyObject){

        screenShotMethod()
        appDelegate.TNMErrorMessage("", message: "Bank Detail Copy!")
    }
    
    func screenShotMethod() {
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
    }
    
    func CreateCell(_ Data : NSArray){
        
        if let tempData = Data.object(at: 0) as? NSDictionary {
            
            if let tempStr = tempData.object(forKey: "amount") as? String {
                lblTotalAmount.text = String(format: "₹%@", arguments: [tempStr])
            }
            if let tempStr = tempData.object(forKey: "header1") as? String {
                lblMsg1.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "header2") as? String {
                lblMsg2.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "name") as? String {
                lblName.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "account") as? String {
                lblAccount.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "bank_name") as? String {
                lblBankName.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "branch") as? String {
                lblBranch.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "ifsc") as? String {
                lblIFSC.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "type") as? String {
                lblType.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "address") as? String {
                lblAddress.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "city") as? String {
                lblCity.text = tempStr
            }
        }
    }
    

    
    //MARK:- Get Flat MemberList -
    func PayAmmountDetails(){
        

        
        let urlStr = String(format: "%@?view=invoice_pay&page=pay&userID=%@&societyID=%@&invoiceID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID, invoiceID])
        print(urlStr)
        
        
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "1" {
                            
                            print(ResultData)
                            
                            if let bannerList = ResultData.object(forKey: "account_list") as? NSArray {
                                DispatchQueue.main.async {
                                    self.CreateCell(bannerList)
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
