//
//  LostListVC.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 22/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class LostListVC: UIViewController
{
    var Arrdata = NSMutableArray()
    @IBOutlet weak var tblLost:UITableView!
    @IBOutlet weak var lblNoData:UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.GetNoticeBoard()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name ("lost_list"), object:nil)
               
               NotificationCenter.default
                   .addObserver(self,
                                selector: #selector(notificationSet),
                                name: NSNotification.Name ("lost_list"),                                           object: nil)

    }
    @objc func notificationSet()
    {
       // self.navigationController?.popViewController(animated:false)
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
                            
                           
                           let predicate: NSPredicate = NSPredicate(format:"islost LIKE[cd] %@","1")
                            let filteredArray: NSArray = array.filtered(using: predicate) as NSArray

                            self.Arrdata = NSMutableArray.init(array: filteredArray)
                                print(self.Arrdata)
                                if self.Arrdata.count == 0
                                {
                                    self.tblLost.isHidden = true
                                    self.lblNoData.isHidden = false
                                }
                                else
                                {
                                   self.tblLost.isHidden = false
                                    self.lblNoData.isHidden = true
                                }
                                self.tblLost.reloadData()
                            }
                            
                            
                        }
                        else
                        {
                            self.tblLost.isHidden = true
                            self.lblNoData.isHidden = false
                        }
                    }else
                    {
                        self.tblLost.isHidden = true
                        self.lblNoData.isHidden = false
                    }
                                    
                }else{
                    self.tblLost.isHidden = true
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
        objLost.screen_name = "Lost"
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
extension LostListVC:UITableViewDelegate,UITableViewDataSource
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
class lostFoundCell:UITableViewCell
{
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblDic:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblMobile:UILabel!
    @IBOutlet weak var heightImage:NSLayoutConstraint!
    @IBOutlet weak var imageview:UIImageView!
    @IBOutlet weak var activity:UIActivityIndicatorView!
    
    override func awakeFromNib()
       {
           super.awakeFromNib()
           DispatchQueue.main.async
               {
                   
           }
    }
    func setDetails(Dic:NSDictionary)
    {
        self.lblTitle.text = Dic["item_name"] as? String ?? ""
        self.lblDate.text = Dic["createddate"] as? String ?? ""
        self.lblDic.text = Dic["description"] as? String ?? ""
        
        if Dic["isclosed"] as? String ?? "" == "1"
        {
            self.lblStatus.text = "Status : Close"

        }
        else
        {
            self.lblStatus.text = "Status : Open"

        }
        if Dic["photo"] as? String ?? "" == ""
        {
            self.heightImage.constant = 0
            self.activity.isHidden = true
        }
        else
        {
            self.activity.startAnimating()
            self.heightImage.constant = UIScreen.main.bounds.size.width * 0.4
            let photo = Dic["photo"] as? String ?? ""
            if !photo.isEmpty
            {
                self.activity.stopAnimating()

                let urlString : URL = URL(string:"http://wgate.thewebtual.com/uploads/lostfound/" + "\(photo)")!

                self.imageview!.sd_setImage(with:urlString, placeholderImage: UIImage(named: "default_gray_image"), options:.retryFailed, completed: { (image, error, type, url) -> Void in
                                           if image != nil
                                           {
                                            self.activity.stopAnimating()
                                            self.imageview.contentMode = .scaleAspectFill
                                                self.imageview.image = image
                                           }
                                           
                                       })
                self.activity.stopAnimating()

            }
            else
            {
                self.activity.stopAnimating()
            }
        }
        self.lblMobile.text = Dic["mobile"] as? String ?? ""

    }
}
