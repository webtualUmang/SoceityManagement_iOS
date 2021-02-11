//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class FacilityCell: UITableViewCell {

    @IBOutlet var lblStatus : UILabel!
    @IBOutlet var lblFacilityName : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var lblBookingFrom : UILabel!
    @IBOutlet var lblBookingTo : UILabel!
    @IBOutlet var lblAmount : UILabel!
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
