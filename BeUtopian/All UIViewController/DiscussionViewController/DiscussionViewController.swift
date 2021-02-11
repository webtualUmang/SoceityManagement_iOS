//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DiscussionViewController: UIViewController, AddDiscussionDelegate,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var NoticeBoardIDArray: NSMutableArray = NSMutableArray()
    var filtterResultList: NSArray = NSArray()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var btnOption1: UIButton!
    @IBOutlet var btnOption2: UIButton!
    @IBOutlet var FilterView: UIView!
    var popup: KOPopupView?
    @IBOutlet var btnPluse: UIButton!

    var isFiltter : String = "false"
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet var ResetView: UIView!
    @IBOutlet var lblResult: UILabel!
    
    //Paging
    @IBOutlet var noResultFoundLabel : UILabel!
    @IBOutlet var footerView : UIView!
    var currentPageCode : Int = 0
    var loadingStatus = LoadMoreStatus.loading
    @IBOutlet weak var bottomConstant:NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomConstant.constant = -40
        // Do any additional setup after loading the view.
        
     //   self.btnPluse.layer.cornerRadius = self.btnPluse.frame.height / 2
        let nibName = UINib(nibName: "DiscussionCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "DiscussionCell")
        
        //self.performSelector("GetNoticeBoard:", withObject: "0")
        
        //Paging
        self.GetNoticeBoard(self.currentPageCode)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
       /* refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)*/
        
        
        self.FiltterOptions()
    }
    @objc func PostComplain()
    {
       // self.bottomConstant.constant = 0
        if (popup == nil) {
            popup = KOPopupView()
        }
        popup?.handleView.addSubview(FilterView)
        FilterView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
            y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
    @IBAction func BtnResetFilterClick(_ sender: AnyObject){
        self.ResetView.isHidden = true
        self.bottomConstant.constant = -40
        self.isFiltter = "false"
//        self.performSelector("GetNoticeBoard:", withObject: "0")
        
        //Paging
        self.currentPageCode = 0
        self.GetNoticeBoard(self.currentPageCode)
    }
    
    func FiltterOptions()
    {
        let rightbtn = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action:#selector(self.PostComplain))
        
        self.navigationItem.rightBarButtonItem = rightbtn
        
       /* let frames = UIScreen.mainScreen().bounds.size
        let menuButtonSize: CGSize = CGSize(width: 70.0, height: 70.0)
        
        let menuButtons = UIView(frame: CGRect(origin: CGPointZero, size: menuButtonSize))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.setImage(UIImage(named: "add_plus"), forState: .Normal)
        button.addTarget(self, action: "AddCoplains", forControlEvents: .TouchUpInside)
        
        menuButtons.center = CGPoint(x: frames.width - 50.0, y: frames.height - 50.0)
        menuButtons.addSubview(button)
        
//        self.view.addSubview(menuButtons)
        self.view.insertSubview(menuButtons, aboveSubview: tableView)*/
        
        btnOption1.set(image: UIImage(named: "check_blue"), title: "  All Member", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
       
        btnOption2.set(image: UIImage(named: "un_check"), title: "  My Discussion", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
    }
    
    @IBAction func BtnFilterSelect(_ sender: AnyObject){
        let btn = sender as? UIButton
        if(btn!.tag == 0){
            btnOption1.set(image: UIImage(named: "check_blue"), title: "  All Member", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            
            btnOption2.set(image: UIImage(named: "un_check"), title: "  My Discussion", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            
            self.isFiltter = "all"
            
            self.lblResult.text = String(format: "Result for %@", (btnOption1.titleLabel?.text)!)
        }
        else{
            btnOption1.set(image: UIImage(named: "un_check"), title: "  All Member", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            
            btnOption2.set(image: UIImage(named: "check_blue"), title: "  My Discussion", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            self.isFiltter = "my"
            
            self.lblResult.text = String(format: "Result for%@", (btnOption2.titleLabel?.text)!)
        }
        
        self.ResetView.isHidden = false
        
        
        DispatchQueue.main.async
            {
           
            self.CreateCell(self.filtterResultList)
            
        }
        self.bottomConstant.constant = 0
        
        popup?.hide(animated: true)
    }
    
    @IBAction func BtnFilterViewClose(_ sender: AnyObject)
    {
        self.bottomConstant.constant = 0
        popup?.hide(animated: true)
    }
    
    @IBAction func AddCoplains(_ sender: AnyObject)
    {
        let objRoot: DiscussionAddViewController = DiscussionAddViewController(nibName: "DiscussionAddViewController", bundle: nil)
        objRoot.delegate = self
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
   
    func reloadDisscutionData()
    {
//        self.performSelector("GetNoticeBoard:", withObject: "0")
        
        //Paging
        
        self.GetNoticeBoard(self.currentPageCode)
    }
    
    
    //Pull to refresh
  /*  func refresh(sender:AnyObject) {
        // Code to refresh table view
        //        self.performSelector("GetNoticeFromLocalDB:", withObject: NSArray())
        //self.performSelector("GetNoticeBoard:", withObject: "0")
        
        //Paging
        self.GetNoticeBoard(self.currentPageCode)
        
        self.isFiltter = "false"
    }*/
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Discussion"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
       
        
        
        if ((self.navigationController!.presentingViewController) != nil)
        {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: "dismiss")
        }
        
        if isDataAddedToSociety == true {
            isDataAddedToSociety = false
            //self.performSelector("GetNoticeBoard:", withObject: "0")
            
            //Paging
            self.GetNoticeBoard(self.currentPageCode)
        }
    }
    func dismiss()
    {
        self.dismiss(animated: true) {
            
        }
    }
    func CreateCell(_ resultList : NSArray)
    {
        self.ComplainsCells.removeAllObjects()
        
//        let tempArray = NSMutableArray()
//        
//        if NoticeBoardIDArray.count > 0{
//            
//            for item in NoticeBoardIDArray {
//                
//                if let dic = item as? NSDictionary {
//                    
//                    if let noticeid = dic.objectForKey("discusID") as? String {
//                        
//                        let predicate: NSPredicate = NSPredicate(format: "SELF CONTAINS[cd] %@", noticeid)
//                        let filteredArray: NSArray = resultList.filteredArrayUsingPredicate(predicate)
//                        
//                        if(filteredArray.count > 0){
//                            if let getdic: NSDictionary = filteredArray.objectAtIndex(0) as? NSDictionary {
//                                tempArray.addObject(getdic)
//                            }
//                        }
//                        else{
//                            //Delete
//                            print(noticeid)
//                            //                            DeleteNoticeFromLocalDB(noticeid)
//                        }
//                    }
//                }
//            }
//        }

        
//        ComplainsCells = NSMutableArray()
        
        for data in resultList {
            if let tempData = data as? NSDictionary {
                let cell: DiscussionCell! = self.tableView.dequeueReusableCell(withIdentifier: "DiscussionCell") as? DiscussionCell

                    cell.data = tempData
                if let tempStr = tempData.object(forKey: "title") as? String {
                    cell.lblTile.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "ago") as? String {
                    cell.lblDate.text = tempStr
                }
                
                if let tempStr = tempData.object(forKey: "user_name") as? String {
                    cell.lblUserName.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "replies") as? String {
                    if tempStr == "0" {
                        cell.lblReply.isHidden = true
                    }else{
                        cell.lblReply.text = tempStr
                    }
                    
                }
                if let tempStr = tempData.object(forKey: "desc") as? String {
                    cell.lblDesc.text = tempStr// tempStr.base64Decoded
                }
                
                if let tempStr = tempData.object(forKey: "user_image") as? String {
                    if tempStr.isEmpty == false {
                        let urlString : URL = URL(string: tempStr)!
                        cell.userImage.clipsToBounds = true
                        cell.userImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil {
                                cell.userImage.image = image
                            }
                            
                        })
                        
                    }
                }

                if self.isFiltter.caseInsensitiveCompare("false") == .orderedSame || self.isFiltter.caseInsensitiveCompare("all") == .orderedSame
                {
                    ComplainsCells.add(cell)
                }
                else
                {
                    if let tempStr = tempData.object(forKey: "type") as? String
                    {
                        if tempStr.caseInsensitiveCompare(self.isFiltter) == .orderedSame
                        {
                            ComplainsCells.add(cell)
                        }
                    }
                }
                
            }
            
            if(ComplainsCells.count == 0){
                lblNoData.isHidden = false
            }
            else{
                lblNoData.isHidden = true
            }
            
            DispatchQueue.main.async
                {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    //MARK: - TableView Delegate Method
    
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if let cell = ComplainsCells.object(at: indexPath.row) as? DiscussionCell {
            return cell.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? DiscussionCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? DiscussionCell {
            let objRoot: DiscussionDetailsViewController = DiscussionDetailsViewController(nibName: "DiscussionDetailsViewController", bundle: nil)
            if let tempDta = cell.data {
                objRoot.disussionData = tempDta as! [AnyHashable: Any]
            }
//            self.UpdateStatus(cell.data!)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        
    }
    
    
    //Paging
    //MARK:- Load More -
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if loadingStatus == .haveMore {
            return self.footerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if loadingStatus == .haveMore {
            return 60.0
        }
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        if self.loadingStatus == .haveMore {
            
            self.perform(#selector(DiscussionViewController.loadMore), with: nil, afterDelay: 0.5)
            
        }
    }
    @objc func loadMore()
    {
        if self.loadingStatus != .finished && self.loadingStatus != .loading{
            self.loadingStatus = .loading
            self.currentPageCode = self.currentPageCode + 1
            self.GetNoticeBoard(self.currentPageCode)
            
            
        }else{
            if self.loadingStatus == .finished {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
            
        }
        
    }

    
    
    //MARK: - API Delegate -
    
    /*func GetNoticeBoard(idStr : String)
    {
        
        let urlStr = String(format: "%@?view=discussion&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
//                                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.objectForKey("msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.objectForKey("discus_list") as? NSArray {
                                dispatch_async(dispatch_get_main_queue()) {
                                    
//                                    self.NoticeBoardIDArray = MyDbManager.sharedClass().Sorting(NSMutableArray(array: bannerList), sortBool: false, sortingKey: "discusID")
                                    
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.filtterResultList = NSArray(array: bannerList)
                                        self.CreateCell(bannerList)
                                        
                                    })

                                }
                                
                                
                            }
                        }
                    }
                }
                if self.refreshControl.refreshing == true {
                   self.refreshControl.endRefreshing()
                }
                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.objectForKey(kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                if self.refreshControl.refreshing == true {
                    self.refreshControl.endRefreshing()
                }
            }
        }
        
    }*/
    
    func GetNoticeBoard(_ pageCode : Int)
    {
        print(pageCode)
        if pageCode == 0
        {
            self.ComplainsCells = NSMutableArray()
        }
        
       let urlStr = String(format: "%@?view=discussion_paginate&page=list&userID=%@&societyID=%@&pagecount=%d", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
        
        
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self)
        { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "discus_list") as? NSArray {
                                print(bannerList)
                                DispatchQueue.main.async {
                                    
                                    self.loadingStatus = .haveMore
                                    
                                    DispatchQueue.main.async {
                                        
                                        DispatchQueue.main.async {
                                            
                                            if self.ComplainsCells.count > 0 || bannerList.count > 0 {
                                                self.IsNoResultFound(true)
                                                self.filtterResultList = NSArray(array: bannerList)
                                                self.CreateCell(bannerList)
                                            }else{
                                                self.IsNoResultFound(false)
                                            }
                                        }
                                    }                                    //
                                }
                                
                            }
                        }else{
                            self.loadingStatus = .finished
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                                if self.ComplainsCells.count > 0{
                                    self.IsNoResultFound(true)
                                }else{
                                    self.IsNoResultFound(false)
                                }
                            }
                        }
                    }else{
                        self.loadingStatus = .finished
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }else{
                    self.loadingStatus = .finished
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
    //MARK: - API Delegate -
    func IsNoResultFound(_ isFound : Bool){
        DispatchQueue.main.async {
            if isFound == true {
                self.lblNoData.isHidden = true
                self.tableView.isHidden = false
            }else{
                self.lblNoData.isHidden = false
                self.tableView.isHidden = true
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
