//
//  SettingsVC.swift
//  BeUtopian
//
//  Created by desap on 13/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.GetActiveCompanies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Settings"
        appDelegate.SetNavigationBar(self.navigationController!)
    }

    @IBAction func devloperInfo(_ sender : UIButton){
        UIApplication.shared.openURL(URL(string: "http://desap.co.uk/")!)
    }
    
    func GetActiveCompanies(){
        let urlStr = String(format: "%@/api/%@/Companies/GetActiveCompanies", arguments: [kMainDomainUrl,appDelegate.ClientTag])
        
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
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
