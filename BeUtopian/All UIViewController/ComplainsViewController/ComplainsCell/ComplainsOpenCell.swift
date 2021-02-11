//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ComplainsOpenCell: UITableViewCell {

    @IBOutlet var status : UILabel!
//    @IBOutlet var lblStatus : UIView!
//    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDesc : UILabel!
//    @IBOutlet var lblReply : UILabel!
    @IBOutlet var lblTicketNo : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblCatagory : UILabel!
    var data : NSDictionary?

    override func awakeFromNib()
    {
        lblCatagory.layer.cornerRadius = lblCatagory.frame.height / 2
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
