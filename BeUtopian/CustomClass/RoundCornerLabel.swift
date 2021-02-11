//
//  Round.swift
//  BeUtopian
//
//  Created by desap on 10/26/15.
//  Copyright © 2015 desap. All rights reserved.
//

import UIKit

class RoundCornerLabel: UILabel
{

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

extension NSMutableAttributedString {
    
    func BoldText(_ text:String,color : UIColor?, size : CGFloat) -> NSMutableAttributedString
    {
        //let attrs:[NSAttributedString:Any] = [.fon : UIFont (name: "HelveticaNeue-Medium", size: 15)!,NSForegroundColorAttributeName: color == nil ? UIColor.black : color!]
        
      //  let lineattribute : [NSAttributedString.Key : Any] = [
       //     .font : UIFont (name: "HelveticaNeue-Medium", size: 15)!,.c]
        let myAttribute = [ NSAttributedString.Key.font: UIFont (name: "HelveticaNeue-Medium", size: 15)!,NSAttributedString.Key.foregroundColor : color == nil ? UIColor.black : color!]

        let boldString = NSMutableAttributedString(string:"\(text)", attributes:myAttribute)
        self.append(boldString)
        return self
    }
    
    func NormalText(_ text:String,color : UIColor?, size : CGFloat) -> NSMutableAttributedString {
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: size),NSAttributedString.Key.foregroundColor : color == nil ? UIColor.black : color!]
        
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:myAttribute)
        self.append(boldString)
        return self
    }
    
    
}
