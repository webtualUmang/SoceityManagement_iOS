//
//  UINavigationController+Extra.swift
//  Annecto UK
//
//  Created by TNM_ios2 on 23/03/15.
//  Copyright (c) 2015 TechNet Media. All rights reserved.
//

import Foundation
import UIKit
/** Extra Extends UINavigationController

*/
extension UINavigationController {
    func pushFadeViewController(viewcontrller controller:UIViewController) {
        
       
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        view.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)

    }
    
    func popFadeViewController() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade//CATransitionType.fade
        view.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false);
    }
    func popFadeToViewController(viewcontrller controller:UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade//CATransitionType.fade
        view.layer.add(transition, forKey: kCATransition)
        popToViewController(controller, animated: false)
    }
    func popFadeToRootViewController() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade//CATransitionType.fade
        view.layer.add(transition, forKey: kCATransition)
        popToRootViewController(animated: false)
    }
}
