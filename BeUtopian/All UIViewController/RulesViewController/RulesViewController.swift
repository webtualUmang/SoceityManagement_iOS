//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var noResultFoundLabel : UILabel!
    
    var searchBar:UISearchBar = UISearchBar()
    var searchActive : Bool = false
    
    @IBOutlet var footerView : UIView!
    var currentPageCode : Int = 0
    
    var loadingStatus = LoadMoreStatus.loading
    @IBOutlet var ResetView: UIView!
    @IBOutlet var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "RulesCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "RulesCell")
        
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
        
        self.navigationItem.title = "Society Rules"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        
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
//        self.performSelector("GetNoticeFromLocalDB:")
        self.currentPageCode = 0
        self.GetNoticeBoard(self.currentPageCode)
    }
    
    func CreateCell(_ resultList : NSArray){
        
        
        for data in resultList {
            if let tempData = data as? NSDictionary {
                let cell: RulesCell! = self.tableView.dequeueReusableCell(withIdentifier: "RulesCell") as? RulesCell
                cell.data = tempData
                if let tempStr = tempData.object(forKey: "title") as? String {
                    cell.lblTitle.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "time") as? String {
                    cell.lblTime.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "desc") as? String {
                    
                    cell.lblDesc.text = tempStr.html2String
                }
                if let tempStr = tempData.object(forKey: "number") as? String {
                                   
                                   cell.lblRuleNo.text = tempStr
                               }
                
                
                /*if let tempStr = tempData.objectForKey("number") as? String {
                    
                    if(tempStr != ""){
                        
                        let number = String(format: "%@", tempStr)
                        
                        let attrs = [
                            NSFontAttributeName : UIFont.boldSystemFontOfSize(16),
                            NSForegroundColorAttributeName : UIColor.blackColor()]
                        let attributedString = NSMutableAttributedString()
                        
                        attributedString.appendAttributedString(NSMutableAttributedString(string: "Rules No "))
                        attributedString.appendAttributedString(NSMutableAttributedString(string:number, attributes:attrs))
                        
                        //                            let buttonTitleStr = NSMutableAttributedString(string:number, attributes:attrs)
                        //                            attributedString.appendAttributedString(buttonTitleStr)
                        cell.lblRules.attributedText = attributedString
                    }
                    
                    //                        cell.lblNoticeNo.text = String(format: "Notice No. %@", tempStr)
                }*/
                
             
                
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
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? RulesCell {
                return cell
            }
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? RulesCell {
            let objRoot: RulesDetailsViewController = RulesDetailsViewController(nibName: "RulesDetailsViewController", bundle: nil)
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

    
    
    //MARK: - API Delegate -
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
    
    func GetNoticeBoard(_ pageCode : Int)
    {
        print(pageCode)
        if pageCode == 0 {
            self.ComplainsCells = NSMutableArray()
        }

        var requestUrl = ""
        if self.searchActive == true {
            if let search = self.searchBar.text {
                requestUrl = String(format: "%@?view=rules_paginate&page=list&userID=%@&societyID=%@&pagecount=%d&search=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode,search])
            }else{
                requestUrl = String(format: "%@?view=rules_paginate&page=list&userID=%@&societyID=%@&pagecount=%d", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
            }
        }else{
            requestUrl = String(format: "%@?view=rules_paginate&page=list&userID=%@&societyID=%@&pagecount=%d", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
        }
        
        print(requestUrl)
        TNMWSMethod(nil, url: requestUrl, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
//                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "rules_list") as? NSArray {
                                self.loadingStatus = .haveMore
                                print(bannerList)
                                DispatchQueue.main.async
                                    {
                                        
                                    self.CreateCell(bannerList)
                                    self.refreshControl.endRefreshing()
                                    
                                    if self.ComplainsCells.count > 0 || bannerList.count > 0 {
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
        button.addTarget(self, action:#selector(searchClick), for: UIControl.Event.touchUpInside)
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
    
    @IBAction func BtnResetSearchClick(_ sender: AnyObject){
        self.ResetView.isHidden = true
        searchBar.text = ""
        self.currentPageCode = 0
        self.GetNoticeBoard(self.currentPageCode)
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
        self.navigationItem.title = "Society Rules"
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
        /*
        if searchBar.text!.isEmpty
        {
            self.searchActive = false
            self.tableView.reloadData()
            
        }
        else
        {
            searchBar.showsCancelButton = true;
            self.searchActive = true
            self.searchResultCells.removeAllObjects()
            
            for cell in self.ComplainsCells
            {
                if let tempCell = cell as? RulesCell {
                    if let tempStr = tempCell.lblTitle.text {
                        
                        if tempStr.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil
                        {
                            self.searchResultCells.addObject(cell)
                        }
                    }
                    
                }
                
                
            }
            self.tableView.reloadData()
           
        }
        */
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
        self.navigationItem.title = "Society Rules"
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
        
        if(searchBar.text != ""){
            self.ResetView.isHidden = false
            self.lblResult.text = String(format: "Result for %@", searchBar.text!)
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
