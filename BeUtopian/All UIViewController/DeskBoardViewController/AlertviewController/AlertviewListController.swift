//
//  AlertviewListController.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 05/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class AlertviewListController: UIViewController,CarbonTabSwipeNavigationDelegate
{
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
       var items = NSArray()
    var objRootExplore = alertlistController(nibName: "alertlistController", bundle: nil)
      var objRootDeskBoard = HistoryViewController(nibName: "HistoryViewController", bundle: nil)
    var strFlatName = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        items = ["ALERT","HISTORY"]
        print(strFlatName)
        
        self.SwipeNavigation()
        
        // Do any additional setup after loading the view.
    }
   override func viewWillAppear(_ animated: Bool)
      {
          self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
          self.navigationItem.title = "Alert"
          

          
          if ((self.navigationController!.presentingViewController) != nil)
          {
              self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(FTPopOverMenu.dismiss))
          }
          
          if isDataAddedToSociety == true {
              isDataAddedToSociety = false
              //self.GetNoticeBoard("0")
          }
      }
    func SwipeNavigation()
       {
           carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items:self.items as! [String], delegate: self)
           carbonTabSwipeNavigation.insert(intoRootViewController: self)
           carbonTabSwipeNavigation.delegate = self
        //   self.performSelector("insertTab", withObject: nil, afterDelay: 0.3)
           self.style()
       }
       func style()
       {
            DispatchQueue.main.async{
           self.navigationController!.navigationBar.isTranslucent = false
           self.navigationController!.navigationBar.barStyle = .blackTranslucent
           self.carbonTabSwipeNavigation.toolbar.isTranslucent = false
          self.carbonTabSwipeNavigation.toolbar.barTintColor = NSTheme().GetNavigationBGColor()
           self.carbonTabSwipeNavigation.toolbar.tintColor = NSTheme().GetNavigationBGColor()
           
           self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           }
           self.carbonTabSwipeNavigation.setIndicatorColor(UIColor.white)
           
           let screenSize: CGSize = UIScreen.main.bounds.size
           let widthOfScreen : CGFloat = screenSize.width / 2
           
           for (index, _) in self.items.enumerated()
           {
               self.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(widthOfScreen, forSegmentAt: index)
           }
          
           
           let font = UIFont (name: "HelveticaNeue-Medium", size: 16)
           
          self.carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6), font: font!)
           
           self.carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: font!)
           self.carbonTabSwipeNavigation.setSelectedColor(.white)
           self.carbonTabSwipeNavigation.toolbar.backgroundColor = NSTheme().GetNavigationBGColor()
               self.view.layoutIfNeeded()
               self.viewWillLayoutSubviews()

       }
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController
       {
           
           switch index {
           case 0:
               return objRootExplore
           case 1:
               return objRootDeskBoard
           default:
               
               return objRootDeskBoard
           }
           
       }
       
       func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
           
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
