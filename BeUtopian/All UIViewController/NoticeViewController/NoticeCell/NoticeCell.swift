//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblNoticeNo: UILabel!
    @IBOutlet var imageNotice : UIImageView!

    var data : NSDictionary?
    @IBOutlet var calanderimg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        calanderimg.image = calanderimg.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        calanderimg.tintColor = AppColor.SECONDRY_COLOR
        self.lblDesc.numberOfLines = 3
        self.lblDesc.sizeToFit()
        //        let maskPath = UIBezierPath(roundedRect: lblStatus.bounds, byRoundingCorners: ([.TopLeft, .BottomLeft]), cornerRadii: CGSizeMake(5.0, 5.0))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.lblStatus.bounds
//        maskLayer.path = maskPath.CGPath
//        lblStatus.layer.mask = maskLayer

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
