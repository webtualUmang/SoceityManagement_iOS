//
//  UITableView+Extension.swift
//  Tasty
//
//  Created by Vitaliy Kuzmenko on 23/12/14.
//  Copyright (c) 2014 Vitaliy Kuz'menko. All rights reserved.
//

import UIKit

var parallaxEffect : RKParallaxEffect!

extension UITableView {
  
    func isEnableParallexHeader()
    {
        
        
        parallaxEffect = RKParallaxEffect(tableView: self)
        parallaxEffect.isParallaxEffectEnabled = true
        parallaxEffect.isFullScreenTapGestureRecognizerEnabled = false
        parallaxEffect.isFullScreenPanGestureRecognizerEnabled = false
        
//        self.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        
//        var scrollViewHeight: CGFloat = 0.0
//        for view: UIView in self.subviews {
//            scrollViewHeight += view.frame.size.height
//        }
//        self.contentSize = (CGSizeMake(320, scrollViewHeight))
        
    }
//    func EnableCustomScrollIndicators(){
////        self.delegate = self
//        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 3)
//        self.scrollEnabled = true
//        self.enableCustomScrollIndicatorsWithScrollIndicatorType(JMOScrollIndicatorType.Classic, positions: JMOScrollIndicatorPosition.VerticalScrollIndicatorPositionRight, color: UIColor.redColor())
//
//    }
    
}

