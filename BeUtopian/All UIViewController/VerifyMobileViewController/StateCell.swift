//
//  StateCell.swift
//  BeUtopian
//
//  Created by Jeevan on 03/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class StateCell: UITableViewCell {

    @IBOutlet var lableTitle : UILabel!
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
