//
//  ComplainsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class PollsViewController: UIViewController,CarbonTabSwipeNavigationDelegate
{

    let customize = true
    let showImageOnButton = false
    let titleBarDataSource = ["Details", "Order lines", "Audit Trail"]
    
    let objRootBooked = PollsOpenViewController(nibName: "PollsOpenViewController", bundle: nil)
    let objRootClosed = PollsCloseViewController(nibName: "PollsCloseViewController", bundle: nil)
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()
    
    //Popup
    @IBOutlet var MemberView: UIView!
    @IBOutlet var lbltitle: UILabel!
    var popup: KOPopupView?
    
    @IBOutlet var imgAllPolls: UIImageView!
    @IBOutlet var imgAddPolls: UIImageView!
    @IBOutlet var btnAddPoll: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.SetSwipeBar()
        items = ["OPEN","CLOSE"]
        self.SwipeNavigation()
//        SetSwipeBar()
        
        
        
//        self.view.insertSubview(UIView, aboveSubview: btnAddPoll)
        self.view.bringSubviewToFront(btnAddPoll)
        
        
        let rightbtn = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action:#selector(PostComplain))
        
      //  self.navigationItem.rightBarButtonItem = rightbtn
    }
    @objc func PostComplain()
    {
        OpenRegardPopups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Polls"
        
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
    
    @IBAction func BtnAddPollClick(_ sender: AnyObject){
        let rootObj: AddPollViewController = AddPollViewController(nibName: "AddPollViewController", bundle: nil)
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    @IBAction func BtnCloseViewClick(_ sender: AnyObject){
        popup?.hide(animated: true)
    }
    
    @IBAction func BtnAddPollsClick(_ sender: AnyObject){
        
        let btn = sender as? UIButton
        
        if(btn!.tag == 0){
            imgAllPolls.image = UIImage(named: "check_blue")
            imgAddPolls.image = UIImage(named: "un_check")
            self.objRootBooked.fillterStr = "All polls"
        }
        else{
            imgAllPolls.image = UIImage(named: "un_check")
            imgAddPolls.image = UIImage(named: "check_blue")
            self.objRootBooked.fillterStr = "My added polls"
        }
    }
   
    func OpenRegardPopups(){
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        
        let frames = UIScreen.main.bounds.size
        
        if(frames.width == 320){
            popup?.frame.origin.y -= 50
        }
        
        popup?.handleView.addSubview(MemberView)
        
        MemberView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                        y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
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
        
    }
    

    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
//            let objRoot: PollsOpenViewController = PollsOpenViewController(nibName: "PollsOpenViewController", bundle: nil)
            
            return objRootBooked
        case 1:
//            let objRoot: PollsCloseViewController = PollsCloseViewController(nibName: "PollsCloseViewController", bundle: nil)
            return objRootClosed
        default:
//            let objRoot: PollsCloseViewController = PollsCloseViewController(nibName: "PollsCloseViewController", bundle: nil)
            return objRootClosed
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
