//
//  DeskBoardCell.swift
//  BeUtopian
//
//  Created by Jeevan on 20/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DeskBoardCell: UICollectionViewCell {

    @IBOutlet var hdView : UIView!
    @IBOutlet var imgIcons : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblCounter : RoundCornerLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hdView.layer.cornerRadius = 10
               self.hdView.layer.shadowColor = UIColor.black.cgColor
               self.hdView.layer.shadowOffset = CGSize(width: 0, height: 0)
               self.hdView.layer.shadowOpacity = 0.2
               self.hdView.layer.shadowRadius = 4.0
        
        // Initialization code
    }

}
