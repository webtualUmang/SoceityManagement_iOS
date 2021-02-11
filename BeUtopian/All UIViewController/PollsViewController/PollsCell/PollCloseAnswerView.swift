//
//  PollAnswerView.swift
//  BeUtopian
//
//  Created by tnmmac4 on 04/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class PollCloseAnswerView: UIView {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblVote: UILabel!
    @IBOutlet var Percentage: UIView!
    
    class func instanceFromNib() -> PollCloseAnswerView {
        return UINib(nibName: "PollCloseAnswerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PollCloseAnswerView
    }
    override func awakeFromNib() {
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
