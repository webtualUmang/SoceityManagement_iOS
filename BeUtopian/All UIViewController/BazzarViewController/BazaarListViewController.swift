//
//  BazaarListViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 28/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class BazaarListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var resultData : NSDictionary?
    @IBOutlet weak var lblNodataFound:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nibName = UINib(nibName: "BazaarListCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "BazaarListCell")
     //   self.perform("GetNoticeBoard")
        
        self.GetNoticeBoard()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if let data = resultData {
            if let tempStr = data.object(forKey: "name") as? String {
                if tempStr.isEmpty == false {
                    self.navigationItem.title = tempStr
                }
                
            }
            
        }
        
    }
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "BazaarListCell") as? BazaarListCell {
                    cell.data = tempData
                    self.ComplainsCells.add(cell)
                }
                
            }
        }
        
        DispatchQueue.main.async
            {
               if self.ComplainsCells.count == 0
                {
                    self.lblNodataFound.isHidden = false
                    self.tableView.isHidden = true
                }
                else
                {
                    self.lblNodataFound.isHidden = true
                    self.tableView.isHidden = false
                }
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
        if let cell = ComplainsCells.object(at: indexPath.row) as? BazaarListCell {
            return cell.frame.size.height
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? BazaarListCell {
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? BazaarListCell
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot:BazzarDetailViewController = storyboard.instantiateViewController(withIdentifier: "BazzarDetailViewController") as! BazzarDetailViewController
           // let objRoot: BazzarDetailViewController = BazzarDetailViewController(nibName: "BazzarDetailViewController", bundle: nil)
            if let tempData = cell.data
            {
                objRoot.resultData = tempData
            }
            
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        
    }
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard()
    {
        var catagoryId = "0"
        if let data = resultData {
            if let tempStr = data.object(forKey: "catID") as? String {
                catagoryId = tempStr
                
            }
            
        }
//        
        let urlStr = String(format: "%@?view=bazar&page=add_list&userID=%@&societyID=%@&catID=%@&pagecode=0", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,catagoryId])
        //        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"49", "1","0"])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0"
                        {
                            if let bannerList = ResultData.object(forKey: "add_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.CreateCell(bannerList)
                                }
                                
                                
                            }
                        }
                        else
                        {
                            self.lblNodataFound.text = ResultData["message"] as? String ?? ""
                            DispatchQueue.main.async
                                {
                                   if self.ComplainsCells.count == 0
                                    {
                                        self.lblNodataFound.isHidden = false
                                        self.tableView.isHidden = true
                                    }
                                    else
                                    {
                                        self.lblNodataFound.isHidden = true
                                        self.tableView.isHidden = false
                                    }
                                self.tableView.reloadData()
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
