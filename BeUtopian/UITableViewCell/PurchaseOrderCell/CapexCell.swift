//
//  CapexCell.swift
//  BeUtopian
//
//  Created by TNM3 on 11/9/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class CapexCell: UITableViewCell {

    @IBOutlet var RequestedType : UILabel!
    @IBOutlet var CustomerName : UILabel!
    @IBOutlet var HireRate : UILabel!
    @IBOutlet var PeriodOfHire : UILabel!
    @IBOutlet var Carriage : UILabel!
    @IBOutlet var PaybackPeriod : UILabel!
    @IBOutlet var CapitalFactor : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.CustomerName.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
