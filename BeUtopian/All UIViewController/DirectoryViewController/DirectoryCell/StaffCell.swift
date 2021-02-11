//
//  StaffCell.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit
protocol StaffCellDelegate {
    func callMemberClic(_ data : NSDictionary)
}
class StaffCell: UITableViewCell {

    var delegate : StaffCellDelegate?
    
    @IBOutlet var lblCatagory : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblBadge : UILabel!
    @IBOutlet var lblNotes : UILabel!
    
    @IBOutlet var profileImage : UIImageView!
    var data : NSDictionary?
    
    @IBAction func phoneClick(){
        if delegate != nil {
            if let tempData = data {
                self.delegate?.callMemberClic(tempData)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
