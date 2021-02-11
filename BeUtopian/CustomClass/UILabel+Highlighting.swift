//
//  UILabel.swift
//  LinksCourierAdmin
//
//  Created by Nikunj on 03/10/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

import UIKit

enum FontTypes: String {
    case Black
    case BlackItalic
    case Bold
    case BoldItalic
    case ExtraBold
    case ExtraBoldItalic
    case ExtraLight
    case ExtraLightItalic
    case Italic
    case Light
    case LightItalic
    case Regular
    case SemiBold
    case SemiBoldItalic
    case Thin
    case ThinItalic
}

extension UILabel {
    var highlightedText: String {
        get {
            return attributedText!.string
        }
        set {
            attributedTextFromHtml(newValue)
        }
    }
    
    fileprivate func attributedTextFromHtml(_ htmlText: String) {
        let text = NSMutableString(string: htmlText)
        let rangesOfAttributes = getRangeToHighlight(text)
        
        let attributedString = NSMutableAttributedString(string: String(text))
        for range in rangesOfAttributes {
            let color = highlightedTextColor ?? UIColor.blue
            
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        attributedText = attributedString
    }
    
    fileprivate func getRangeToHighlight(_ text: NSMutableString) -> [NSRange] {
        var rangesOfAttributes = [NSRange]()
        
        while true {
            let matchBegin = text.range(of: "<em>", options: .caseInsensitive)
            
            if matchBegin.location != NSNotFound {
                text.deleteCharacters(in: matchBegin)
                let firstCharacter = matchBegin.location
                
                let range = NSRange(location: firstCharacter, length: text.length - firstCharacter)
                let matchEnd = text.range(of: "</em>", options: .caseInsensitive, range: range)
                if matchEnd.location != NSNotFound {
                    text.deleteCharacters(in: matchEnd)
                    let lastCharacter = matchEnd.location
                    
                    rangesOfAttributes.append(NSRange(location: firstCharacter, length: lastCharacter - firstCharacter))
                }
            } else {
                break
            }
        }
        
        return rangesOfAttributes
    }
    
   
    func HtmlBoldWithColor(FullString messageStr : String, TitleText titleStr : String, timeStr : String){
        // 1
        let string = messageStr as NSString
        let attributedString = NSMutableAttributedString(string: string as String)
        
        // 2
        let font = UIFont.systemFont(ofSize: 15)
        
//        let firstAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(self.font.pointSize)]
        let firstAttributes = [NSAttributedString.Key.font: font]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
//        let thirdAttributes = [NSForegroundColorAttributeName: UIColor.greenColor(), NSBackgroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.systemFontOfSize(40)]
        
        // 3
        if titleStr != "" {
           attributedString.addAttributes(firstAttributes, range: string.range(of: titleStr)) 
        }
        
        if timeStr != "" {
            attributedString.addAttributes(secondAttributes, range: string.range(of: timeStr))
        }
        
//        attributedString.addAttributes(thirdAttributes, range: string.rangeOfString("Strings"))
        
        // 4
        self.attributedText = attributedString
    }
    
}


extension NSMutableAttributedString {
    
    
    func BoldText(_ text:String,color : UIColor?, size : CGFloat, paragraph: Bool, fontname: FontTypes) -> NSMutableAttributedString {
        
        // let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont (name: UIFont.SetFontsTypes(Type: fontname), size: size)!,NSForegroundColorAttributeName: color == nil ? UIColor.black : color!]
        
       // let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont (name: "HelveticaNeue-Medium", size: size)!,NSForegroundColorAttributeName: color == nil ? UIColor.black : color!]
        let attribute = [NSAttributedString.Key.font : UIFont (name: "HelveticaNeue-Medium", size: size)!,NSAttributedString.Key.foregroundColor :  color == nil ? UIColor.black : color!]
        
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attribute)
        
        if(paragraph == true){
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            //paragraphStyle.alignment = .center
            boldString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, boldString.length))
        }
        
        self.append(boldString)
        return self
    }
    
    func NormalText(_ text:String,color : UIColor?, size : CGFloat, paragraph: Bool, fontname: FontTypes) -> NSMutableAttributedString {
    

         //let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont (name: UIFont.SetFontsTypes(Type: fontname), size: size)!,NSForegroundColorAttributeName: color == nil ? UIColor.black : color!]
        
       
         let attribute = [NSAttributedString.Key.font :UIFont (name: "HelveticaNeue", size: size)!,NSAttributedString.Key.foregroundColor :color == nil ? UIColor.black : color!  ]
        
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attribute)
        
        if(paragraph == true){
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            //paragraphStyle.alignment = .center
            boldString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, boldString.length))
        }
        
        self.append(boldString)
        return self
    }
        
    //MARK: - TextAlignment
    
    func BoldCenterText(_ text:String,color : UIColor?, size : CGFloat, paragraph: Bool) -> NSMutableAttributedString {
        
       // let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont (name: "Overpass-SemiBold", size: size)!,NSForegroundColorAttributeName: color == nil ? UIColor.black : color!]
        let attribute = [NSAttributedString.Key.font :UIFont (name: "Overpass-SemiBold", size: size)!,NSAttributedString.Key.foregroundColor :color == nil ? UIColor.black : color!]
        
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attribute)
        
        if(paragraph == true){
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
//            paragraphStyle.alignment = .justified
            
            let attributedString = NSAttributedString(string: text,
                                                      attributes: [
                                                        NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font : UIFont (name: "Overpass-SemiBold", size: size)!,NSAttributedString.Key.foregroundColor: color == nil ? UIColor.black : color!])
            //self.append(attributedString)
            
//            boldString.append(attributedString)
//            boldString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, boldString.length))
        }
        
        self.append(boldString)
        return self
    }
    
    func NormalCenterText(_ text:String,color : UIColor?, size : CGFloat, paragraph: Bool) -> NSMutableAttributedString {
        
       // let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont (name: "HelveticaNeue", size: size)!,NSForegroundColorAttributeName: color == nil ? UIColor.black : color!]
        let attribute = [NSAttributedString.Key.font :UIFont (name: "HelveticaNeue", size: size)!,NSAttributedString.Key.foregroundColor :color == nil ? UIColor.black : color!  ]
        
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attribute)
        
        if(paragraph == true){
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.alignment = .center
            boldString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, boldString.length))
        }
        
        self.append(boldString)
        return self
    }
}

extension UIFont {

    class func SetFontsTypes(Type: FontTypes) -> String {
        
        switch Type {
        case .Black:
            return "Overpass-Black"
        case .BlackItalic:
            return "Overpass-BlackItalic"
        case .Bold:
            return "Overpass-Bold"
        case .BoldItalic:
            return "Overpass-BoldItalic"
        case .ExtraBold:
            return "Overpass-ExtraBold"
        case .ExtraBoldItalic:
            return "Overpass-ExtraBoldItalic"
        case .ExtraLight:
            return "Overpass-Light"
        case .ExtraLightItalic:
            return "Overpass-ExtraLight"
        case .Italic:
            return "Overpass-Italic"
        case .Light:
            return "Overpass-Light"
        case .LightItalic:
            return "Overpass-LightItalic"
        case .Regular:
            return "Overpass-Regular"
        case .SemiBold:
            return "Overpass-SemiBold"
        case .SemiBoldItalic:
            return "Overpass-SemiBoldItalic"
        case .Thin:
            return "Overpass-Thin"
        case .ThinItalic:
            return "Overpass-ThinItalic"
        default:
            return "Overpass-Regular"
        }
    }
}
