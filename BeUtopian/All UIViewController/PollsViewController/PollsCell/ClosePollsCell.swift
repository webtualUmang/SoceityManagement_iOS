//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ClosePollsCell: UITableViewCell {

    @IBOutlet var lbldate : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDetail : UILabel!
    
    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
