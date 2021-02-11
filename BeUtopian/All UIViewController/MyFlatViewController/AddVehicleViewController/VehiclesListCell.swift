//
//  NieghbourCell.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

protocol VehiclesListCellDelegate {
    func BtnMoreOptions(_ cell: VehiclesListCell)
}

class VehiclesListCell: UITableViewCell {

    @IBOutlet var lblStickerNo : UILabel!
    @IBOutlet var lblModelNo : UILabel!
    @IBOutlet var lblVehicleNo : UILabel!
    @IBOutlet var bikeImage : UIImageView!
    var data : NSDictionary?
    var delegate: VehiclesListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func BtnMoreClick(_ sender: AnyObject){
        if(delegate != nil){
            delegate?.BtnMoreOptions(self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
