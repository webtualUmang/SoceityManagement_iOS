//
//  FoundListVC.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 22/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class FoundListVC: UIViewController
{
    var Arrdata = NSMutableArray()

    @IBOutlet weak var tblFound:UITableView!
       @IBOutlet weak var lblNoData:UILabel!
       
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.GetNoticeBoard()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name ("found_list"), object:nil)
                      
                      NotificationCenter.default
                          .addObserver(self,
                                       selector: #selector(notificationSet),
                                       name: NSNotification.Name ("found_list"),                                           object: nil)
        
    }
    @objc func notificationSet()
    {
        //self.navigationController?.popViewController(animated:false)
        self.GetNoticeBoard()
    }
    
    func GetNoticeBoard()
         {
             
             
    
             let urlStr = String(format: "%@/listlostfound?view=lostfound&page=list&societyID=%@", arguments: [kMainDomainUrl,appDelegate.SocietyID])
             print(urlStr)
             TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
                 if succeeded == true
                 {
                                    print(data)
                     
                     if let ResultData = data as? NSDictionary
                     {
                         if ResultData.object(forKey: "msgcode") as? String ?? "" == "0"
                         {
                             DispatchQueue.main.async
                             {
                                 
                             let array = ResultData["lostfound_array"] as? NSArray ?? []
                             
                            
                            let predicate: NSPredicate = NSPredicate(format:"islost LIKE[cd] %@","0")
                             let filteredArray: NSArray = array.filtered(using: predicate) as NSArray

                             self.Arrdata = NSMutableArray.init(array: filteredArray)
                                 print(self.Arrdata)
                                 if self.Arrdata.count == 0
                                 {
                                     self.tblFound.isHidden = true
                                     self.lblNoData.isHidden = false
                                 }
                                 else
                                 {
                                    self.tblFound.isHidden = false
                                     self.lblNoData.isHidden = true
                                 }
                                 self.tblFound.reloadData()
                             }
                             
                             
                         }
                         else
                         {
                             self.tblFound.isHidden = true
                             self.lblNoData.isHidden = false
                         }
                     }else
                     {
                         self.tblFound.isHidden = true
                         self.lblNoData.isHidden = false
                     }
                                     
                 }else{
                     self.tblFound.isHidden = true
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
    
    
    @IBAction func addLostAndFound(_ sender:UIButton)
    {
        let objLost : AddLostFoundVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLostFoundVC") as! AddLostFoundVC
        objLost.screen_name = "Found"
        self.navigationController?.pushViewController(objLost, animated:true)

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
extension FoundListVC:UITableViewDelegate,UITableViewDataSource
{
    // MARK: - UITableView Delegates And data source
      func numberOfSections(in tableView: UITableView) -> Int
      {
          return 1
      }
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
      {
          return self.Arrdata.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
      {
          let cell = tableView.dequeueReusableCell(withIdentifier: "lostFoundCell") as! lostFoundCell
          cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.setDetails(Dic:self.Arrdata[indexPath.row] as? NSDictionary ?? [:])
        
          return cell
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objRoot:LostFoundDetailsVC = storyboard.instantiateViewController(withIdentifier: "LostFoundDetailsVC") as! LostFoundDetailsVC
        objRoot.dicData = self.Arrdata[indexPath.row] as? NSDictionary ?? [:]
        self.navigationController?.pushViewController(objRoot, animated:false)
    }
}
