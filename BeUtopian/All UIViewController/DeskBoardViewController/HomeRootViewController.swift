//
//  HomeRootViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 5/4/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class HomeRootViewController: UIViewController,CDRTranslucentSideBarDelegate,CarbonTabSwipeNavigationDelegate
{

    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    var objRootExplore = ExploreViewController(nibName: "ExploreViewController", bundle: nil)
    var objRootDeskBoard = DeskBoardViewController(nibName: "DeskBoardViewController", bundle: nil)
    
    //Slider
    var sideBar = CDRTranslucentSideBar()
    var isEnableSlider : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SetNavigationButton()
        
        items = ["Home","Explore"]
        self.SwipeNavigation()
        
        self.SliderMenu()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let data = getLoginUser()
        self.navigationItem.title = "WGATE"
        if let tempStr = data.object(forKey: "societyName") as? String {
            self.navigationItem.title = tempStr
        }
    }
    
    func SliderMenu()
    {
        //SliderMenu
        
        self.sideBar?.sideBarWidth = (UIScreen.main.bounds.width / 4) * 3
        self.sideBar?.delegate = self
        //    self.sideBar.translucentStyle = UIBarStyleBlack;
        self.sideBar?.tag = 1
        self.isEnableSlider = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(HomeRootViewController.handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        
        
        
        DispatchQueue.main.async{
            let sliderMenu = SliderLeftMenu.instanceFromNib()
            
            sliderMenu.parentViewController = self
            
            self.sideBar?.setContentViewIn(sliderMenu)
        }
    }
    
    
    func SetNavigationButton()
    {
        let userframe = CGRect(x: 40, y: 5, width: 30, height: 30)
        let userButton = UIButton(type: .custom)
        userButton.frame = userframe
        
        userButton.setImage(UIImage(named: "icon_user"), for: UIControl.State())
        userButton.addTarget(self, action: #selector(HomeRootViewController.OpenMyProfile), for: .touchUpInside)
        
           let notiframe = CGRect(x: 0, y: 5, width: 30, height: 30)
        let notiButton = UIButton(type: .custom)
        notiButton.frame = notiframe
        
     
        notiButton.setImage(UIImage(named: "notification"), for: UIControl.State())
        notiButton.addTarget(self, action: #selector(HomeRootViewController.OpenNotifications), for: .touchUpInside)
        
       
        
        let viewFN = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 40))
        viewFN.addSubview(notiButton)
        viewFN.addSubview(userButton)
        viewFN.backgroundColor = UIColor.clear
        
        let Button = UIBarButtonItem(customView: viewFN)
        self.navigationItem.rightBarButtonItem = Button
        
        /*
         let notiframe = CGRectMake(0, 10, 30, 30)
         let notiButton = UIButton(frame: notiframe)
         notiButton.setImage(UIImage(named: "notification"), forState: .Normal)
         notiButton.addTarget(self, action: "OpenNotifications", forControlEvents: .TouchUpInside)
         
         let viewframe = CGRectMake(0, 0, 62, 50)
         let rightView = UIView(frame: viewframe)
         rightView.backgroundColor = UIColor.clearColor()
         rightView.addSubview(notiButton)
         rightView.addSubview(userButton)
         
         let rightButton = UIBarButtonItem(customView: rightView)
         
         self.navigationItem.rightBarButtonItem = rightButton
         */
        
        
        //Left SliderButton
        let leftframe = CGRect(x: 0, y: 10, width: 30, height: 30)
        let leftButton = UIButton(frame: leftframe)
        leftButton.setImage(UIImage(named: "btnMenu"), for: UIControl.State())
        leftButton.addTarget(self, action: #selector(HomeRootViewController.OnSideBarButtonTapped(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    @IBAction func OnSideBarButtonTapped(_ sender : AnyObject){
        if self.isEnableSlider == true {
            self.sideBar?.dismiss(animated: true)
        }else{
            self.sideBar?.show(in: self)
        }
    }
    @objc func OpenMyProfile(){
        let objRoot: ProfileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
        
    }
    @objc func OpenNotifications()
    {
        let objRoot: UpdateViewController = UpdateViewController(nibName: "UpdateViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
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
    //MARK:- Open Slider ViewController -
    func OpenSubMenu(_ titleStr : String){
        
        if titleStr.caseInsensitiveCompare("About Wgate") == .orderedSame {
            let objRoot: AboutViewController = AboutViewController(nibName: "AboutViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if titleStr.caseInsensitiveCompare("Help / Support") == .orderedSame
        {
           // let objRoot: SupportViewController = SupportViewController(nibName: "SupportViewController", bundle: nil)
           // self.navigationController?.pushViewController(objRoot, animated: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                 let vc = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
                                 self.navigationController?.pushViewController(vc, animated: true)
            
            
            
            
            
            
        }else if titleStr.caseInsensitiveCompare("Visitor") == .orderedSame {
            let objRoot: VisitorViewController = VisitorViewController(nibName: "VisitorViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if titleStr.caseInsensitiveCompare("logout") == .orderedSame {
            let objRoot: LoginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            let navigation = UINavigationController(rootViewController: objRoot)
            appDelegate.SetNavigationBar(navigation)
            //            self.sidePanelController?.centerPanel = navigation
            appDelegate.window?.rootViewController = navigation
            RemoveLoginUser()
            
        }else if titleStr.caseInsensitiveCompare("My Society") == .orderedSame {
            let objRoot: SocietyViewController = SocietyViewController(nibName: "SocietyViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("Blog") == .orderedSame {
            let objRoot: BrowserViewController = BrowserViewController(nibName: "BrowserViewController", bundle: nil)
            objRoot.websiteUrl = "http://sms.thewebtual.com/blog/"
            objRoot.navigationTitle = "Blog"
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("profile") == .orderedSame {
            let objRoot: ProfileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }
        
    }
    
    
    //MARK: - Gesture Handler -
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        // if you have left and right sidebar, you can control the pan gesture by start point.
        if recognizer.state == .began {
            let startPoint = recognizer.location(in: self.view)
            // Left SideBar
            if startPoint.x < self.view.bounds.size.width / 2.0 {
                self.sideBar?.isCurrentPanGestureTarget = true
            }
            
        }
        //	[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
        self.sideBar?.handlePanGesture(toShow: recognizer, in: self)
        
        // if you have only one sidebar, do like following
        // self.sideBar.isCurrentPanGestureTarget = YES;
        //[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    }
    
    //MARK: - CDRTranslucentSideBarDelegate -
    
    func sideBar(_ sideBar: CDRTranslucentSideBar, didAppear animated: Bool) {
        if sideBar.tag == 0 {
            print("Left SideBar did appear")
        }
        if sideBar.tag == 1 {
            print("Right SideBar did appear")
            self.isEnableSlider = true
        }
    }
    func sideBar(_ sideBar: CDRTranslucentSideBar, willDisappear animated: Bool) {
        if sideBar.tag == 0 {
            print("Left SideBar will disappear")
        }
        if sideBar.tag == 1 {
            print("Right SideBar will disappear")
            self.isEnableSlider = false
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
