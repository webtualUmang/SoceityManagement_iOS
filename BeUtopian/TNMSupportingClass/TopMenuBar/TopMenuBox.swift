//
//  TopMenuBox.swift
//  StretfordEnd
//
//  Created by TNM3 on 6/2/16.
//  Copyright © 2016 shoebpersonal. All rights reserved.
//

import UIKit

class TopMenuBox: UIView {

    @IBOutlet var menuButton : UIButton!
    @IBOutlet var menuLine : UIView!
    
    
    class func instanceFromNib() -> TopMenuBox {
        return UINib(nibName: "TopMenuBox", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TopMenuBox
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
