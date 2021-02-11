//
//  ComplainsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController,CarbonTabSwipeNavigationDelegate
{
    
    let customize = true
    let showImageOnButton = false
    
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    let objRootNeighbour = NeighbourViewController(nibName: "NeighbourViewController", bundle: nil)
    
    let objRootStaff = StaffViewController(nibName: "StaffViewController", bundle: nil)
    let objRootCommittee = CommitteeViewController(nibName: "CommitteeViewController", bundle: nil)
    let objRootVehicle = VehicleViewController(nibName: "VehicleViewController", bundle: nil)
    
    var defaultSelectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds
        // Do any additional setup after loading the view.
        //        self.SetSwipeBar()
        self.items = ["NEIGHBOUR","STAFF","COMMITTEE","VEHICLE"]
        self.SwipeNavigation()
        //        SetSwipeBar()
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Directory"
        if ((self.navigationController!.presentingViewController) != nil)
        {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(FTPopOverMenu.dismiss))
        }
        
    }
    func dismiss()
    {
        self.dismiss(animated: true) {
            
        }
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
        let widthOfScreen : CGFloat = screenSize.width / 4
        
        for (index, _) in items.enumerated()
        {
            if index == 0 || index == 2
            {
                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(screenSize.width * 0.3, forSegmentAt: index)
            }
            else
            {
                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(screenSize.width * 0.25, forSegmentAt: index)
            }
           
            
        }
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 0)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 1)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 2)
        
        var font = UIFont (name: "HelveticaNeue-Medium", size: 11)
        if UIScreen.main.bounds.width > 320
        {
            font = UIFont (name: "HelveticaNeue-Medium", size: 12)
        }
        self.carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6), font: font!)
        
        self.carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: font!)
        self.carbonTabSwipeNavigation.currentTabIndex = UInt(self.defaultSelectedIndex)
    }
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            
            return objRootNeighbour
        case 1:
            return objRootStaff
        case 2:
            return objRootCommittee
        case 3:
            return objRootVehicle
        default:
            return objRootVehicle
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        
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
