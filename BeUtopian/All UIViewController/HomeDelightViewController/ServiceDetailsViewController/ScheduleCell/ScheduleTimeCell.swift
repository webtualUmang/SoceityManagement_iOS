//
//  ScheduleCell.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class ScheduleTimeCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgCheck: UIImageView!
    
    var data = NSDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
