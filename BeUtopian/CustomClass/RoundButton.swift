//
//  Round.swift
//  BeUtopian
//
//  Created by desap on 10/26/15.
//  Copyright © 2015 desap. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor: UIColor? {
        didSet {
            backgroundColor = bgColor
            
        }
    }
    @IBInspectable var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: UIControl.State())
        }
    }
    
    
    init() {
        super.init(frame: CGRect.zero)
        roundCorner()
        //        println("init")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundCorner()
        //        println("override init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        roundCorner()
        //        println("required init")
    }
    
    func roundCorner(){
//        self.layer.cornerRadius = 5
//        self.clipsToBounds = true
//        self.backgroundColor = NSTheme().GetButtonBGColor()
//        self.setTitleColor(NSTheme().GetButtonTextColor(), forState: UIControlState.Normal)

    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
