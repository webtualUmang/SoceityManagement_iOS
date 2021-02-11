//
//  LeftNavigationMenu.swift
//  BeUtopian
//
//  Created by desap on 13/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class LeftNavigationMenu: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profileImage : UIImageView!
    
    var MenuList : NSArray = [["Title":"My Society","Image":"flat"],["Title":"Visitor","Image":"side_visitor"],
        ["Title":"Update","Image":"myaccountnotification"],
        ["Title":"Blog","Image":"blog"],
        ["Title":"About Wgate","Image":"be"],
        ["Title":"Invite Friends","Image":"invitefriend"],
        ["Title":"Rate Us","Image":"star"],
        ["Title":"Help / Support","Image":"help_support"],
        ["Title":"Language","Image":"language"],
        ["Title":"Logout","Image":"logout"]
    ]
    

    @IBOutlet var lblFirstName : UILabel!
    @IBOutlet var lblLastName : UILabel!
    @IBOutlet var lblSocietyName : UILabel!

    
    @IBOutlet var tablemenu: UITableView!
    var navigate: UINavigationController?
    
    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tablemenu.tableHeaderView = self.headerView
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height / 2
        
        // Do any additional setup after loading the view.
    }

    @IBAction func deskboardClick(_ sender : AnyObject){
        let objRoot: HomeRootViewController = HomeRootViewController(nibName: "HomeRootViewController", bundle: nil)
        self.navigate = UINavigationController(rootViewController: objRoot)
        appDelegate.SetNavigationBar(self.navigate!)
        self.sidePanelController?.centerPanel = self.navigate

    }
    @IBAction func profileClick(_ sender : AnyObject){
        self.OpenSubMenu("profile")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.SetUserProfileData()
        }

    }
    func SetUserProfileData()
    {
        let data = getLoginUser()
        
        if let tempStr = data.object(forKey: "firstname") as? String {
            self.lblFirstName.text = tempStr
        }
        if let tempStr = data.object(forKey: "email") as? String {
            self.lblLastName.text = tempStr
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
            self.lblSocietyName.text =   "  \(tempStr)"
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
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
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
                if tempStr == "Visitor" || tempStr == "Language" {
                    cell.downline.isHidden = false
                }
            }
            if let tempStr = data.object(forKey: "Image") as? String
            {
                cell.leftImage.image = UIImage(named:tempStr)
                               cell.leftImage.image = cell.leftImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                               cell.leftImage.tintColor = .white
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.sidePanelController?.showLeftPanel(animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? LeftMenuCell {
            if let titleStr = cell.lblTitle.text {
                DispatchQueue.main.async {
                    // update some UI
                    self.OpenSubMenu(titleStr)
                }
            }
        }
        
    }
    func OpenSubMenu(_ titleStr : String){

        self.sidePanelController?.showCenterPanel(animated: true)
        if titleStr == "Invite Friends" {
            self.shareTextImageAndURL()
        }else if titleStr == "Rate Us" {
            self.RateThisApp()
        }
        else if let navigationControler = self.sidePanelController?.centerPanel as? UINavigationController {

            if navigationControler.viewControllers.count > 0 {
                if let tempVC = navigationControler.viewControllers[navigationControler.viewControllers.count - 1] as? HomeRootViewController {
                    tempVC.OpenSubMenu(titleStr)
                }
            }
            
        }
 
        
    }
    //MARK:- SHAREKIT
    func shareTextImageAndURL()
    {
        let strText = "Discover and share all the facts and figures about the world's best-supported football club Manchester United. Download the Stretford End app today on your iPhone or Android: http://www.yahoo.com"
        var sharingItems = [String]()
        
        if let text = strText as String?
        {
            sharingItems.append(text)
        }
        
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }

    func RateThisApp(){
        self.dismiss(animated: true, completion: nil)
        let url: URL = URL(string: "http://goo.gl/UsWbtc")!
        UIApplication.shared.openURL(url)
    }
    func MainThread(_ titleStr : String){
        if let navigationControler = self.sidePanelController?.centerPanel as? UINavigationController {
            print(navigationControler.viewControllers)
            if navigationControler.viewControllers.count > 0 {
                if let tempVC = navigationControler.viewControllers[navigationControler.viewControllers.count - 1] as? HomeRootViewController {
                    tempVC.OpenSubMenu(titleStr)
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
