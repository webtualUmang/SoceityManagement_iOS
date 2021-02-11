//
//  NSTheme.swift
//  BeUtopian
//
//  Created by desap on 6/23/15.
//  Copyright (c) 2015 desap. All rights reserved.
//

import UIKit

class NSTheme: NSObject {
    
    let kColorAlpha : CGFloat = 1.0
    
    func GetButtonTextColor() -> UIColor {
        return UIColor.white
    }
    
    func GetNavigationBGColor() -> UIColor {
//        return UIColor(hexString:"00ac44")
//        return UIColor(red: 40.0/255.0, green: 147.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        return AppColor.hexStringToUIColor(hex:"#0E74B6")
    }
    func ThemeBGColors() -> UIColor {
        return UIColor(red: 40.0/255.0, green: 96.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    }
    func GetGreenColor() -> UIColor {
        return UIColor(hexString:"3972BE")
    }
    
    func GetNavigationTitleColor() -> UIColor {
//        return UIColor(hexString:"ffffff")
        return UIColor.white
    }
    
    func GetWhiteBGColor() -> UIColor {
        return UIColor(hexString:"fffff")
    }
    
    func GetLabelBGColor() -> UIColor {
        return UIColor(hexString: "2893F3")
    }
}


extension UIDevice {
//    var iPhone: Bool {
//        return UIDevice().userInterfaceIdiom == .Phone
//    }
//    enum ScreenType: String {
//        case iPhone4
//        case iPhone5
//        case iPhone6
//        case iPhone6Plus
//        case Unknown
//    }
//    var screenType: ScreenType? {
//        guard iPhone else { return nil }
//        switch UIScreen.mainScreen().nativeBounds.height {
//        case 960:
//            return .iPhone4
//        case 1136:
//            return .iPhone5
//        case 1334:
//            return .iPhone6
//        case 2208:
//            return .iPhone6Plus
//        default:
//            return nil
//        }
//    }
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
