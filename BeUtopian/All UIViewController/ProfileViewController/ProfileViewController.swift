//
//  ProfileViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 18/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var lblFirstName : UILabel!
    @IBOutlet var lblLastName : UILabel!
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var viewProflie:UIView!
    @IBOutlet var viewInfo:UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = "My Profile"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.SetUserProfileData()
    }
    @IBAction func MyProfileClick(_ sender : UIButton){
        let objRoot = ProfileDetailsViewController(nibName: "ProfileDetailsViewController", bundle: nil)
        
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func SocietyClick(_ sender : UIButton){
        let objRoot: SocietyViewController = SocietyViewController(nibName: "SocietyViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func MyFlatClick(_ sender : UIButton){
//        let objRoot: MyFlatViewController = MyFlatViewController(nibName: "MyFlatViewController", bundle: nil)
//        self.navigationController?.pushViewController(objRoot, animated: true)
        
    }
    @IBAction func NotificationClick(_ sender : UIButton)
    {
        let objRoot: UpdateViewController = UpdateViewController(nibName: "UpdateViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
        
        
      //  let objRoot: NotificationViewController = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
      //  self.navigationController?.pushViewController(objRoot, animated: true)
        
    }
    @IBAction func ResetPassClick(_ sender : UIButton){
        let objRoot: ResetPasswordViewController = ResetPasswordViewController(nibName: "ResetPasswordViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func SignOutClick(_ sender : UIButton){
        
        let alertview = UIAlertController(title: "", message: "Do you want to logout?", preferredStyle: .alert)
        
        let NoAction = UIAlertAction(title: "No", style: .cancel) { (alert) in
            
        }
        
        let YesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            
            let objRoot: VerifyMobileViewController = VerifyMobileViewController(nibName: "VerifyMobileViewController", bundle: nil)
            let navigation = UINavigationController(rootViewController: objRoot)
            appDelegate.SetNavigationBar(navigation)
            appDelegate.window?.rootViewController = navigation
            RemoveLoginUser()
        }
        
        alertview.addAction(NoAction)
        alertview.addAction(YesAction)
        
        present(alertview, animated: true, completion: nil)
    }
    
    func SetUserProfileData()
    {
        if getUserDetails().count > 0
        {
            let data = getUserDetails()
            
            var strFName: String = ""
            var strLName: String = ""
            
            if let tempStr = data.object(forKey: "f_name") as? String {
                strFName = tempStr
            }
            if let tempStr = data.object(forKey: "l_name") as? String {
                strLName = tempStr
            }
            self.lblFirstName.text = String(format: "%@ %@", strFName, strLName)

            if let tempStr = data.object(forKey: "phone") as? String {
                self.lblLastName.text = tempStr
            }
            
            if let tempStr = data.object(forKey: "user_image") as? String {
                if tempStr.isEmpty == false {
                    let urlString : URL = URL(string: tempStr)!
                    self.profileImage.clipsToBounds = true
                    self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                        if image != nil {
                            self.profileImage.image = image
                        }
                        
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                    })
                    
                }
            }
        }
        else
        {
            let data = getLoginUser()
            
            var strFName: String = ""
            var strLName: String = ""
            
            if let tempStr = data.object(forKey: "firstname") as? String {
                strFName = tempStr
            }
            if let tempStr = data.object(forKey: "lastname") as? String {
                strLName = tempStr
            }
            self.lblFirstName.text = String(format: "%@ %@", strFName, strLName)

            if let tempStr = data.object(forKey: "phone") as? String {
                self.lblLastName.text = tempStr
            }
            
            if let tempStr = data.object(forKey: "userimage") as? String {
                if tempStr.isEmpty == false {
                    let urlString : URL = URL(string: tempStr)!
                    self.profileImage.clipsToBounds = true
                    self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                        if image != nil {
                            self.profileImage.image = image
                        }
                        
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
                    })
                    
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
