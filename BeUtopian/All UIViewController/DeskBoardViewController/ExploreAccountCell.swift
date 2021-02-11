//
//  ExploreAccountCell.swift
//  BeUtopian
//
//  Created by TNM3 on 5/4/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit
protocol ExploreAccountDelegate {
    func didSelectIndex(_ index : Int, data : NSDictionary)
}
class ExploreAccountCell: UITableViewCell {

    var delegate : ExploreAccountDelegate?
    
    @IBOutlet var lblFlat : UILabel!
    @IBOutlet var lblDue : UILabel!
    @IBOutlet var lblCompleted : UILabel!
    @IBOutlet var lblInvoice : UILabel!
    @IBOutlet weak var viewBack:UIView!
    
    var data = NSDictionary()
    
    override func awakeFromNib()
    {
        self.viewBack.layer.cornerRadius = 10
        self.viewBack.layer.shadowColor = UIColor.black.cgColor
        self.viewBack.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewBack.layer.shadowOpacity = 0.2
        self.viewBack.layer.shadowRadius = 4.0
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func InvoiceClick(){
        if self.delegate != nil {
            self.delegate?.didSelectIndex(0, data: self.data)
        }
    }
    @IBAction func completedClick(){
        if self.delegate != nil {
            self.delegate?.didSelectIndex(2, data: self.data)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
