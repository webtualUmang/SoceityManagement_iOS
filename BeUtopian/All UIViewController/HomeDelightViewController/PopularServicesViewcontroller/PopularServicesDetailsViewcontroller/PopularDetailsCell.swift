//
//  PopularDetailsCell.swift
//  BeUtopian
//
//  Created by Nikunj on 18/01/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class PopularDetailsCell: UITableViewCell {

    @IBOutlet var checkimg: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblNo: UILabel!
    
    var data = NSDictionary()
    var selectData = NSDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
