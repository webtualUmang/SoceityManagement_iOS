//
//  alertListCellTableViewCell.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 05/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class alertListCellTableViewCell: UITableViewCell
{
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var imgType:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewBack.layer.cornerRadius = 10
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
