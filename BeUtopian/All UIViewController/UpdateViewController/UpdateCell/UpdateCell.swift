//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class UpdateCell: UITableViewCell {

    
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet var profilePic : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    var data = NSDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profilePic.clipsToBounds = true
         self.viewBack.layer.cornerRadius = 10
              self.viewBack.layer.shadowColor = UIColor.black.cgColor
              self.viewBack.layer.shadowOffset = CGSize(width: 0, height: 0)
              self.viewBack.layer.shadowOpacity = 0.2
              self.viewBack.layer.shadowRadius = 4.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
