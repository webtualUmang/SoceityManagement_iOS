//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var noResultFoundLabel : UILabel!
    
    var searchBar:UISearchBar = UISearchBar()
    var searchActive : Bool = false
    
    @IBOutlet var footerView : UIView!
    var currentPageCode : Int = 0
    
    var loadingStatus = LoadMoreStatus.loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "EventCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "EventCell")
        
//        self.performSelector("GetNoticeFromLocalDB:", withObject: NSArray())
        self.GetNoticeBoard(self.currentPageCode)
        self.noResultFoundLabel.isHidden = true
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action:#selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        self.tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Events"
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//        self.performSelector("GetNoticeFromLocalDBFinalResult")
        self.NavigationSearchBar()
        
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

    
    //Pull to refresh
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
//        self.performSelector("GetNoticeFromLocalDB:", withObject: NSArray())
        self.currentPageCode = 0
        self.GetNoticeBoard(self.currentPageCode)
    }
    
    func CreateCell(_ resultList : NSArray){
        
        for data in resultList {
            if let tempData = data as? NSDictionary {
                let cell: EventCell! = self.tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
                cell.data = tempData
                if let tempStr = tempData.object(forKey: "title") as? String {
                    cell.lblTitle.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "contact") as? String {
                    cell.lblMobile.text = "Mobile : " + "\(tempStr)"
                               }
                
                if let tempStr = tempData.object(forKey: "image") as? String
                                 {
                                     if tempStr.isEmpty == false {
                                         let urlString : URL = URL(string: tempStr)!
                                         
                                         cell.imgBanner.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                                             if image != nil {
                                                 cell.imgBanner.image = image
                                                
                                             }
                                             
                                         })
                                        cell.imgBanner.contentMode = .scaleAspectFill
                                         
                                     }
                                 }
//                if let tempStr = tempData.objectForKey("day_month") as? String {
//                    let dateArray = tempStr.componentsSeparatedByString("-")
//                    var dayStr = ""
//                    if dateArray.count > 0 {
//                        dayStr = dateArray[0]
//                    }
//                    var monthStr = ""
//                    if dateArray.count > 1 {
//                        monthStr = dateArray[1]
//                    }
//                    cell.lblDayMonth.text = String(format: "%@\n%@", arguments: [dayStr,monthStr])
//                }
                
                if let tempStr = tempData.object(forKey: "venue") as? String {
                    cell.lblVenue.text = tempStr
                }
//                if let tempStr = tempData.objectForKey("detail_date") as? String {
//                    cell.lblDate.text = tempStr
//                }

                if let tempStr = tempData.object(forKey: "time") as? String {
                    
                    let timeArray = tempStr.components(separatedBy: " ")

                    if timeArray.count > 0
                    {
                        
                        let timeStr = String(format: "%@", timeArray[0]) //timeArray[0]
                        
                        let dateArray = timeStr.components(separatedBy: "-")
                        var dayStr = ""
                        if dateArray.count > 0 {
                            dayStr = dateArray[0]
                        }
                        var monthStr = ""
                        if dateArray.count > 1 {
                            monthStr = dateArray[1]
                        }
                        var yesrStr = ""
                        if dateArray.count > 2 {
                            yesrStr = dateArray[2]
                        }
                        
                        cell.lblDayMonth.text = String(format: "%@\n%@\n%@", arguments: [dayStr,monthStr, yesrStr])
                    }
                    
                    var timeStr = ""
                    if timeArray.count > 1
                    {
                        timeStr = timeArray[1]
                        
                        cell.lblDate.text = timeStr
                    }
                }

                
                ComplainsCells.add(cell)
        }
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
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
        if let cell = ComplainsCells.object(at: indexPath.row) as? EventCell {
            return cell.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? EventCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? EventCell {
            let objRoot: EventDetailsViewController = EventDetailsViewController(nibName: "EventDetailsViewController", bundle: nil)
            objRoot.ResultData = cell.data
            
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        
    }
    
    
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        if self.loadingStatus == .haveMore {
            
            self.perform(#selector(self.loadMore), with: nil, afterDelay: 0.5)
            
        }
    }
    @objc func loadMore() {
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

   
    func IsNoResultFound(_ isFound : Bool){
         DispatchQueue.main.async {
            if isFound == true {
                self.noResultFoundLabel.isHidden = true
                self.tableView.isHidden = false
            }else{
                self.noResultFoundLabel.isHidden = false
                self.tableView.isHidden = true
            }
        }
    }
    //MARK: - API Delegate -
    
    func GetNoticeBoard(_ pageCode : Int)
    {
        print(pageCode)
        if pageCode == 0 {
            self.ComplainsCells = NSMutableArray()
        }
        
        var requestUrl = ""
        if self.searchActive == true {
            if let search = self.searchBar.text {
                requestUrl = String(format: "%@?view=event_paginate&page=list&userID=%@&societyID=%@&pagecount=%d&search=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode,search])
            }else{
                requestUrl = String(format: "%@?view=event_paginate&page=list&userID=%@&societyID=%@&pagecount=%d", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
            }
        }else{
            requestUrl = String(format: "%@?view=event_paginate&page=list&userID=%@&societyID=%@&pagecount=%d", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
        }
        
        print(requestUrl)
        TNMWSMethod(nil, url: requestUrl, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
//                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "event_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.loadingStatus = .haveMore
                                    
                                    DispatchQueue.main.async {
                                        print(bannerList)
                                        self.CreateCell(bannerList)
                                        self.refreshControl.endRefreshing()
                                        
                                        if self.ComplainsCells.count > 0 || bannerList.count > 0 {
                                            self.IsNoResultFound(true)
                                        }else{
                                            self.IsNoResultFound(false)
                                        }
                                    }
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
                        self.refreshControl.endRefreshing()
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                self.IsNoResultFound(false)
            }
        }
        
    }
    
    //MARK: - Search Bar -
    func NavigationSearchBar(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "SearchIcon"), for: UIControl.State())
        button.addTarget(self, action:#selector(self.searchClick), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        //SarchBar
        searchBar = UISearchBar(frame: CGRect(x: 50, y: 0, width: UIScreen.main.bounds.width - 100, height: 30))
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.barStyle = UIBarStyle.black
        searchBar.showsCancelButton = true
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.white
        }
        
        searchBar.placeholder = "Search..."
    }
    @objc func searchClick(){
        UIView.transition(with: self.view, duration: 0.5, options: UIView.AnimationOptions(),
            animations: {
                self.navigationItem.titleView = self.searchBar
                self.searchBar.showsCancelButton = true
            }, completion: nil)
        
    }
    // MARK: UISearchBarDelegate functions
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.resignFirstResponder()
        self.navigationItem.title = "Events"
        self.searchBar.removeFromSuperview()
        navigationItem.titleView = nil
        searchActive = false
        
        searchBar.resignFirstResponder()
        self.currentPageCode = 0
        self.GetNoticeBoard(self.currentPageCode)
        
        searchBar.showsCancelButton = false;
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false;
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("BarSearch")
        //        customSearchBar.resignFirstResponder()
        //        customDelegate.didTapOnSearchButton()
        self.navigationItem.title = "Events"
        self.searchBar.removeFromSuperview()
        navigationItem.titleView = nil
        print(searchBar.text)
        if searchBar.text?.isEmpty == false {
            print(searchBar.text)
        }
        searchBar.resignFirstResponder()
        self.loadingStatus = .loading
        self.searchActive = true
        self.currentPageCode = 0
        self.GetNoticeBoard(self.currentPageCode)
        
        
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
