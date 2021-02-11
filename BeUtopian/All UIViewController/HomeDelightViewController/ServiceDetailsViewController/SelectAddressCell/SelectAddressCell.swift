//
//  SelectAddressCell.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

protocol SelectAddressCellDelegate {
    func BtnAddressDelete(cell: SelectAddressCell)
    func BtnAddressEdit(cell: SelectAddressCell)
    func BtnSelectAddress(cell: SelectAddressCell)
}

class SelectAddressCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPhoneNo: UILabel!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var bgView: UIView!
    
    var delegete: SelectAddressCellDelegate?
    var data = NSDictionary()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.masksToBounds = false
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bgView.layer.shadowRadius = 1
    }
    
    @IBAction func BtnAddressDeleteClick(sender: Any){
        if delegete != nil {
            delegete?.BtnAddressDelete(cell: self)
        }
    }
    
    @IBAction func BtnAddressEditClick(sender: Any){
        if delegete != nil {
            delegete?.BtnAddressEdit(cell: self)
        }
    }
    
    @IBAction func BtnSelectAddressClick(sender: Any){
        if delegete != nil {
            delegete?.BtnSelectAddress(cell: self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
