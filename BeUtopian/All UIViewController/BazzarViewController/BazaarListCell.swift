//
//  BazaarListCell.swift
//  BeUtopian
//
//  Created by Jeevan on 28/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class BazaarListCell: UITableViewCell {
    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var lblStatus : UILabel!
    
    @IBOutlet var btnStar1 : UIButton!
    @IBOutlet var btnStar2 : UIButton!
    @IBOutlet var btnStar3 : UIButton!
    @IBOutlet var btnStar4 : UIButton!
    @IBOutlet var btnStar5 : UIButton!
    var data : NSDictionary?{
        didSet{
            self.SetResult()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func SetResult(){
        if self.profileImage != nil {
            if let tempData = self.data {
                if let tempStr = tempData.object(forKey: "title") as? String {
                    self.lblName.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "time_ago") as? String {
                    self.lblPhone.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "price") as? String {
                    
                    self.lblCity.text = String(format: "₹ %@", arguments: [tempStr])
                }
//                if let tempStr = tempData.objectForKey("rate") as? String {
//                    self.SetStart(tempStr)
//                }
                if let tempStr = tempData.object(forKey: "type") as? String {
                    self.lblStatus.text = tempStr
                }
                
                if let tempStr = tempData.object(forKey: "main_image") as? String {
                    if tempStr.isEmpty == false {
                        let urlString : URL = URL(string: tempStr)!
                        self.profileImage.clipsToBounds = true
                        self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil {
                                self.profileImage.image = image
                            }
                            
                        })
                        
                    }
                }
            }
        }else{
            self.perform(#selector(self.SetStart(_:)), with: nil, afterDelay: 0.2)
        }
        
    }
   @objc func SetStart(_ rate : String)
    {
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
