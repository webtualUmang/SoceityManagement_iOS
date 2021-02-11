//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {

    @IBOutlet var lblattendies : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblBrif : UILabel!
    @IBOutlet var lblShare : UILabel!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var lblMeetingNo : UILabel!
    
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
