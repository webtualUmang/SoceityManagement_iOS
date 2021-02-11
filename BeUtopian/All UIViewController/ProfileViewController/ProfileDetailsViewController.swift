//
//  ProfileDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 18/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController,didEditProfileDelegate {

    @IBOutlet var lblFirstName : UILabel!
    @IBOutlet var lblLastName : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblEmail : UILabel!
    
    @IBOutlet var lblOccupation : UILabel!
    @IBOutlet var lblWeb : UILabel!
    @IBOutlet var lblAbout : UILabel!
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var sideimage : UIImageView!
    var ProfileResult = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        
        self.navigationItem.title = "My Profile"
        // Do any additional setup after loading the view.
        let rightBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action:#selector(self.EditProfile))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        DispatchQueue.main.async {
            self.GetProfile()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    @objc func EditProfile(){
        let objRoot = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        objRoot.ProfileResult = NSDictionary(dictionary: self.ProfileResult)
        objRoot.delegate = self
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
    func SetUserProfileData(_ data : NSDictionary){
        self.ProfileResult = NSDictionary(dictionary: data)
        
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
        if let tempStr = data.object(forKey: "email") as? String {
            self.lblEmail.text = tempStr
        }
        if let tempStr = data.object(forKey: "dob") as? String {
            self.lblPhone.text = tempStr
        }
//        if let tempStr = data.objectForKey("soc_name") as? String {
//            self.lblSocietyName.text = tempStr
//        }
        if let tempStr = data.object(forKey: "occupation") as? String {
            self.lblOccupation.text = tempStr
        }
        if let tempStr = data.object(forKey: "web") as? String {
            self.lblWeb.text = tempStr
        }
        if let tempStr = data.object(forKey: "about") as? String {
            self.lblAbout.text = tempStr
        }
        if let tempStr = data.object(forKey: "user_image") as? String
        {
            if tempStr.isEmpty == false {
                let urlString : URL = URL(string: tempStr)!
                self.profileImage.clipsToBounds = true
                self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                    if image != nil {
                        self.profileImage.image = image
                        self.profileImage.contentMode = .scaleAspectFill
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
                    }
                    
                })
                
            }
        }
        if let tempStr = data.object(forKey: "app_image") as? String
              {
                  if tempStr.isEmpty == false {
                      let urlString : URL = URL(string: tempStr)!
                      self.sideimage.clipsToBounds = true
                      self.sideimage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                          if image != nil {
                              self.sideimage.image = image
                            self.sideimage.contentMode = .scaleAspectFill
                            
                          }
                          
                      })
                      
                  }
              }
    }
    
    func GetUpdatedProfile() {
        self.GetProfile()
    }
    func GetProfile()
    {
        
        let urlStr = String(format: "%@?view=profile&page=user&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let resultList = ResultData.object(forKey: "user_detail_update") as? NSArray {
                                if resultList.count > 0 {
                                    if let data = resultList.object(at: 0) as? NSDictionary {
                                        print(data)
                                        DispatchQueue.main.async {
                                            setUserDetails(data)
                                            self.SetUserProfileData(data)
                                        }
                                        
                                    }
                                }
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
