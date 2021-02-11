//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var calanderimg: UIImageView!
    
    @IBOutlet var profilePic : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblType : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        calanderimg.image = calanderimg.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        calanderimg.tintColor = NSTheme().GetLabelBGColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
