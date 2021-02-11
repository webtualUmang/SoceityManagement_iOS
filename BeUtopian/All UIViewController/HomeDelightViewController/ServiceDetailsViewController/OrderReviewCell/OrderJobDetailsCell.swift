//
//  OrderJobDetailsCell.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class OrderJobDetailsCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblItemName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblItemPrice: UILabel!
    
    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.masksToBounds = false
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bgView.layer.shadowRadius = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
