//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet var LocationImg: UIImageView!
    @IBOutlet var timeImg: UIImageView!
    @IBOutlet var lblMobile : UILabel!
    @IBOutlet var imgBanner: UIImageView!

    @IBOutlet var lblDayMonth : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblTitle : UILabel!

    @IBOutlet var lblVenue : UILabel!
    var data : NSDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LocationImg.image = LocationImg.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        LocationImg.tintColor = AppColor.PRIMARY_COLOR
        
        timeImg.image = timeImg.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        timeImg.tintColor = AppColor.PRIMARY_COLOR
        
        self.lblDate.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
