//
//  DemoNotesPopup.swift
//  BeUtopian
//
//  Created by Jeevan on 06/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit
protocol HeplPopupDelegate {
    func helpPopupClose()
}
class DemoNotesPopup: UIView {

    var delegate : HeplPopupDelegate?
    @IBOutlet var btnClose : UIButton!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var menuImage : UIImageView!
    @IBOutlet var lblMenu : UILabel!
    
    class func instanceFromNib() -> DemoNotesPopup {
        return UINib(nibName: "DemoNotesPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DemoNotesPopup
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
