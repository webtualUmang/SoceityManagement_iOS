//
//  SliderLeftMenu.swift
//  BeUtopian
//
//  Created by TNM3 on 12/26/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class SliderLeftMenu: UIView,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var profileImage : UIImageView!
    


    var LoginList : NSArray = [["Title":"My Society","Image":"flat"],["Title":"My Unit","Image":"flat"],
         ["Title":"Update","Image":"myaccountnotification"],
        ["Title":"About Wgate","Image":"be"],
        ["Title":"Invite Friends","Image":"invitefriend"],
        ["Title":"Rate Us","Image":"star"],
        ["Title":"Language","Image":"language"],
        ["Title":"Logout","Image":"logout"]
    ]
    var demoList : NSArray = [
        ["Title":"About Wgate","Image":"be"],
        ["Title":"Rate Us","Image":"star"],
        ["Title":"Logout","Image":"logout"]
    ]
    var MenuList = NSArray()
    
    
    @IBOutlet var lblFirstName : UILabel!
    @IBOutlet var lblLastName : UILabel!
    @IBOutlet var lblSocietyName : UILabel!
    
    
    @IBOutlet var tablemenu: UITableView!
    
    var parentViewController : UIViewController?
    
    @IBOutlet var headerView: UIView!
    
    class func instanceFromNib() -> SliderLeftMenu {
        return UINib(nibName: "SliderLeftMenu", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SliderLeftMenu
    }
    
    override func awakeFromNib() {
        self.frame = UIScreen.main.bounds
        self.tablemenu.tableHeaderView = self.headerView
        self.headerView.backgroundColor = AppColor.PRIMARY_COLOR
       self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
        self.usersetup()
        self.SetUserProfileData()
    }
    
    func usersetup()
    {
        if getLoginUser().count > 0
        {
            self.MenuList = self.LoginList
            

        }
        else
        {
            self.MenuList = self.demoList
        }
        self.tablemenu.reloadData()
    }
    @IBAction func deskboardClick(_ sender : AnyObject){
//        let objRoot: DeskBoardViewController = DeskBoardViewController(nibName: "DeskBoardViewController", bundle: nil)
//        self.navigate = UINavigationController(rootViewController: objRoot)
//        appDelegate.SetNavigationBar(self.navigate!)
//        self.sidePanelController?.centerPanel = self.navigate
        
    }
    @IBAction func profileClick(_ sender : AnyObject){
        self.OpenSubMenu("profile")
    }
    
    
    func SetUserProfileData()
    {
        if getUserDetails().count > 0
        {
            let data = getUserDetails()
                   
                   if let tempStr = data.object(forKey: "f_name") as? String
                   {
                    if let lastName = data.object(forKey: "l_name") as? String
                    {
                       self.lblFirstName.text = tempStr + " \(lastName)"
                    }
                    else
                    {
                        self.lblFirstName.text = tempStr
                    }
                   }
                   else
                   {
                       self.lblLastName.text = "Demo User"
                   }
                   if let tempStr = data.object(forKey: "email") as? String {
                       self.lblLastName.text = tempStr
                   }
                   else
                   {
                       self.lblLastName.text = "Demo Email"
                   }
                   
                   if let tempStr = data.object(forKey: "user_image") as? String {
                       if tempStr.isEmpty == false {
                           let urlString : URL = URL(string: tempStr)!
                           self.profileImage.clipsToBounds = true
                           self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                               if image != nil {
                                   self.profileImage.image = image
                               }
                               
                           })
                           
                       }
                   }
                   if let tempStr = getLoginUser().object(forKey: "societyName") as? String {
                       self.lblSocietyName.text =  "    \(tempStr)"
                   }
                   else
                   {
                       self.lblSocietyName.text = "    Wgate"
                   }
        }
        else
        {
            
        let data = getLoginUser()
        
        if let tempStr = data.object(forKey: "firstname") as? String {
            self.lblFirstName.text = tempStr
        }
        else
        {
            self.lblLastName.text = "Demo User"
        }
        if let tempStr = data.object(forKey: "email") as? String {
            self.lblLastName.text = tempStr
        }
        else
        {
            self.lblLastName.text = "Demo Email"
        }
        
        if let tempStr = data.object(forKey: "userimage") as? String {
            if tempStr.isEmpty == false {
                let urlString : URL = URL(string: tempStr)!
                self.profileImage.clipsToBounds = true
                self.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                    if image != nil {
                        self.profileImage.image = image
                    }
                    
                })
                
            }
        }
        if let tempStr = data.object(forKey: "societyName") as? String {
            self.lblSocietyName.text =  "    \(tempStr)"
        }
        else
        {
            self.lblSocietyName.text = "    Wgate"
        }
        }
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView){
    //        let sectionHeaderHeight: CGFloat = 45
    //        if(scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0){
    //            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
    //        }
    //        else if(scrollView.contentOffset.y >= sectionHeaderHeight){
    //            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
    //        }
    //    }
    
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let identifier = "LeftMenuCell"
        var cell: LeftMenuCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? LeftMenuCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? LeftMenuCell
        }
        cell.downline.isHidden = true
        
        if let data = MenuList.object(at: indexPath.row) as? NSDictionary {
            if let tempStr = data.object(forKey: "Title") as? String {
                cell.lblTitle.text = tempStr
                if  tempStr == "Language" || tempStr == "Update" {
                    cell.downline.isHidden = false
                }else{
                    cell.downline.isHidden = true
                }
            }
            if let tempStr = data.object(forKey: "Image") as? String {
                cell.leftImage.image = UIImage(named:tempStr)
                cell.leftImage.image = cell.leftImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                cell.leftImage.tintColor = .white
             
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
//        self.sidePanelController?.showLeftPanelAnimated(true)
        if let cell = tableView.cellForRow(at: indexPath) as? LeftMenuCell {
            if let titleStr = cell.lblTitle.text {
                DispatchQueue.main.async {
                    // update some UI
                    self.OpenSubMenu(titleStr)
                }
            }
        }
        
    }
//    func OpenSubMenu(titleStr : String){
//        
////        self.sidePanelController?.showCenterPanelAnimated(true)
////        if titleStr == "Invite Friends" {
////            self.shareTextImageAndURL()
////        }else if titleStr == "Rate Us" {
////            self.RateThisApp()
////        }
////        else if let navigationControler = self.sidePanelController?.centerPanel as? UINavigationController {
////            
////            if navigationControler.viewControllers.count > 0 {
////                if let tempVC = navigationControler.viewControllers[navigationControler.viewControllers.count - 1] as? DeskBoardViewController {
////                    tempVC.OpenSubMenu(titleStr)
////                }
////            }
////            
////        }
//        
//        
//    }
    //MARK:- SHAREKIT
    func shareTextImageAndURL()
    {
        let strText = "Discover and share all the facts and figures about the world's best-supported football club Manchester United. Download the Stretford End app today on your iPhone or Android: http://www.yahoo.com"
        var sharingItems = [AnyObject]()
        
        if let text = strText as String?
        {
            sharingItems.append(text as AnyObject)
        }
        
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.parentViewController!.present(activityViewController, animated: true, completion: nil)
    }
    
    func RateThisApp(){
        self.parentViewController!.dismiss(animated: true, completion: nil)
        let url: URL = URL(string: "http://goo.gl/UsWbtc")!
        UIApplication.shared.openURL(url)
    }
    func MainThread(_ titleStr : String){
//        if let navigationControler = self.sidePanelController?.centerPanel as? UINavigationController {
//            print(navigationControler.viewControllers)
//            if navigationControler.viewControllers.count > 0 {
//                if let tempVC = navigationControler.viewControllers[navigationControler.viewControllers.count - 1] as? DeskBoardViewController {
//                    tempVC.OpenSubMenu(titleStr)
//                }
//            }
//            
//        }
    }
    //MARK:- Open Slider ViewController -
    func OpenSubMenu(_ titleStr : String){
        
        if titleStr.caseInsensitiveCompare("About Wgate") == .orderedSame {
            let objRoot: AboutViewController = AboutViewController(nibName: "AboutViewController", bundle: nil)
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
        }else if titleStr.caseInsensitiveCompare("Help / Support") == .orderedSame {
          //  let objRoot: SupportViewController = SupportViewController(nibName: "SupportViewController", bundle: nil)
            //self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
            self.parentViewController!.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if titleStr.caseInsensitiveCompare("Visitor") == .orderedSame {
            let objRoot: VisitorViewController = VisitorViewController(nibName: "VisitorViewController", bundle: nil)
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
        }else if titleStr.caseInsensitiveCompare("Logout") == .orderedSame {
            
            let alertview = UIAlertController(title: "", message: "Do you want to logout?", preferredStyle: .alert)
            
            let NoAction = UIAlertAction(title: "No", style: .cancel) { (alert) in
                
            }
            
            let YesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
                
                let objRoot: VerifyMobileViewController = VerifyMobileViewController(nibName: "VerifyMobileViewController", bundle: nil)
                let navigation = UINavigationController(rootViewController: objRoot)
                appDelegate.SetNavigationBar(navigation)
                appDelegate.window?.rootViewController = navigation
                RemoveLoginUser()
            }
            
            alertview.addAction(NoAction)
            alertview.addAction(YesAction)
            
            appDelegate.window?.rootViewController!.present(alertview, animated: true, completion: nil)
            
        }else if titleStr.caseInsensitiveCompare("My Society") == .orderedSame {
            let objRoot: SocietyViewController = SocietyViewController(nibName: "SocietyViewController", bundle: nil)
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("My Unit") == .orderedSame
        {
            ///let objRoot: MyFlatViewController = MyFlatViewController(nibName: "MyFlatViewController", bundle: nil)
            //self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MyFlatViewController")
            self.parentViewController!.navigationController?.pushViewController(vc, animated: true)
           // self.present(vc, animated: true)
        }
            
        else if titleStr.caseInsensitiveCompare("Blog") == .orderedSame {
            let objRoot: BrowserViewController = BrowserViewController(nibName: "BrowserViewController", bundle: nil)
            objRoot.websiteUrl = "http://sms.thewebtual.com/blog/"
            objRoot.navigationTitle = "Blog"
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("profile") == .orderedSame {
            let objRoot: ProfileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("Update") == .orderedSame {
            let objRoot: UpdateViewController = UpdateViewController(nibName: "UpdateViewController", bundle: nil)
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("Invite Friends") == .orderedSame {
            let shareText = "Welcome to # WGate - Smart Society App! # \n Now stay Connected, Involved and Updated with all information of # your Society # on your Mobile! \n Please download it today from https://goo.gl/RRjP3y \n\nFor demo / product related inquiry please call us on +91 99786 19808 or visit http://wgate.thewebtual.com"
             
            let shareList : NSArray = [shareText]
            
            appDelegate.ShareDetailsResult(shareList)
            
        }else if titleStr.caseInsensitiveCompare("Rate Us") == .orderedSame {
            self.rateApp()
        }
        else if titleStr.caseInsensitiveCompare("Language") == .orderedSame {
            let objRoot: LanguageViewController = LanguageViewController(nibName: "LanguageViewController", bundle: nil)
            self.parentViewController!.navigationController?.pushViewController(objRoot, animated: true)
        }
    }

    func rateApp(){
        let url = UserDefaults.standard.value(forKey:"iphone_appurl") as? String ?? ""
        UIApplication.shared.openURL(URL(string: url)!)
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
