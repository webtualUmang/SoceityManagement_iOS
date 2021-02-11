//
//  ThanksViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 05/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    @IBOutlet var descLabel : UILabel!
    
    @IBAction func backToLogin(_ sender : UIButton){
        let objRoot: VerifyMobileViewController = VerifyMobileViewController(nibName: "VerifyMobileViewController", bundle: nil)
        let navigation = UINavigationController(rootViewController: objRoot)
        appDelegate.SetNavigationBar(navigation)
        appDelegate.window?.rootViewController = navigation
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.backgroundColor = NSTheme().GetNavigationBGColor()
      //  let attrs = [
         //   NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14),
          //  NSForegroundColorAttributeName : UIColor.black,
          //  NSUnderlineStyleAttributeName : 1] as [String : Any]
        
        let attribute = [NSAttributedString.Key.font :UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
       
        let bigString = "Once the society commitee verify the details, You will get Login Details by mail and SMS.\n\nif you have any questions about your account or any other matter, please feel free to contact us at "
        let attributedString3 = NSMutableAttributedString()
        attributedString3.append(NSMutableAttributedString(string: bigString))
        attributedString3.append(NSMutableAttributedString(string:"support@homedelight.com", attributes:attribute))
        
        attributedString3.append(NSMutableAttributedString(string: " or by phone at \n"))
        
//        let attrs1 = [
//            NSFontAttributeName : UIFont.systemFont(ofSize: 14.0),
//            NSForegroundColorAttributeName : NSTheme().GetNavigationBGColor(),
//            NSUnderlineStyleAttributeName : 1] as [String : Any]
//
        
         let attribute1 = [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 14.0),NSAttributedString.Key.foregroundColor :  NSTheme().GetNavigationBGColor(),NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        attributedString3.append(NSMutableAttributedString(string:"+91 70416 95499", attributes:attribute1))
        
        
        self.descLabel.attributedText = attributedString3
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
