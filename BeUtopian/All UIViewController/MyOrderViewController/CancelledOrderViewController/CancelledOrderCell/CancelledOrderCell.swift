//
//  CancelledOrderCell.swift
//  BeUtopian
//
//  Created by Nikunj on 13/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

protocol CancelledOrderCellDelegate
{
    func BtnReBookOrder(cell: CancelledOrderCell)
}

class CancelledOrderCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imgIcon: UIImageView!
    
    var delegate: CancelledOrderCellDelegate?
    var dataDic: NSDictionary?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BtnReBookOrderClick(sender: Any){
        if delegate != nil {
            delegate?.BtnReBookOrder(cell: self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
