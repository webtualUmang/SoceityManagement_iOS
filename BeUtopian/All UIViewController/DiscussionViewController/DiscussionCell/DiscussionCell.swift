//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DiscussionCell: UITableViewCell {


    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblTile : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var lblReply : RoundCornerLabel!
    @IBOutlet var userImage : UIImageView!
    var data : NSDictionary?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
