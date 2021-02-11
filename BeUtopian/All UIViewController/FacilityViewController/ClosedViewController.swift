//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ClosedViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,AddFacilityDelegate
{
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var lblNoData: UILabel!
    
    var ComplainsCells = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "FacilityCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "FacilityCell")
        self.GetNoticeBoard()
        
    }
    
    func ReloadFacilityResult()
       {
           self.GetNoticeBoard()
       }
    func CreateCell(_ resultList : NSArray){
        
        
        ComplainsCells = NSMutableArray()
        
        for data in resultList {
            if let tempData = data as? NSDictionary {
                let cell: FacilityCell! = self.tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
                cell.data = tempData
                if let tempStr = tempData.object(forKey: "facility_name") as? String {
                    cell.lblFacilityName.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "detail") as? String {
                    cell.lblDetails.text = tempStr
                }
                
                if let tempStr = tempData.object(forKey: "booking_from") as? String {
                    cell.lblBookingFrom.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "booking_to") as? String {
                    cell.lblBookingTo.text = tempStr
                }
                if let tempStr = tempData.object(forKey: "amount") as? String {
                    cell.lblAmount.text = "₹ " + "\(tempStr)"
                }
                if let tempStr = tempData.object(forKey: "booking_status") as? String {
                    cell.lblStatus.text = tempStr.isEmpty == true ? "N/A" : tempStr
                }
                
                
                ComplainsCells.add(cell)
                
            }
            
            DispatchQueue.main.async
                {
                    if self.ComplainsCells.count == 0
                    {
                        self.tableView.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                    else
                    {
                        self.tableView.isHidden = false
                        self.lblNoData.isHidden = true
                    }
                    self.tableView.reloadData()
            }
        }
    }
    @IBAction func AddFacility(_ sender:UIButton)
    {
         let objRoot: FacilityAddViewController = FacilityAddViewController(nibName: "FacilityAddViewController", bundle: nil)
        objRoot.delegate = self 
         self.navigationController?.pushViewController(objRoot, animated: true)
     }
    func GetNoticeBoard()
    {
        //
        let urlStr = String(format: "%@?view=facility&page=new_added&userID=%@&societyID=%@&count=0", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        //        let urlStr = String(format: "%@?view=facility&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"1", "1",idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0"
                        {
                            if let bannerList = ResultData.object(forKey: "booking_list") as? NSArray
                            {
                                
                                DispatchQueue.main.async
                                    {
                                        self.CreateCell(bannerList)
                                }
                                
                            }
                            
                        }
                        else
                        {
                            self.tableView.isHidden = true
                            self.lblNoData.isHidden = false
                        }
                    }
                }
                
                
                
            }else
            {
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
    
    
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if let cell = ComplainsCells.object(at: indexPath.row) as? FacilityCell {
            return cell.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? FacilityCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? FacilityCell {
            let objRoot: FacilityDetailsViewController = FacilityDetailsViewController(nibName: "FacilityDetailsViewController", bundle: nil)
            objRoot.resultData = cell.data
            
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
