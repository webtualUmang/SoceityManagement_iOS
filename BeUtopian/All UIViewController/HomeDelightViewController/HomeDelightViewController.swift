//
//  HomeDelightViewController.swift
//  BeUtopian
//
//  Created by Desap Team on 23/12/2017.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class HomeDelightViewController: UIViewController,CarbonTabSwipeNavigationDelegate
{

    @IBOutlet var tableview: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    var objAllService = AllServiceViewController(nibName: "AllServiceViewController", bundle: nil)
    var objPopularServices = PopularServicesViewController(nibName: "PopularServicesViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "WGATE"
        
        tableview.tableHeaderView = headerView
        tableview.tableFooterView = footerView
        
        sizeHeaderToFit()
        
        items = ["POPULAR SERVICES","ALL SERVICES"]
        self.SwipeNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let right = UIBarButtonItem(image: #imageLiteral(resourceName: "shopping_cart"), style: .plain, target: self, action: #selector(OpenMyOrder))
        self.navigationItem.rightBarButtonItem = right
        
    }
    
    @objc func OpenMyOrder(){
        let rootObj = MyOrderTabBarViewController(nibName: "MyOrderTabBarViewController", bundle: nil)
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func sizeHeaderToFit() {
       
        
        let screens = UIScreen.main.bounds.size
        
//        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.bounds
        frame.size.height = (screens.height - headerView.frame.size.height)
        
        
        var footerFrame = self.footerView.frame
        footerFrame.size.height = frame.size.height
        footerView.frame = footerFrame
        
        tableview.tableFooterView = footerView
    }

    func SwipeNavigation() {
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
//        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: footerView)
        
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
        let widthOfScreen : CGFloat = screenSize.width / 2
        
        for (index, _) in items.enumerated() {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(widthOfScreen, forSegmentAt: index)
        }
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 0)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 1)
        //                carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(width, forSegmentAtIndex: 2)
        
        let font = UIFont (name: "HelveticaNeue-Medium", size: 12)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6), font: font!)
        
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: font!)
        
    }
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            // self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
            return objPopularServices
        case 1:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            
            return objAllService
        default:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
            
            return objPopularServices
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
//        self.selectedIndex = Int(index)
        //        if index == 1 {
        //            objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
        //
        //        }else{
        //            self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
        //
        //        }
        
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
