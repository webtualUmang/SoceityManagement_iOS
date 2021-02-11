//
//  MainCell.swift
//  BeUtopian
//
//  Created by desap on 13/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit


protocol MainCellDelegate {
    func BtnApprovedClick(_ cell: MainCell)
    func BtnAwaitingClick(_ cell: MainCell)
    func BtnLastApprovalClick(_ cell: MainCell)
}

class MainCell: UITableViewCell {

    @IBOutlet var lbltitle: UILabel!
    @IBOutlet var lbllastApproved: UILabel!
    
    @IBOutlet var btnApproved: UIButton!
    @IBOutlet var btnAwaiting: UIButton!
    
    @IBOutlet var imgicon: UIImageView!
    
    var data : NSDictionary?
    
    var delegate: MainCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func ApprovedClick(_ sender: AnyObject){
        self.delegate?.BtnApprovedClick(self)
    }
    
    @IBAction func AwaitingClick(_ sender: AnyObject){
        self.delegate?.BtnAwaitingClick(self)
    }
    
    @IBAction func LastApprovalClick(_ sender: AnyObject){
        self.delegate?.BtnLastApprovalClick(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
