//
//  NoticeDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 20/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class RulesDetailsViewController: UIViewController {

    var hidingNavBarManager: HidingNavigationBarManager?
    @IBOutlet var lblNumber : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var imageBig : UIImageView!
    
    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    
    @IBOutlet var tableView : UITableView!
    var ResultData : NSDictionary?
    
    @IBOutlet var btnDownload : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.btnDownload.layer.shadowRadius = 0.5
        self.btnDownload.layer.shadowOpacity = 0.5
        self.btnDownload.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnDownload.layer.shadowOffset = CGSize(width: 0,height: 7)
        self.btnDownload.layer.cornerRadius = 25
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
        imageBig.isUserInteractionEnabled = true
        imageBig.addGestureRecognizer(tapGestureRecognizer)
        
        self.tableView.tableFooterView = self.footerView
        self.tableView.tableHeaderView = self.headerView
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.SetDetailsHeader()
//            self.hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: self.tableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //self.navigationItem.title = "Society Rules"
        
        let right = UIBarButtonItem(image: UIImage(named: "ic_menu_share"), style: .plain, target: self, action: "shareClick:")
        self.navigationItem.rightBarButtonItem = right
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        scrollViewDidScroll(tableView)
        
        //self.tableView.isEnableParallexHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        appDelegate.SetNavigationBarColor(self.navigationController!)
        
        if self.navigationController != nil {
            self.navigationController?.navigationBar.lt_reset()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let themeColor = UIColor(red: 143.0/255.0, green: 197.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        let offsetY = scrollView.contentOffset.y
        
        if self.navigationController != nil {
            if offsetY >= 50 {
                
                let alpha: CGFloat = min(1, 1 - ((50 + 64 - offsetY) / 64))
                self.navigationController!.navigationBar.lt_setBackgroundColor(themeColor.withAlphaComponent(alpha))
            }
            else{
                self.navigationController!.navigationBar.lt_setBackgroundColor(themeColor.withAlphaComponent(0))
            }
        }
    }

    
    @objc func imageTapped(_ img: AnyObject)
    {
        // Your action
        if let tempData = ResultData  {
            if let tempStr = tempData.object(forKey: "image") as? String {
                if tempStr.isEmpty == false {
                    appDelegate.DownloadImageFromUrl(tempStr)
                }
            }
            
        }
    }
    
    @IBAction func downloadClick(_ sender : AnyObject){
        if let tempData = ResultData  {
            if let tempStr = tempData.object(forKey: "image") as? String {
                if tempStr.isEmpty == false {
                    appDelegate.DownloadImageFromUrl(tempStr)
                }
            }
            
        }
        
    }
    @IBAction func shareClick(_ sender : AnyObject){
        if let tempData = ResultData  {
            
            let data = getLoginUser()
            
            var societyname = ""
            if let tempStr = data.object(forKey: "societyName") as? String {
                societyname = String(format: "# %@ - Society Rules #\n", arguments: [tempStr])
            }
            
            var shareTitle = ""
            if let tempStr = tempData.object(forKey: "title") as? String {
                shareTitle = String(format: "%@\n", arguments: [tempStr])
            }
            
            
            var shareDesc = ""
            if let tempStr = tempData.object(forKey: "desc") as? String {
                shareDesc = String(format: "%@\n", arguments: [tempStr])
            }
//            var urlString = ""
//            if let tempStr = tempData.objectForKey("image") as? String {
//                if tempStr.isEmpty == false {
//                    urlString  = tempStr
//                    
//                }
//            }
            
            let shareImage = self.imageBig.image
            
            let shareList : NSArray = [appDelegate.GetEmptyString(societyname), appDelegate.GetEmptyString(shareTitle), appDelegate.GetEmptyString(shareDesc),shareImage!]
            appDelegate.ShareDetailsResult(shareList)
        }
        
        
        
    }
    

    func SetDetailsHeader(){
        if let tempData = ResultData  {
            if let tempStr = tempData.object(forKey: "title") as? String {
                self.lblType.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "number") as? String {
                self.lblNumber.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "time") as? String {
                self.lblTime.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "desc") as? String {
                self.lblDesc.text = tempStr
                self.lblDesc.sizeToFit()
                self.footerView.frame.size.height = self.lblDesc.frame.size.height
            }
            if let tempStr = tempData.object(forKey: "image") as? String {
                if tempStr.isEmpty == false {
                    let urlString : URL = URL(string: tempStr)!
                    self.imageBig.clipsToBounds = true
                    self.imageBig.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                        if image != nil {
                            self.imageBig.image = image
                        }
                        
                    })
                    
                }
            }
            
            self.tableView.tableHeaderView = self.headerView
             self.tableView.tableFooterView = self.footerView
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
