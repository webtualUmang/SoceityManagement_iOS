//
//  AwaitingApprovalCell.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

protocol AwaitingApprovalCellDelegate {
    func BtnAwaitingCall(_ cell: AwaitingApprovalCell)
    func BtnApproved(_ cell: AwaitingApprovalCell)
    func BtnDecline(_ cell: AwaitingApprovalCell)
}

class AwaitingApprovalCell: UITableViewCell
{
    @IBOutlet var lblSupplierName:UILabel!
    @IBOutlet var lblRefNo:UILabel!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblRequestedBy:UILabel!
    @IBOutlet var lblOrderValue:UILabel!
    @IBOutlet var lblRequestDate:UILabel!
    
    @IBOutlet var btnApprove: UIButton!
    @IBOutlet var btnDecline: UIButton!
    var data : NSDictionary?
    
    var delegate: AwaitingApprovalCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func BtnCallClick(_ sender: AnyObject){
        delegate?.BtnAwaitingCall(self)
    }
    
    @IBAction func BtnApprovedClick(_ sender: AnyObject){
        delegate?.BtnApproved(self)
    }
    
    @IBAction func BtnDeclineClick(_ sender: AnyObject){
        delegate?.BtnDecline(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
