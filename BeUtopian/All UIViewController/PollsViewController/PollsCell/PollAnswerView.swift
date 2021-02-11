//
//  PollAnswerView.swift
//  BeUtopian
//
//  Created by tnmmac4 on 04/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class PollAnswerView: UIView {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tickimages: UIImageView!
    
    class func instanceFromNib() -> PollAnswerView {
        return UINib(nibName: "PollAnswerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PollAnswerView
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
