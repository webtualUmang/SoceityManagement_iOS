//
//  ComplainsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class FacilityViewController: UIViewController,AddFacilityDelegate,CarbonTabSwipeNavigationDelegate
{
    @IBOutlet weak var viewInner:UIView!
    
    let customize = true
    let showImageOnButton = false
    let titleBarDataSource = ["Details", "Order lines", "Audit Trail"]
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
  
    let objRootBooked:BookedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookedViewController") as! BookedViewController
    
    
    let objRootClosed:ClosedViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosedViewController") as! ClosedViewController
    var FacilityResult = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.SetSwipeBar()
        items = ["REQUEST","STATUS"]
        self.SwipeNavigation()
//        SetSwipeBar()
        
        
//        let rightbtn = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "PostComplain")
//        
//        self.navigationItem.rightBarButtonItem = rightbtn
        
//        self.performSelector("GetNoticeBoard:", withObject: "0")
        
        let frames = self.viewInner.bounds.size
        let menuButtonSize: CGSize = CGSize(width: 70.0, height: 70.0)
        
        let menuButtons = UIView(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.setImage(UIImage(named: "add_plus"), for: UIControl.State())
 button.addTarget(self, action: #selector(FacilityViewController.AddFacility), for: .touchUpInside)
        button.backgroundColor = .red
        menuButtons.center = CGPoint(x: frames.width - 20.0, y: frames.height - 30.0)
        button.isUserInteractionEnabled = true
        menuButtons.addSubview(button)
        
        self.viewInner.addSubview(menuButtons)
        
        
    }
   @IBAction func AddFacility(_ sender:UIButton)
   {
        let objRoot: FacilityAddViewController = FacilityAddViewController(nibName: "FacilityAddViewController", bundle: nil)
        objRoot.delegate = self
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    func ReloadFacilityResult()
    {
        self.objRootBooked.GetNoticeBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Facility"
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
        let widthOfScreen : CGFloat = screenSize.width / 2
        
        for (index, _) in items.enumerated(){
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
            objRootBooked.CreateCell(self.FacilityResult)
            return objRootBooked
        case 1:
            
            return objRootClosed
        default:
            return objRootClosed
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        if index == 1 {
            objRootClosed.CreateCell(self.FacilityResult)
           
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
