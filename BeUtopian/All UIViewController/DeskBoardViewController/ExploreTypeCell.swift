//
//  ExploreTypeCell.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 05/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class ExploreTypeCell: UITableViewCell
{
    @IBOutlet weak var viewBack:UIView!
    
    override func awakeFromNib()
    {
        self.viewBack.layer.cornerRadius = 10
        self.viewBack.layer.shadowColor = UIColor.black.cgColor
        self.viewBack.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewBack.layer.shadowOpacity = 0.2
        self.viewBack.layer.shadowRadius = 4.0
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
