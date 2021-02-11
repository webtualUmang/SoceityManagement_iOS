//
//  NieghbourDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class NieghbourDetailsViewController: UIViewController {
//    var neighbourID : String? {
//        didSet{
//            self.GetNoticeBoard()
//        }
//    }
    var neighbourID = ""
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblFlats : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblOccupation : UILabel!
    @IBOutlet var lblWeb : UILabel!
    @IBOutlet var lblSocial : UILabel!
    @IBOutlet var lblCommittee : UILabel!
    @IBOutlet var lblAbout : UILabel!
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var lblHeader : UILabel!
    @IBOutlet var lblAddress : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetNoticeBoard()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Directory"
        
    }
    func SetProfileResult(_ result : NSDictionary)
    {
        var address = ""
        if let tempStr = result.object(forKey: "name") as? String
        {
           // self.lblName.text = tempStr
            self.lblHeader.text = tempStr
        }
        if let tempStr = result.object(forKey: "flats") as? String {
            self.lblFlats.text = tempStr
            address = address + "" + "\(tempStr)"
        }
        if let tempStr = result.object(forKey: "phone") as? String {
            self.lblPhone.text = tempStr
        }
        if let tempStr = result.object(forKey: "occupation") as? String {
                   self.lblOccupation.text = tempStr
                   address = address + ", " + "\(tempStr)\n"

               }
        if let tempStr = result.object(forKey: "email") as? String {
            self.lblEmail.text = tempStr
            address = address + ", " + "\(tempStr)"
        }
        self.lblAddress.text = address
       
        if let tempStr = result.object(forKey: "web_address") as? String {
            self.lblWeb.text = tempStr
        }
        if let tempStr = result.object(forKey: "social_address") as? String {
            self.lblSocial.text = tempStr
        }
        if let tempStr = result.object(forKey: "in_committee") as? String {
            self.lblCommittee.text = tempStr
        }
        if let tempStr = result.object(forKey: "profile_pic") as? String {
            if tempStr.isEmpty == false {
                let urlString : URL = URL(string: tempStr)!
                self.profileImage.clipsToBounds = true
                self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                    if image != nil {
                        self.profileImage.contentMode = .scaleAspectFill
                        self.profileImage.image = image
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
                    }
                    
                })
                
            }
        }
        if let tempStr = result.object(forKey: "about") as? String {
            self.lblAbout.text = tempStr
            self.lblAbout.sizeToFit()
          
        }
     
    }
    func GetNoticeBoard()
    {
        
        var idStr = "0"
        
        idStr = self.neighbourID
    
        let urlStr = String(format: "%@?view=neighbour&page=tab1&userID=%@&societyID=%@&neighbourID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,idStr])
       
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "neighbour_detail") as? NSArray {
                                DispatchQueue.main.async {
                                    if bannerList.count > 0 {
                                        if let resultTemp  = bannerList.object(at: 0) as? NSDictionary {
                                            print(resultTemp)
                                            self.SetProfileResult(resultTemp)
                                        }
                                    }
                                    
//
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
