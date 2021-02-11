//
//  VendorDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 29/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class VendorDetailsViewController: UIViewController {

    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblArea : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var userPhoto : UIImageView!
    
    @IBOutlet var btnStar1 : UIButton!
    @IBOutlet var btnStar2 : UIButton!
    @IBOutlet var btnStar3 : UIButton!
    @IBOutlet var btnStar4 : UIButton!
    @IBOutlet var btnStar5 : UIButton!
    
    var resultData : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            
            self.SetResult()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if let data = resultData {
            if let tempStr = data.object(forKey: "cat_name") as? String {
                if tempStr.isEmpty == false {
                    self.navigationItem.title = tempStr
                }
                
            }
            
        }
        
    }

    
    func SetResult(){
        if self.userPhoto != nil {
            self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.height / 2
            self.userPhoto.clipsToBounds = true

            
            if let tempData = self.resultData {
                if let tempStr = tempData.object(forKey: "service_title") as? String {
                    self.lblTitle.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "name") as? String {
                    self.lblName.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "phone") as? String {
                    self.lblPhone.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "area") as? String {
                    self.lblArea.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "address") as? String {
                    self.lblAddress.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "email") as? String {
                    self.lblEmail.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "service_detail") as? String {
                    self.lblDetails.text = tempStr
                    self.lblDetails.sizeToFit()
                    self.footerView.frame.size.height = self.lblDetails.frame.size.height + 25
                }
                if let tempStr = tempData.object(forKey: "rate") as? String {
                    self.SetStart(tempStr)
                }
                
                if let tempStr = tempData.object(forKey: "image") as? String {
                    if tempStr.isEmpty == false {
                        let urlString : URL = URL(string: tempStr)!
                        self.userPhoto.clipsToBounds = true
                        self.userPhoto.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil {
                                self.userPhoto.image = image
                            }
                            
                        })
                        
                    }
                }
            }
            self.tableView.tableHeaderView = self.headerView
            self.tableView.tableFooterView = self.footerView
            
        }else{
            self.perform("SetResult", with: nil, afterDelay: 0.2)
        }
        
    }
    func SetStart(_ rate : String){
        self.btnStar1.isHidden = false
        self.btnStar2.isHidden = false
        self.btnStar3.isHidden = false
        self.btnStar4.isHidden = false
        self.btnStar5.isHidden = false
        
        if rate == "1" {
            self.btnStar1.isHidden = false
            self.btnStar2.isHidden = true
            self.btnStar3.isHidden = true
            self.btnStar4.isHidden = true
            self.btnStar5.isHidden = true
        }else if rate == "2" {
            self.btnStar1.isHidden = false
            self.btnStar2.isHidden = false
            self.btnStar3.isHidden = true
            self.btnStar4.isHidden = true
            self.btnStar5.isHidden = true
        }else if rate == "3" {
            self.btnStar1.isHidden = false
            self.btnStar2.isHidden = false
            self.btnStar3.isHidden = false
            self.btnStar4.isHidden = true
            self.btnStar5.isHidden = true
        }else if rate == "4" {
            self.btnStar1.isHidden = false
            self.btnStar2.isHidden = false
            self.btnStar3.isHidden = false
            self.btnStar4.isHidden = false
            self.btnStar5.isHidden = true
        }else if rate == "5" {
            self.btnStar1.isHidden = false
            self.btnStar2.isHidden = false
            self.btnStar3.isHidden = false
            self.btnStar4.isHidden = false
            self.btnStar5.isHidden = false
        }else{
            self.btnStar1.isHidden = true
            self.btnStar2.isHidden = true
            self.btnStar3.isHidden = true
            self.btnStar4.isHidden = true
            self.btnStar5.isHidden = true
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
