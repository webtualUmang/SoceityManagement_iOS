//
//  AccountTransactionViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 10/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class AccountTransactionViewController: UIViewController,CarbonTabSwipeNavigationDelegate
{

    let titleBarDataSource = ["Details", "Order lines", "Audit Trail"]
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()

    var objRootPending = PendingTransactionViewController(nibName: "PendingTransactionViewController", bundle: nil)
    var objRootCompleted = CompletedTransactionViewController(nibName: "CompletedTransactionViewController", bundle: nil)

    var defaultSelectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        items = ["PENDING","COMPLETED"]
        self.SwipeNavigation()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Account Transaction"
    }
    
    func SwipeNavigation() {
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        //        self.performSelector("insertTab", withObject: nil, afterDelay: 0.3)
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
        
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.white)
        
        let screenSize: CGSize = UIScreen.main.bounds.size
        let widthOfScreen : CGFloat = screenSize.width / 2
        
        for (index, _) in items.enumerated() {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(widthOfScreen, forSegmentAt: index)
        }
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 0)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 1)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 2)
        
        let font = UIFont (name: "HelveticaNeue-Medium", size: 17)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6), font: font!)
        
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: font!)
        self.carbonTabSwipeNavigation.currentTabIndex = UInt(self.defaultSelectedIndex)
    }
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
//            self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
            return objRootPending
        case 1:
//            objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            
            return objRootCompleted
        default:
//            objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            
            return objRootCompleted
        }
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
