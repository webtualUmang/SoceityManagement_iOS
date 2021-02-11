//
//  VisitorHistoryViewController.swift
//  BeUtopian
//
//  Created by tnmmac4 on 30/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class VisitorHistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GetVisitorHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Visitor History"
        
//        self.navigationController?.navigationBar.translucent = true
//        appDelegate.SetNavigationBar(self.navigationController!)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

    }
    
    //MARK:- GetVisitorHistory -
    func GetVisitorHistory(){
      
        
        let urlStr = String(format: "%@?view=visitor&page=list&userID=%@&societyID=%@&Flat_id=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                //                                appDelegate.TNMErrorMessage("", message: messageStr)

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
