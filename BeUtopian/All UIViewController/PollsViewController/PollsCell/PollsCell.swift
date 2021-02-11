//
//  ComplainsOpenCell.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

protocol PollsCellDelegate {
    func SetResultsData(_ cell: PollsCell)
    func SetVotesData(_ cell: PollsCell)
}

class PollsCell: UITableViewCell {

    @IBOutlet var lbldate : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDetail : UILabel!
    @IBOutlet var btnvote : UIButton!
    
    @IBOutlet var bgView: UIView!
    var delegate: PollsCellDelegate?
    var data: NSDictionary?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func BtnResultClick(_ sender: AnyObject){
        if(delegate != nil){
            delegate?.SetResultsData(self)
        }
    }
    
    @IBAction func BtnVotesClick(_ sender: AnyObject){
        if(delegate != nil){
            delegate?.SetVotesData(self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
