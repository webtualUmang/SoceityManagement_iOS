//
//  DocumentViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 18/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var FlatID : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "DocumentCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "DocumentCell")
     //   self.perform("GetNoticeBoard:", with: appDelegate.FlatID, afterDelay: 0.2)
        self.GetNoticeBoard(appDelegate.FlatID)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Documents"
    }
    
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as? DocumentCell {
                    cell.data = tempData
                    if let tempStr = tempData.object(forKey: "name") as? String {
                        cell.lblName.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "added_on") as? String {
                        cell.lblDetails.text = tempStr
                    }
                    
                    self.ComplainsCells.add(cell)
                }
                
            }
        }
        
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
        
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? DocumentCell {
                return cell.frame.size.height
            }
        }
        
        
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? DocumentCell {
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? DocumentCell {
            if let tempStr = cell.data?.object(forKey: "folderID") as? String {
               // let objRoot: SubDocumentViewController = SubDocumentViewController(nibName: "SubDocumentViewController", bundle: nil)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let objRoot:SubDocumentViewController = storyboard.instantiateViewController(withIdentifier: "SubDocumentViewController") as! SubDocumentViewController
                objRoot.FolderID = tempStr
                if let tempStr = cell.data?.object(forKey: "name") as? String {
                    objRoot.navigationItem.title = tempStr
                }
                
                self.navigationController?.pushViewController(objRoot, animated: true)
            }
        }
        
    }
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard(_ flatNumber : String)
    {
        
        
        let urlStr = String(format: "%@?view=documents&page=list&userID=%@&societyID=%@&flatID=%@&number=0", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,flatNumber])
        //        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"49", "1","0"])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "document_list") as? NSArray {
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
