//
//  HistoryViewController.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 05/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var ComplainsCells = NSMutableArray()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet var lblNoData: UILabel!
     var refreshControl = UIRefreshControl()

    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        let nibName = UINib(nibName: "HistorylistTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "HistorylistTableViewCell")
        self.refreshControl.tintColor = NSTheme().GetNavigationBGColor()
        self.refreshControl.addTarget(self, action:#selector(self.refresh), for:.valueChanged)
        self.tableView.addSubview(refreshControl)
        self.lblNoData.text = "No history found"
        self.GetNoticeBoard()
        // Do any additional setup after loading the view.
    }
    @objc func refresh()
    {
        self.ComplainsCells.removeAllObjects()
        self.GetNoticeBoard()
    }
    func CreateCell(_ resultList : NSArray)
    {
        
        for data in resultList
        {
            if let tempData = data as? NSDictionary {
                let cell: HistorylistTableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: "HistorylistTableViewCell") as? HistorylistTableViewCell
                
                
                if let tempStr = tempData.object(forKey: "alert_type") as? String {
                    cell.lblHeader.text = tempStr
                }
                if let alert_desc = tempData.object(forKey: "alert_desc") as? String {
                                   cell.lblDesc.text = alert_desc
                               }
                if let alert_date = tempData.object(forKey: "alert_date") as? String {
                                   cell.lblDate.text = alert_date
                               }
                
                self.ComplainsCells.add(cell)
                
            }
            
            if(ComplainsCells.count == 0){
                lblNoData.isHidden = false
            }
            else{
                lblNoData.isHidden = true
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func GetNoticeBoard()
    {
        
        let urlStr = String(format: "%@?view=alert_details&page=list&societyID=%@&userID=%@", arguments: [kMainDomainUrl,appDelegate.SocietyID, appDelegate.LoginUserID])
        
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        
                        if msgCode == "0" {
                            self.refreshControl.endRefreshing()
                            if let historyList = ResultData.object(forKey: "alert_details_array") as? NSArray
                            {
                                DispatchQueue.main.async {
                                    
                                   self.CreateCell(historyList)
                                }
                                
                                
                            }
                        }
                    }
                }
                
                
                
            }else{
                self.refreshControl.endRefreshing()
                self.tableView.isHidden = true
                self.lblNoData.isHidden = false
                if let json = data as? NSDictionary
                {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.ComplainsCells.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if self.ComplainsCells.count > indexPath.row
        {
            if let cell = self.ComplainsCells.object(at: indexPath.row) as? HistorylistTableViewCell
            {
                
                cell.selectionStyle = .none
                
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
