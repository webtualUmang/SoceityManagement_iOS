//
//  ComplainsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class MeetingViewController: UIViewController,CarbonTabSwipeNavigationDelegate
{

    let customize = true
    let showImageOnButton = false
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    let objRootBooked = MeetingBookedViewController(nibName: "MeetingBookedViewController", bundle: nil)
    let objRootClosed = MeetingClosedViewController(nibName: "MeetingClosedViewController", bundle: nil)
    
    @IBOutlet var btnPersonal: UIButton!
    @IBOutlet var btnCommunity: UIButton!
    @IBOutlet var FilterView: UIView!
    var popup: KOPopupView?
    
    var selectedIndex : Int = 0
    var tabOneSelectedOption : Int = 0
    var tabTwoSelectedOption : Int = 0
    @IBOutlet var ResetView: UIView!
    @IBOutlet var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.SetSwipeBar()
        
        
        let rightbtn = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(MeetingViewController.PostComplain))
        
        self.navigationItem.rightBarButtonItem = rightbtn
        
        self.btnPersonal.set(image: UIImage(named: "check_blue"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        
        self.btnCommunity.set(image: UIImage(named: "un_check"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        
        items = ["OPEN","CLOSE"]
        self.SwipeNavigation()
//        SetSwipeBar()
        
        self.view.bringSubviewToFront(ResetView)
        
//        let rightbtn = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "PostComplain")
//        
//        self.navigationItem.rightBarButtonItem = rightbtn
        
//        self.performSelector("GetNoticeFromLocalDB:", withObject: NSArray())
        
        
    }
    
    @IBAction func BtnResetFilterClick(_ sender: AnyObject){
        self.ResetView.isHidden = true
        
        if(selectedIndex == 0){
            objRootBooked.GetNoticeBoard(0)
        }
        else{
            objRootClosed.GetNoticeBoard(0)
        }
    }
    
    @objc  func PostComplain(){
        //let objRoot: ComplainAddViewController = ComplainAddViewController(nibName: "ComplainAddViewController", bundle: nil)
        // self.navigationController?.pushViewController(objRoot, animated: true)
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        popup?.handleView.addSubview(FilterView)
        FilterView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
            y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
    @IBAction func BtnFilterSelect(_ sender: AnyObject){
        
        self.ResetView.isHidden = false
        
        let btn = sender as? UIButton
        if(btn!.tag == 0){
            btnPersonal.set(image: UIImage(named: "check_blue"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            
            btnCommunity.set(image: UIImage(named: "un_check"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            if selectedIndex == 0 {
                self.objRootBooked.fillterStr = "Genereal"
                self.tabOneSelectedOption = 0
            }else{
               self.objRootClosed.fillterStr = "Genereal"
                self.tabTwoSelectedOption = 0
            }
            
            
        }
        else{
            btnPersonal.set(image: UIImage(named: "un_check"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            
            btnCommunity.set(image: UIImage(named: "check_blue"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            if selectedIndex == 0 {
                self.objRootBooked.fillterStr = "Committee"
                self.tabOneSelectedOption = 1
            }else{
                self.objRootClosed.fillterStr = "Committee"
                self.tabTwoSelectedOption = 1
            }
           
        }
        
        popup?.hide(animated: true)
    }
    
    @IBAction func BtnFilterViewClose(_ sender: AnyObject){
        popup?.hide(animated: true)
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "MEETING"
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
        
        for (index, _) in items.enumerated() {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(widthOfScreen, forSegmentAt: index)
        }
      
        
        let font = UIFont (name: "HelveticaNeue-Medium", size: 17)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6), font: font!)
        
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: font!)
    }
    

    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            self.selectedIndex = 0
            self.CheckBoxChangeSelection()
            return objRootBooked
        case 1:
            self.selectedIndex = 1
            self.CheckBoxChangeSelection()
            return objRootClosed

        default:
            
            return objRootClosed
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        self.selectedIndex = Int(index)
        
        self.CheckBoxChangeSelection()
    }
    
    func CheckBoxChangeSelection(){
        if(self.selectedIndex == 0){
            if self.tabOneSelectedOption == 0 {
                btnPersonal.set(image: UIImage(named: "check_blue"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
                btnCommunity.set(image: UIImage(named: "un_check"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            }else{
                btnPersonal.set(image: UIImage(named: "un_check"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
                btnCommunity.set(image: UIImage(named: "check_blue"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            }
            
            
        }
        else{
            if self.tabTwoSelectedOption == 0 {
                btnPersonal.set(image: UIImage(named: "check_blue"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
                btnCommunity.set(image: UIImage(named: "un_check"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            }else{
                btnPersonal.set(image: UIImage(named: "un_check"), title: "  Genereal", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
                btnCommunity.set(image: UIImage(named: "check_blue"), title: "  Committee", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
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
