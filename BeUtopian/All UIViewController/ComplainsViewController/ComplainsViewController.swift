//
//  ComplainsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ComplainsViewController: UIViewController,CarbonTabSwipeNavigationDelegate {

    let customize = true
    let showImageOnButton = false
    let titleBarDataSource = ["Details", "Order lines", "Audit Trail"]
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    var resultData = NSArray()
        
    var objRootCompainOpen = CompainOpenViewController(nibName: "CompainOpenViewController", bundle: nil)
    var objRootCompainClose = CompainCloseViewController(nibName: "CompainCloseViewController", bundle: nil)
    var selectedIndex : Int = 0
    
   
    var popup: KOPopupView?
    
    var isFiltter : String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.SetSwipeBar()
        items = ["Open","Close"]
        self.SwipeNavigation()
//        SetSwipeBar()
        
//        let rightbtn = UIBarButtonItem(image: UIImage(named: "filter"), style: .Plain, target: self, action: "PostComplain")
//        
//        self.navigationItem.rightBarButtonItem = rightbtn
        
        let frames = UIScreen.main.bounds.size
        let menuButtonSize: CGSize = CGSize(width: 90.0, height: 90.0)
        
        let menuButtons = UIView(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        button.setImage(UIImage(named: "add_plus"), for: UIControl.State())
        button.addTarget(self, action: #selector(ComplainsViewController.AddCoplains), for: .touchUpInside)
        
        menuButtons.center = CGPoint(x: frames.width - 50.0, y: frames.height - 120.0)
        menuButtons.addSubview(button)
        
        self.view.addSubview(menuButtons)
        
//        btnPersonal.set(image: UIImage(named: "un_check"), title: "  Personal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
//
//        btnCommunity.set(image: UIImage(named: "un_check"), title: "  Cummunity", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())

        
        //self.GetNoticeBoard("0")
    }
    func PostComplain(){
        //let objRoot: ComplainAddViewController = ComplainAddViewController(nibName: "ComplainAddViewController", bundle: nil)
       // self.navigationController?.pushViewController(objRoot, animated: true)
        
        if (popup == nil) {
            popup = KOPopupView()
        }
//        popup?.handleView.addSubview(FilterView)
//        FilterView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
//            y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
//    @IBAction func BtnFilterSelect(_ sender: AnyObject)
//    {
//        let btn = sender as? UIButton
//        if(btn!.tag == 0){
//            btnPersonal.set(image: UIImage(named: "check_blue"), title: "  Personal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
//
//            btnCommunity.set(image: UIImage(named: "un_check"), title: "  Cummunity", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
//            self.isFiltter = "personal"
//        }
//        else{
//            btnPersonal.set(image: UIImage(named: "un_check"), title: "  Personal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
//
//            btnCommunity.set(image: UIImage(named: "check_blue"), title: "  Cummunity", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
//            self.isFiltter = "community"
//        }
        
//        if selectedIndex == 1 {
//            objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)
//            
//        }else{
//            objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
//            
//        }
     //   popup?.hide(animated: true)
  //ßß  }
    
//    @IBAction func BtnFilterViewClose(_ sender: AnyObject){
//        popup?.hide(animated: true)
//    }
    
    @IBAction func AddCoplains(_ sender:UIButton)
    {
        let objRoot: ComplainAddViewController = ComplainAddViewController(nibName: "ComplainAddViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Complains"
        

        
        if ((self.navigationController!.presentingViewController) != nil)
        {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(FTPopOverMenu.dismiss))
        }
        
        if isDataAddedToSociety == true {
            isDataAddedToSociety = false
            //self.GetNoticeBoard("0")
        }
    }
    func dismiss()
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
        
    }
    

    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
           // self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
            return objRootCompainOpen
        case 1:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)

            return objRootCompainClose
        default:
            //objRootCompainClose.CreateCell(self.resultData, isFiltter: self.isFiltter)

            return objRootCompainClose
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
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
    
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard(_ idStr : String)
    {
        
        let urlStr = String(format: "%@?view=helpdesk&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "complaint_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.resultData = NSArray(array: bannerList)
                                    self.objRootCompainOpen.CreateCell(self.resultData, isFiltter: self.isFiltter)
                                    
//                                    self.InsertNoticeFromLocalDB(bannerList)
                                }
                                
                            }
                        }
                    }
                }
                
                
                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
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
