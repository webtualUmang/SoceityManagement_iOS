//
//  CompainOpenViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "UpdateCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "UpdateCell")
        
        self.GetNoticeBoard()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Updates"
       self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "UpdateCell") as? UpdateCell {
                    cell.data = tempData
                    if let tempStr = tempData.object(forKey: "message") as? String {
                        cell.lblTitle.text = tempStr
                        cell.lblTitle.numberOfLines = 3
                    }
                   
                    
                    if let tempStr = tempData.object(forKey: "image") as? String {
                        if tempStr.isEmpty == false {
                            let urlString : URL = URL(string: tempStr)!
                            cell.profilePic.clipsToBounds = true
                            cell.profilePic.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                                if image != nil {
                                    cell.profilePic.image = image
                                }
                                
                            })
                            
                        }
                    }
                    ComplainsCells.add(cell)
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
        let cell = ComplainsCells.object(at: indexPath.row) as? UpdateCell
        return cell!.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? UpdateCell {
                return cell
            }
        }
        return UITableViewCell()

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? UpdateCell {
            let objRoot: UpdateDetailsViewController = UpdateDetailsViewController(nibName: "UpdateDetailsViewController", bundle: nil)
            objRoot.ResultData = cell.data
            
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        
    }
    
    func GetNoticeBoard()
    {

        let urlStr = String(format: "%@?view=push_notification_list&page=list", arguments: [kMainDomainUrl])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "notification_list") as? NSArray {
                                print(bannerList)
                                
                                
                                
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
