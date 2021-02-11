//
//  OrderTotalCell.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

protocol OrderTotalCellDelegate {
    func BtnTermAndCondition(cell: OrderTotalCell)
}

class OrderTotalCell: UITableViewCell {

    @IBOutlet var lblTotalPrice: UILabel!
    @IBOutlet var btnTerm: UIButton!
    
    var delegate: OrderTotalCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnTerm.set(image: #imageLiteral(resourceName: "uncheckbox"), title: btnTerm.titleLabel?.text! as! NSString, titlePosition: .right, additionalSpacing: 10, state: .normal)
    }
    
    @IBAction func BtnTermAndConditionClick(sender: Any){
        if delegate != nil {
            delegate?.BtnTermAndCondition(cell: self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
