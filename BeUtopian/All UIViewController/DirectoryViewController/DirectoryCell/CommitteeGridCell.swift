//
//  CommitteeGridCell.swift
//  BeUtopian
//
//  Created by TNM3 on 5/11/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class CommitteeGridCell: UICollectionViewCell {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var profileImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.adjustsFontSizeToFitWidth = true
        self.lblType.adjustsFontSizeToFitWidth = true
        
    }

}
