//
//  ExploreViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 5/4/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController,imageSliderDelegate, UITableViewDelegate, UITableViewDataSource,ExploreAccountDelegate {


     @IBOutlet var headerView : UIView!
//    @IBOutlet var headerView : CLabsImageSlider!
    @IBOutlet var tableView : UITableView!
 
    @IBOutlet var lblMessage : UILabel!
 @IBOutlet var viewMessage : UIView!

    @IBOutlet var bottomView : UIView!
    
    var menuList : NSMutableArray = NSMutableArray()
    var imageUrls = NSArray()
 
    let BannerSlider = ImageSliderView.instanceFromNib()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.viewMessage.layer.cornerRadius = 10
        
        self.viewMessage.layer.shadowColor = UIColor.black.cgColor
        self.viewMessage.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewMessage.layer.shadowOpacity = 0.2
        self.viewMessage.layer.shadowRadius = 4.0
        
       // self.tableView.backgroundColor = UIColor.groupTableViewBackground
        
        let nibName2 = UINib(nibName: "ExploreTypeCell", bundle: nil)
        self.tableView .register(nibName2, forCellReuseIdentifier: "ExploreTypeCell")
        let nibName = UINib(nibName: "ExploreAccountCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "ExploreAccountCell")
        self.perform(#selector(self.GetDeskBoardBanner), with:nil, afterDelay:0.5)
        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = self.headerView
      //  self.perform(#selector(ExploreViewController.GetDeskBoardBanner))
    }
    
    //MARK:- API -
    
    @objc func GetDeskBoardBanner()
    {
        
        let urlStr = String(format: "%@?view=home&page=list&userID=%@&societyID=%@&gtoken=%@&gdevice=%@&type=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,iDeviceToken,iDeviceUDID,iDeviceType])
        
        //        let urlStr = String(format: "%@?view=banner&page=home&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0"
                        {
                            UserDefaults.standard.set(ResultData["iphone_appurl"] as? String ?? "", forKey:"iphone_appurl")
                            
                            //CreateCell
                            DispatchQueue.main.async {
                                self.lblMessage.text = ResultData["quote"] as? String ?? ""
                                self.lblMessage.textAlignment = .center
                                self.tableView.reloadData()
                                
                                 self.CreateCell(ResultData)
                            }
                            //
                            if let bannerList = ResultData.object(forKey: "banner_image") as? NSArray
                            {
                                let bannerUrls = NSMutableArray()
                                for bannerData in bannerList {
                                    if let tempData = bannerData as? NSDictionary {
                                        if let tempStr = tempData.object(forKey: "image") as? String {
                                            bannerUrls.add(tempStr)
                                        }
                                    }
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    self.LoadBanner(bannerUrls)
                                    
                                }
                            }
                           
                            //Check Version
                            DispatchQueue.main.async {
                                self.CheckVersion(ResultData)
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
    func LoadBanner(_ urlImages : NSArray){
        
        
        DispatchQueue.main.async {
            
            self.imageUrls = NSArray(array: urlImages)
            self.BannerSlider.imageUrls = self.imageUrls
            
            self.BannerSlider.imageUrls = self.imageUrls
            
            self.BannerSlider.frame = self.headerView.frame
            self.headerView.addSubview(self.BannerSlider)
            
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    func didMovedToIndex(_ index:Int)
    {
        print("did moved at Index : ",index)
    }
   
    //MARK: - TableView Delegate Method
    func CreateCell(_ resultList : NSDictionary){
        
        
        self.menuList = NSMutableArray()
        
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExploreAccountCell") as? ExploreAccountCell {
            cell.data = resultList
            cell.delegate = self
            if let tempStr = resultList.object(forKey: "flat_name") as? String {
                cell.lblFlat.text = tempStr
                UserDefaults.standard.set(tempStr, forKey:"flat_name")
                UserDefaults.standard.synchronize()
            }
            if let tempStr = resultList.object(forKey: "unpaid") as? String {
                cell.lblInvoice.text = String(format: "₹ %@", tempStr)
            }
            if let tempStr = resultList.object(forKey: "total_unpaid") as? String {
                cell.lblDue.text = String(format: "₹ %@", tempStr)
            }
            var paid = ""
            if let tempStr = resultList.object(forKey: "paid") as? String {
                paid = tempStr
            }
            if let tempStr = resultList.object(forKey: "paid") as? NSNumber {
                paid = tempStr.stringValue
            }
            cell.lblCompleted.text = String(format: "₹ %@", paid)
            
            self.menuList.add(cell)
            
        }
        
        DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
            
        }
        
        if self.menuList.count > 0 {
            self.tableView.tableFooterView = self.bottomView
        }else{
            self.bottomView.frame.size.height = self.tableView.frame.size.height - self.headerView.frame.height
            self.tableView.tableFooterView = self.bottomView
            self.bottomView.frame.size.height = self.tableView.frame.size.height - self.headerView.frame.height
            self.tableView.tableFooterView = self.bottomView
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        else
        {
            return self.menuList.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
        {
            return 120
        }
        else
        {
            return 147

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreTypeCell") as? ExploreTypeCell
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            return cell!
        }
        else
        {
            if self.menuList.count > indexPath.row
                   {
                       if let cell = self.menuList.object(at: indexPath.row) as? ExploreAccountCell
                       {
                           return cell
                       }
                   }
            else
            {
                UITableViewCell()
            }
            
        }
       
        
       return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            let objRoot: AlertviewListController = AlertviewListController(nibName: "AlertviewListController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
//        if (tableView.cellForRow(at: indexPath) as? ExploreAccountCell) != nil {
////            let objRoot: AccountTransactionViewController = AccountTransactionViewController(nibName: "AccountTransactionViewController", bundle: nil)
////            if let tempStr = cell.data.objectForKey("flat_id") as? String {
////                appDelegate.FlatID = tempStr
////            }
////            self.navigationController?.pushViewController(objRoot, animated: true)
//        }
        
        
    }
    
    //MARK:- Shortcut -
    @IBAction func nieghbourClick(){
        let objRoot: DirectoryViewController = DirectoryViewController(nibName: "DirectoryViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func discussionClick()
    {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objRoot = storyboard.instantiateViewController(withIdentifier: "DiscussionViewController")
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func ComplainsClick()
    {
        
       // let objRoot: ComplainsViewController = ComplainsViewController(nibName: "ComplainsViewController", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let objRoot = storyboard.instantiateViewController(withIdentifier: "ComplainsViewController")
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    @IBAction func CommiteeClick(){
        let objRoot: DirectoryViewController = DirectoryViewController(nibName: "DirectoryViewController", bundle: nil)
        objRoot.defaultSelectedIndex = 2
        self.navigationController?.pushViewController(objRoot, animated: true)
        
    }
    
    //MARK: - Version Popups -
    func CheckVersion(_ data : NSDictionary){
//        var liveVersionStr = "1.0"
        var appVersionStr = "1.0"
//
        if let nsObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            appVersionStr = nsObject
        }
//        if let tempStr = data.object(forKey: "iphone_version") as? String
//        {
//            liveVersionStr = tempStr
//        }
        if appVersionStr != data["iphone_version"] as? String ?? ""
        
//        var liveVersion : Float = 1.0
//        var appVersion : Float = 1.0
//
//        if appVersionStr.isEmpty == false {
//            if let tempVersion = Float(appVersionStr) {
//                appVersion = tempVersion
//            }
//        }
//
//        if liveVersionStr.isEmpty == false {
//            if let tempVersion = Float(liveVersionStr) {
//                liveVersion = tempVersion
//            }
//        }
        
        //
       // if appVersion < liveVersion
        {
            var message = ""
            if let tempStr = data.object(forKey: "iphone_msg") as? String {
                message = tempStr
            }
            
            
            let refreshAlert = UIAlertController(title: "Version Update!", message: message, preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                exit(0)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action: UIAlertAction!) in
                if let urlstr = data.object(forKey: "iphone_appurl") as? String {
                     let url  = URL(string: urlstr)
                                   if UIApplication.shared.canOpenURL(url!) {
                                       UIApplication.shared.openURL(url!)
                                   }
                }
               
                
            }))
            DispatchQueue.main.async
                {
                appDelegate.window?.visibleViewController?.present(refreshAlert, animated: true, completion: { () -> Void in
                    
                })
                
            }
        }
        
    }
    
    //MARK:- Cell Delegate -
    func didSelectIndex(_ index: Int, data: NSDictionary) {
        if index == 2 {
            let objRoot: AccountTransactionViewController = AccountTransactionViewController(nibName: "AccountTransactionViewController", bundle: nil)
            objRoot.defaultSelectedIndex = 1
            if let tempStr = data.object(forKey: "flat_id") as? String {
                appDelegate.FlatID = tempStr
            }
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else{
            let objRoot: AccountTransactionViewController = AccountTransactionViewController(nibName: "AccountTransactionViewController", bundle: nil)
            if let tempStr = data.object(forKey: "flat_id") as? String {
                appDelegate.FlatID = tempStr
            }
            objRoot.defaultSelectedIndex = 0
            self.navigationController?.pushViewController(objRoot, animated: true)
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
