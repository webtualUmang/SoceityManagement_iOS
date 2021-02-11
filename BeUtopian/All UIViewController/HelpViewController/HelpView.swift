//
//  HelpView.swift
//  synax
//
//  Created by TNM3 on 6/14/16.
//  Copyright © 2016 TNM3. All rights reserved.
//

import UIKit

class HelpView: UIView {

    @IBOutlet var helpImage : UIImageView!
    
    class func instanceFromNib() -> HelpView {
        return UINib(nibName: "HelpView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! HelpView
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
