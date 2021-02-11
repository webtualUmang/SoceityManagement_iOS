//
//  NieghbourCell.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class NieghbourCell: UITableViewCell {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDetails : UILabel!
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
