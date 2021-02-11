//
//  DemoNotesPopup.swift
//  BeUtopian
//
//  Created by Jeevan on 06/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class GetStartedPopup: UIView {

    var delegate : HeplPopupDelegate?
   
    
    class func instanceFromNib() -> GetStartedPopup {
        return UINib(nibName: "GetStartedPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GetStartedPopup
    }
    override func awakeFromNib() {
        
    }
    @IBAction func closeClick(_ sender : UIButton){
        if self.delegate != nil {
            self.delegate?.helpPopupClose()
        }
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
