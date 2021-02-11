//
//  ScheduleDateCell.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class ScheduleDateCell: UICollectionViewCell {

    var data = NSDictionary()
    @IBOutlet var lblDay: UILabel!
    @IBOutlet var lblMonth: UILabel!
    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.cornerRadius = 2
        bgView.clipsToBounds = true
    }

}
