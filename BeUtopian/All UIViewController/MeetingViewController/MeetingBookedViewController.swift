//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class MeetingBookedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet var noResultFoundLabel : UILabel!
    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var fillterStr : String = "Genereal"
    {
        didSet{
            if tableView != nil {
                self.currentPageCode = 0
                self.GetNoticeBoard(self.currentPageCode)
            }
            
        }
    }
    
    @IBOutlet var footerView : UIView!
    var currentPageCode : Int = 0
    
    var loadingStatus = LoadMoreStatus.loading
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "MeetingCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "MeetingCell")
        self.noResultFoundLabel.isHidden = true
        self.GetNoticeBoard(self.currentPageCode)
        self.tableView.contentInset = UIEdgeInsets(top: -36, left: 0, bottom: 0, right: 0)
    }

    
    func CreateCell(_ resultList : NSArray){
        
        for data in resultList {
            if let tempData = data as? NSDictionary {
                let cell: MeetingCell! = self.tableView.dequeueReusableCell(withIdentifier: "MeetingCell") as? MeetingCell
                cell.data = tempData
                if let tempStr = tempData.object(forKey: "attendies") as? String {
                    cell.lblattendies.text = tempStr
                }
                
                var datetiem: String = ""
                
                if let tempStr = tempData.object(forKey: "meeting_date") as? String {
                    let monthStr = tempStr.components(separatedBy: "_")
                    var month = ""
                    if monthStr.count > 0 {
                        month = monthStr[0]
                    }
                    datetiem = month
                }
                
                if let tempStr = tempData.object(forKey: "meeting_time") as? String {
                    cell.lblDate.text = String(format: "%@ %@", datetiem, tempStr)
                }
                
//                if let tempStr = tempData.objectForKey("attendies") as? String {
//                    cell.lblShare.text = tempStr
//                }
//                if let tempStr = tempData.objectForKey("brief_topic") as? String {
//                    cell.lblBrif.text = tempStr
//                }
                
                if let tempStr = tempData.object(forKey: "share_msg") as? String {
                    cell.lblShare.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "venue") as? String {
                    cell.lblBrif.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "initiated_by") as? String {
                    cell.lblUserName.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "meeting_no") as? String {
                    cell.lblMeetingNo.text = tempStr.isEmpty == true ? "N/A" : tempStr
                }
                
                
                ComplainsCells.add(cell)
                /*
                if let statusStr = tempData.objectForKey("status") as? String {
                    if statusStr.caseInsensitiveCompare("Open") == .OrderedSame {
                        let cell: MeetingCell! = self.tableView.dequeueReusableCellWithIdentifier("MeetingCell") as? MeetingCell
                        cell.data = tempData
                        if let tempStr = tempData.objectForKey("attendies") as? String {
                            cell.lblattendies.text = tempStr
                        }
                        if let tempStr = tempData.objectForKey("meeting_date") as? String {
                            let monthStr = tempStr.componentsSeparatedByString("_")
                            var month = ""
                            if monthStr.count > 0 {
                                month = monthStr[0]
                            }
                            cell.lblDate.text = month
                        }
                        
                        if let tempStr = tempData.objectForKey("attendies") as? String {
                            cell.lblShare.text = tempStr
                        }
                        if let tempStr = tempData.objectForKey("brief_topic") as? String {
                            cell.lblBrif.text = tempStr
                        }
                        if let tempStr = tempData.objectForKey("initiated_by") as? String {
                            cell.lblUserName.text = tempStr
                        }
                        if let tempStr = tempData.objectForKey("meeting_no") as? String {
                            cell.lblMeetingNo.text = tempStr.isEmpty == true ? "N/A" : tempStr
                        }
                        
                        
                        ComplainsCells.addObject(cell)
                    }
                }
                */
                
            }
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if let cell = ComplainsCells.object(at: indexPath.row) as? MeetingCell {
            return cell.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? MeetingCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? MeetingCell {
            let objRoot: MeetingDetailsViewController = MeetingDetailsViewController(nibName: "MeetingDetailsViewController", bundle: nil)
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
    
    
    
    //MARK: - Get Facility From Server and Local -
    
    func GetNoticeBoard(_ pageCode : Int)
    {
        
        print(pageCode)
        if pageCode == 0 {
            self.ComplainsCells = NSMutableArray()
        }
        
        let urlStr = String(format: "%@?view=meeting_paginate&page=list&userID=%@&societyID=%@&pagecount=%d&filter=%@&meeting_type=Open", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode,self.fillterStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "meeting_list") as? NSArray {
                                print(bannerList)
                                DispatchQueue.main.async {
                                    
                                    self.loadingStatus = .haveMore
                                    
                                    DispatchQueue.main.async {
                                        self.CreateCell(bannerList)
                                        if self.ComplainsCells.count > 0 || bannerList.count > 0 {
                                            self.IsNoResultFound(true)
                                        }else{
                                            self.IsNoResultFound(false)
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
                self.noResultFoundLabel.isHidden = true
                self.tableView.isHidden = false
            }else{
                self.noResultFoundLabel.isHidden = false
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
