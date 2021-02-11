//
//  MyOrderTabBarViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 13/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class MyOrderTabBarViewController: UIViewController {

    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    var OpenVC = OpenOrderViewController(nibName: "OpenOrderViewController", bundle: nil)
    var CompleteVC = CompletedOrderViewController(nibName: "CompletedOrderViewController", bundle: nil)
    var CancelledVC = CancelledOrderViewController(nibName: "CancelledOrderViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        items = ["OPEN","COMPLETED","CANCELLED"]
        self.SwipeNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "My Orders"
    }

    func SwipeNavigation() {
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        //        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: self.view)
        
        self.style()
    }
    func style() {
        
        self.navigationController!.navigationBar.isTranslucent = false
        //        self.navigationController!.navigationBar.tintColor = NSTheme().GetNavigationBGColor()
        //        self.navigationController!.navigationBar.barTintColor = NSTheme().GetNavigationBGColor()
        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.toolbar.barTintColor = NSTheme().GetNavigationBGColor()
        carbonTabSwipeNavigation.toolbar.tintColor = NSTheme().GetNavigationBGColor()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.init(hexString: "EC984F"))
        
        let screenSize: CGSize = UIScreen.main.bounds.size
        let widthOfScreen : CGFloat = screenSize.width / 3
        
        for (index, _) in items.enumerated() {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(widthOfScreen, forSegmentAt: index)
        }
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 0)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 1)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 2)
        
        let font = UIFont (name: "HelveticaNeue-Medium", size: 14)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6), font: font!)
        
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: font!)
        
    }
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAtIndex index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            // self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
            return OpenVC
        case 1:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            return CompleteVC
        case 2:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            return CancelledVC
        default:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            
            return OpenVC
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAtIndex index: UInt) {
        NSLog("Did move at index: %ld", index)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
