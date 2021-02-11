//
//  AppColors.swift
//  wisley
//
//  Created by rajesh jain on 6/17/19.
//  Copyright © 2019 Waytoweb.in. All rights reserved.
//

import UIKit


struct  AppColor{
         
    static var PRIMARY_COLOR :UIColor = AppColor.hexStringToUIColor(hex:"#0E74B6")
    static var SECONDRY_COLOR :UIColor = AppColor.hexStringToUIColor(hex:"#28A4DD")

        static func hexStringToUIColor (hex:String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return UIColor.gray
            }
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
}
