//
//  CompainCloseViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class PollsCloseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    
    
    //If Fillter
    var fillterStr : String = "Genereal" {
        didSet{
            if tableView != nil {
                self.currentPageCode = 0
                self.GetNoticeBoard(self.currentPageCode)
            }
            
        }
    }
    
    //Paging
    @IBOutlet var noResultFoundLabel : UILabel!
    @IBOutlet var footerView : UIView!
    var currentPageCode : Int = 0
    var loadingStatus = LoadMoreStatus.loading
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "ClosePollsCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "ClosePollsCell")
        
//         GetClosePollList("")
        
        //Paging
        self.GetNoticeBoard(self.currentPageCode)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }

    func CreateCell(_ data: NSMutableArray){
        
        ComplainsCells = NSMutableArray()
        
        
        for item in data {
            
            if let dic = item as? NSDictionary {
                
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "ClosePollsCell") as? ClosePollsCell {
                    
                    if let strTemp = dic.object(forKey: "title") as? String {
                        cell.lblTitle.text = strTemp
                    }
                    if let strTemp = dic.object(forKey: "detail") as? String {
                        cell.lblDetail.text = strTemp
                    }
                    
                    var username: String = ""
                    var ago: String = ""
                    
                    if let strTemp = dic.object(forKey: "user_name") as? String {
                        username = strTemp
                    }
                    if let strTemp = dic.object(forKey: "ago") as? String {
                        ago = strTemp
                    }
                    
                    cell.lblName.text = String(format: "%@ %@", username, ago)
                    
                    if let strTemp = dic.object(forKey: "msg_date") as? String {
                        cell.lbldate.text = strTemp
                    }
                    
                    var ypostion: CGFloat = 0
                    
                    if let answers_list = dic.object(forKey: "answers_list") as? NSArray {
                        
                        for list in answers_list {
                            
                            if let tempdic = list as? NSDictionary {
                                
                                let view = PollCloseAnswerView.instanceFromNib()
                                view.frame.origin.x += 8
                                
                                if let strTemp = tempdic.object(forKey: "answer") as? String {
                                    view.lblTitle.text = strTemp
                                }
                                
                                if let strTemp = tempdic.object(forKey: "total_votes") as? String {
                                    view.lblVote.text = String(format: "%@ Vote(s)", strTemp)
                                    
                                    if(strTemp != "0"){
                                        view.Percentage.backgroundColor = UIColor(hexString: "2995CC")
                                    }
                                }
                                
                                if ypostion != 0 {
                                    view.frame.origin.y = ypostion + 65 + 10
                                }
                                else{
                                    view.frame.origin.y = 87
                                }
                                
                                ypostion = view.frame.origin.y
                                
                                cell.bgView.addSubview(view)
                                
                                var frames = cell.frame
                                
                                if ypostion != 87 {
                                    
                                    frames.size.height += 75 //* CGFloat(data.count)
                                    
                                    cell.frame = frames
                                }
                                else{
                                    
                                    if(data.count != 1){
                                        frames.size.height += 75
                                        cell.frame = frames
                                    }
                                    else{
                                        frames.size.height += 70
                                        cell.frame = frames
                                    }
                                }
                            }
                        }
                    }
                    
                    ComplainsCells.add(cell)
                }
            }
        }
        
        //        for var i = 0; i < 20; i++ {
        //            let cell: PollsCell! = self.self.tableView.dequeueReusableCellWithIdentifier("PollsCell") as? PollsCell
        //
        //            ComplainsCells.addObject(cell)
        //        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        let cell = ComplainsCells.object(at: indexPath.row) as? ClosePollsCell
        return cell!.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? ClosePollsCell {
                return cell
            }
        }
        return UITableViewCell()
        
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
        
        let urlStr = String(format: "%@?view=poll_paginate&page=list&userID=%@&societyID=%@&pagecount=%d&filter=%@&poll_type=Closed", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode,self.fillterStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "list") as? NSArray {
                                print(bannerList)
                                DispatchQueue.main.async {
                                    
                                    self.loadingStatus = .haveMore
                                    
                                    DispatchQueue.main.async {
                                        let arr = NSMutableArray(array: bannerList)
                                        self.CreateCell(arr)
                                        DispatchQueue.main.async {
                                            self.CreateCell(arr)
                                            if self.ComplainsCells.count > 0 || bannerList.count > 0 {
                                                self.IsNoResultFound(true)
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
                self.noResultFoundLabel.isHidden = true
                self.tableView.isHidden = false
            }else{
                self.noResultFoundLabel.isHidden = false
                self.tableView.isHidden = true
            }
        }
    }
    
    //MARK:- ClosePoll -
    func GetClosePollList(_ filter: String){
        
     
        
    let urlStr = String(format: "%@?view=poll_paginate&page=list&userID=%@&societyID=%@&flatID=%@&poll_type=Closed&pagecount=0&filter=", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID])
        
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async {
                                //                                self.lblNodata.hidden = true
                            }
                            if let bannerList = ResultData.object(forKey: "list") as? NSArray {
                                DispatchQueue.main.async {
                                    let arrdata = NSMutableArray(array: bannerList)
                                    self.CreateCell(arrdata)
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                //                                self.lblNodata.hidden = false
                                self.ComplainsCells = NSMutableArray()
                                self.tableView.reloadData()
                            }
                            //                            if let messageStr = ResultData.objectForKey(kMessage) as? String {
                            //                                appDelegate.TNMErrorMessage("", message: messageStr)
                            //                            }
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
