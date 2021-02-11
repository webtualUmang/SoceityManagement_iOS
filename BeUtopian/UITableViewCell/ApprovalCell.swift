//
//  AwaitingApprovalCell.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

protocol ApprovalCellDelegate {
    func BtnApprovalCall(_ cell: ApprovalCell)
}

class ApprovalCell: UITableViewCell
{
    @IBOutlet var lblSupplierName:UILabel!
    @IBOutlet var lblRefNo:UILabel!
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblRequestedBy:UILabel!
    @IBOutlet var lblOrderValue:UILabel!
    @IBOutlet var lblRequestDate:UILabel!
    @IBOutlet var viewGreyLine : UIView!
    @IBOutlet var statusImage : UIImageView!
    @IBOutlet var statusClockImage : UIImageView!
    
    var data : NSDictionary?
    
    var delegate: ApprovalCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    @IBAction func BtnCallClick(_ sender: AnyObject){
        delegate?.BtnApprovalCall(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
