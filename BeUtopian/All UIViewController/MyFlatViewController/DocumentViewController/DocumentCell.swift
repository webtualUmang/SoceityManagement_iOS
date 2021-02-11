//
//  NieghbourCell.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

protocol DocumentCellDelegate {
    func BtnMoreOption(_ cell: DocumentCell)
}

class DocumentCell: UITableViewCell {

    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var userImage : UIImageView!
    var data : NSDictionary?
    
    @IBOutlet var btnMore: UIButton!
    var delegate: DocumentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BtnMoreOptionClick(_ sender: AnyObject){
        if(delegate != nil){
            delegate?.BtnMoreOption(self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
