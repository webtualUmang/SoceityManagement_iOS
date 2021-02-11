//
//  LeftMenuCell.swift
//  BeUtopian
//
//  Created by desap on 13/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!

    @IBOutlet var leftImage: UIImageView!
    
    @IBOutlet var downline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
//        lbldot.layer.cornerRadius = lblcount.frame.size.height / 2
//        lbldot.clipsToBounds = true
//        self.performSelector("setCountLabelFrame")
        // Initialization code
    }
    func setCountLabelFrame(){
//        self.lblcount.sizeToFit()
       
        
        //Check Device
        var lblCountframe = self.lblTitle.frame
        if UIDevice().modelName == "iPhone 6" {
            lblCountframe.origin.x = 215
        }else if UIDevice().modelName == "iPhone 6 Plus" {
            lblCountframe.origin.x = 215
        }else if UIDevice().modelName == "iPhone 7" {
            lblCountframe.origin.x = 215
        }else if UIDevice().modelName == "iPhone 7 Plus" {
            lblCountframe.origin.x = 215
        }else if UIDevice().modelName == "iPhone SE" {
            lblCountframe.origin.x = 215
        }else {
            lblCountframe.origin.x = 185
        }
        self.lblTitle.frame = lblCountframe
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
