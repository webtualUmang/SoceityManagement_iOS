//
//  StaffViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class StaffViewController: UIViewController, StaffCellDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "StaffCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "StaffCell")
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 44.0; // set to whatever your "average" cell height is
       // self.perform("GetNoticeBoard")
        self.GetNoticeBoard()
    }
    func callMemberClic(_ data: NSDictionary) {
        var number = ""
        if let tempStr = data.object(forKey: "staff_contact_no") as? String {
            number = tempStr
        }
        if let url = URL(string: "telprompt://\(number)") {
            UIApplication.shared.openURL(url)
        }
    }
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "StaffCell") as? StaffCell {
                    cell.delegate = self
                    cell.data = tempData
                    if let tempStr = tempData.object(forKey: "staff_category_name") as? String {
                        cell.lblCatagory.text = tempStr.uppercased()
                        cell.lblCatagory.sizeToFit()
                    }
                    if let tempStr = tempData.object(forKey: "staff_name") as? String {
                        cell.lblName.text = tempStr.uppercased()
                    }
                    if let tempStr = tempData.object(forKey: "staff_badge_no") as? String {
                        cell.lblBadge.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "staff_note") as? String {
                        if tempStr == ""
                        {
                            cell.lblNotes.text = "-"

                        }
                        else
                        {
                        cell.lblNotes.text = tempStr
                        }
                    }
                    
//                    if let tempStr = tempData.objectForKey("staff_contact_no") as? String {
//                        cell.lblPhone.text = tempStr
//                    }
                    if let tempStr = tempData.object(forKey: "staff_image") as? String {
                        if tempStr.isEmpty == false {
                            let urlString : URL = URL(string: tempStr)!
                            cell.profileImage.clipsToBounds = true
                            cell.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                                if image != nil {
                                    cell.profileImage.image = image
                                }
                                
                            })
                            
                        }
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
//        if let cell = ComplainsCells.objectAtIndex(indexPath.row) as? StaffCell {
//            return cell.frame.size.height
//        }
        return UITableView.automaticDimension;
//        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? StaffCell {
                return cell
            }
        }
        return UITableViewCell()
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        
    }
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard()
    {
        
        let urlStr = String(format: "%@?view=staffs&page=list&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
       
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "staff_list") as? NSArray {
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
