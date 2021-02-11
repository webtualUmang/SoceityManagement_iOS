//
//  DeskBoardCell.swift
//  BeUtopian
//
//  Created by Jeevan on 20/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class BazzarCell: UICollectionViewCell {

    @IBOutlet var imgIcons : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblCounter : RoundCornerLabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.lblTitle.minimumScaleFactor = 0.5
        // Initialization code
    }

}
