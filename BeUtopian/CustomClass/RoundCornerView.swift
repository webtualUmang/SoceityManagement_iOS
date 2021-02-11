//
//  Round.swift
//  BeUtopian
//
//  Created by desap on 10/26/15.
//  Copyright © 2015 desap. All rights reserved.
//

import UIKit

class RoundCornerView: UIView {

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
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.lightGray.cgColor,
                     shadowOffset: CGSize = CGSize(width: 1, height: 1),
                     shadowOpacity: Float = 0.7,
                     shadowRadius: CGFloat = 3.0)
      {
          layer.shadowColor = shadowColor
          layer.shadowOpacity = shadowOpacity
          layer.shadowOffset = shadowOffset
          layer.shadowRadius = shadowRadius
          layer.masksToBounds = false
          
          
          //        layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
          //        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
          //        layer.shadowOpacity = 1.0
          //        layer.shadowRadius = 5.0
          
          
          
      }
    
    init() {
        super.init(frame: CGRect.zero)
        
        //        println("init")
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        println("override init")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
