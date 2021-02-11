//
//  alertlistController.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 05/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class alertlistController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var loadingStatus = LoadMoreStatus.loading
    @IBOutlet var lblNoData: UILabel!
    var arrdata = NSMutableArray()
    
    var image = [["image":"Theft","color":"#E33A35"],["image":"Animal","color":"#F89617"],["image":"Emergency","color":"#1D7804"]]
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let nibName = UINib(nibName: "alertListCellTableViewCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "alertListCellTableViewCell")
        self.lblNoData.text = "No data found"
        self.GetNoticeBoard()
    
        // Do any additional setup after loading the view.
    }
     func CreateCell(_ resultList : NSArray)
        {
            
            for data in resultList
            {
                if let tempData = data as? NSDictionary {
                    let cell: alertListCellTableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: "alertListCellTableViewCell") as? alertListCellTableViewCell

                       
                    if let tempStr = tempData.object(forKey: "type") as? String {
                        cell.lblTitle.text = tempStr
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
    // MARK:- api call list
    
     func GetNoticeBoard()
        {

            let urlStr = String(format: "%@?view=alert&page=list&userID=%@&societyID=%@&notificationType=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,"alert"])
    
            print(urlStr)
            TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
                if succeeded == true {
                    print(data)
                    
                    if let ResultData = data as? NSDictionary{
                        if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                            
                            if msgCode == "0" {
                                if let bannerList = ResultData.object(forKey: "alert_array") as? NSArray
                                {
                                    self.arrdata = NSMutableArray.init(array:bannerList)
                                    
                                    DispatchQueue.main.async {
                                        
                                        self.CreateCell(bannerList)
                                    }
                                    
                                    
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
    func api_send_alert(type:String)
          {
            let data = getLoginUser()
            
            let flat_name = UserDefaults.standard.string(forKey:"flat_name") ?? ""
            var blockNo = ""
            var flatNo = ""
            let firstName = data["firstname"] as? String ?? ""
            let lastName = data["lastname"] as? String ?? ""
            
            if !flat_name.isEmpty
            {
                let firstpart = flat_name.split(separator:" ")
                print(firstpart[0])
                if firstpart.count > 0
                {
                    let str_second_name = firstpart[1]
                    
                    if !str_second_name.isEmpty
                    {
                        let secondpart = str_second_name.split(separator:"-")
                        
                        if secondpart.count > 0
                        {
                            blockNo = String(secondpart[0])
                            flatNo = String(secondpart[1])
                            
                        }
                    }
                    
                }
                
            }
              let urlStr = String(format: "%@?view=alert&page=notification&userID=%@&societyID=%@&notification_type=%@&blockno=%@&flatno=%@&firstname=%@&lastname=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,type,blockNo,flatNo,firstName,lastName])
      
              print(urlStr)
              TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
                  if succeeded == true {
                      print(data)
                      
                      if let ResultData = data as? NSDictionary
                      {
                          if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                              
                              if msgCode == "0"
                              {
                                 appDelegate.TNMErrorMessage("", message:ResultData["message"] as? String ?? "")

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
                                      if let cell = self.ComplainsCells.object(at: indexPath.row) as? alertListCellTableViewCell
                                      {
                                        let dic = self.image[indexPath.row] as? NSDictionary ?? [:]
                                        
                                        cell.viewBack.backgroundColor = AppColor.hexStringToUIColor(hex:dic["color"] as? String ?? "")
                                        cell.imgType.image = UIImage(named:dic["image"] as? String ?? "")
                                        cell.imgType.contentMode = .scaleAspectFit
                                        cell.selectionStyle = .none

                                          return cell
                                      }
                                  }
                           
         return UITableViewCell()

        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
             DispatchQueue.main.async {
            let alertview = UIAlertController(title: "", message: "Are you sure you want to send alert?", preferredStyle: .alert)
            
            let NoAction = UIAlertAction(title: "No", style: .cancel) { (alert) in
                
            }
            
            let YesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
                
               let dic = self.arrdata[indexPath.row] as? NSDictionary ?? [:]
                self.api_send_alert(type:dic["type"] as? String ?? "")
            }
            
            alertview.addAction(NoAction)
            alertview.addAction(YesAction)
            
           self.present(alertview, animated: true, completion: nil)
            }
            
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
