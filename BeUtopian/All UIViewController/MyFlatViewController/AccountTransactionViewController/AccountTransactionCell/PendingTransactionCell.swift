//
//  PendingTransactionCell.swift
//  BeUtopian
//
//  Created by tnmmac4 on 12/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

protocol PendingTransactionCellDelegate {
    func BtnPayAmmount(_ cell: PendingTransactionCell)
}

class PendingTransactionCell: UITableViewCell {

    @IBOutlet var lblCategory: UILabel!
    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblInvoiceDate: UILabel!
    @IBOutlet var lblDueDate: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblAddedBy: UILabel!
    
    var data: NSDictionary?
    var delegate: PendingTransactionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func BtnPayAmmountClick(_ sender: AnyObject){
        if(delegate != nil){
            delegate?.BtnPayAmmount(self)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
