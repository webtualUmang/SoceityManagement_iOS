//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class CompainOpenViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    @IBOutlet var lblNoData: UILabel!
    
//    var resultData = NSArray(){
//        didSet{
//            self.CreateCell(resultData)
//        }
//    }
    
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
        let nibName = UINib(nibName: "ComplainsOpenCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "ComplainsOpenCell")
//        self.performSelector("GetNoticeFromLocalDB:", withObject: NSArray())
        
        ComplainsCells = NSMutableArray()
        //Paging
        self.GetNoticeBoard(self.currentPageCode)
//        self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        
//        self.performSelector("GetNoticeFromLocalDBFinalResult")
    }
    
    func CreateCell(_ resultList : NSArray, isFiltter : String){
       //print(resultList)
                        
       // ComplainsCells = NSMutableArray()
        
        for data in resultList {
            if let tempData = data as? NSDictionary {
                
                //if let status = tempData.objectForKey("status") as? String {
                    //if status.caseInsensitiveCompare("Open") == .OrderedSame {
                        let cell: ComplainsOpenCell! = self.self.tableView.dequeueReusableCell(withIdentifier: "ComplainsOpenCell") as? ComplainsOpenCell
                        
                        cell.data = tempData
                        if let tempStr = tempData.object(forKey: "status") as? String {
                            cell.status.text = tempStr
                        }
                        if let tempStr = tempData.object(forKey: "time") as? String {
                            cell.lblTime.text = tempStr
                        }
                        
                        if let tempStr = tempData.object(forKey: "title") as? String {
                            cell.lblTitle.text = tempStr
                        }
//                        if let tempStr = tempData.objectForKey("replies") as? String {
//                            cell.lblDesc.text = tempStr
//                        }
                        if let tempStr = tempData.object(forKey: "descrption") as? String {
                            cell.lblDesc.text = tempStr//.base64Decoded
                        }
//                        if let tempStr = tempData.object(forKey: "replies") as? String {
//                            cell.lblReply.text = tempStr
//                        }
//                        if let tempStr = tempData.object(forKey: "replies") as? Int {
//                            cell.lblReply.text = String(format: "%d", tempStr)
//                        }
                        if let tempStr = tempData.object(forKey: "ticket_no") as? String {
                            cell.lblTicketNo.text = tempStr
                        }
                        if let tempStr = tempData.object(forKey: "name") as? String {
                            cell.lblName.text = tempStr
                        }
                        if let tempStr = tempData.object(forKey: "category") as? String {
                            cell.lblCatagory.text = String(format: "%@   ", arguments: [tempStr])
                        }
                        /*
                        if let tempStr = tempData.objectForKey(kNoticeBoardisread) as? String {
                            if tempStr == "yes" {
                                cell.lblStatus.hidden = true
                            }else{
                                cell.lblStatus.hidden = false
                            }
                        }
                        */
                        if let tempStr = tempData.object(forKey: "urgent") as? String {
                            if tempStr.caseInsensitiveCompare("yes") == .orderedSame {
//                                cell.lblTicketNo.textColor = UIColor.red
//                                cell.lblTitle.textColor = UIColor.red
                            }else{
//                                cell.lblTitle.textColor = UIColor.black
//                                cell.lblTicketNo.textColor = UIColor.darkGray
                            }
                        }
                        
                        if isFiltter.caseInsensitiveCompare("false") == .orderedSame {
                            ComplainsCells.add(cell)
                        }else{
                            if let tempStr = tempData.object(forKey: "type") as? String {
                                if tempStr.caseInsensitiveCompare(isFiltter) == .orderedSame {
                                    ComplainsCells.add(cell)
                                }
                            }
                        }
                        
                        
                    }
               // }
                
            //}
        }
        
        
        
        DispatchQueue.main.async {
            if(self.ComplainsCells.count == 0){
                self.lblNoData.isHidden = false
            }
            else{
                self.lblNoData.isHidden = true
            }
            self.tableView.reloadData()
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
        if let cell = ComplainsCells.object(at: indexPath.row) as? ComplainsOpenCell {
            return cell.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? ComplainsOpenCell {
                cell.lblCatagory.layer.cornerRadius = 10
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ComplainsOpenCell {
            let objRoot: ComplainDetailsViewController = ComplainDetailsViewController(nibName: "ComplainDetailsViewController", bundle: nil)
            if let tempDta = cell.data {
                objRoot.disussionData = tempDta as! [AnyHashable: Any]
            }
            objRoot.loginUserID = appDelegate.LoginUserID
            objRoot.societyID = appDelegate.SocietyID
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
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int){
        if self.loadingStatus == .haveMore {
            
            self.perform(#selector(loadMore), with: nil, afterDelay: 0.5)
            
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
    
    
    
    //MARK: - Get Facility From Server and Local -
    
    func GetNoticeBoard(_ pageCode : Int)
    {
        print(pageCode)
        if pageCode == 0 {
            self.ComplainsCells = NSMutableArray()
        }
        
//        let urlStr = String(format: "%@?view=helpdesk_paginate&page=list&userID=%@&societyID=%@&pagecount=%d&complaint_type=open", arguments: [kCMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
        let urlStr = String(format: "%@?view=helpdesk_paginate&page=list&userID=%@&societyID=%@&pagecount=%d&complaint_type=Open", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,pageCode])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "complaint_list") as? NSArray {
                                print(bannerList)
                                DispatchQueue.main.async {
                                    
                                    self.loadingStatus = .haveMore
                                    
                                  
                                        
                                        DispatchQueue.main.async
                                            {
                                            
                                            if self.ComplainsCells.count > 0 || bannerList.count > 0
                                            {
                                                self.IsNoResultFound(true)
                                                self.CreateCell(bannerList, isFiltter: "false")
                                            }else
                                            {
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
