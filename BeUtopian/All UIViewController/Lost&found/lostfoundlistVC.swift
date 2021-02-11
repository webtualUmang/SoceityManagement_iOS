//
//  lostfoundlistVC.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 22/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class lostfoundlistVC: UIViewController,CarbonTabSwipeNavigationDelegate
{
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
       var items = NSArray()
    var selectedIndex : Int = 0


    var objLost : LostListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LostListVC") as! LostListVC
    
       var objFound : FoundListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FoundListVC") as! FoundListVC
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        items = ["Lost","Found"]
               self.SwipeNavigation()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
       {
           self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
           self.navigationItem.title = "Lost & Found"
           

           
           if ((self.navigationController!.presentingViewController) != nil)
           {
               self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(self.dismissview))
           }
           
          
       }
   @objc func dismissview()
    {
        self.dismiss(animated: true) {
            
        }
    }
      func SwipeNavigation()
        {
            carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
            carbonTabSwipeNavigation.insert(intoRootViewController: self)
            //        self.performSelector("insertTab", withObject: nil, afterDelay: 0.3)
            self.style()
        }
        func style()
        {
            
            self.navigationController!.navigationBar.isTranslucent = false
            
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
            
        }
        

        func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
            
            switch index {
            case 0:
                
               // self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
                return objLost
            case 1:
                //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)

                return objFound
            default:
                //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)

                return objLost
            }
            
        }
        
        func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt)
        {
            self.selectedIndex = Int(index)
    //        if index == 1 {
    //            objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
    //
    //        }else{
    //            self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
    //
    //        }
            
            NSLog("Did move at index: %ld", index)
            
        }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
