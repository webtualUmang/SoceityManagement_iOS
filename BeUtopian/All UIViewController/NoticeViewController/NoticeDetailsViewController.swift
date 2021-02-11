//
//  NoticeDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 20/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class NoticeDetailsViewController: UIViewController {

    @IBOutlet var lblNumber : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var imageBig : UIImageView!
    
    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var btnDownload : UIButton!
    
    var ResultData : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        imageBig.isUserInteractionEnabled = true
        imageBig.addGestureRecognizer(tapGestureRecognizer)
//        self.btnDownload.layer.shadowOffset = 1
        self.btnDownload.layer.shadowOpacity = 0.5
        self.btnDownload.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnDownload.layer.shadowOffset = CGSize(width: 0,height: 7)
        self.btnDownload.layer.cornerRadius = 25

        
        // Do any additional setup after loading the view.
//        self.performSelector("SetDetailsHeader", withObject: nil, afterDelay: 0.2)
        
        
        DispatchQueue.main.async {
            
            self.tableView.tableFooterView = self.footerView
            self.tableView.tableHeaderView = self.headerView
            self.SetDetailsHeader()
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.title = "Notice Board"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        let right = UIBarButtonItem(image: UIImage(named: "ic_menu_share"), style: .plain, target: self, action:#selector(shareClick(_:)))
        self.navigationItem.rightBarButtonItem = right
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        scrollViewDidScroll(tableView)
        
        //self.tableView.isEnableParallexHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
//       appDelegate.SetNavigationBarColor(self.navigationController!)
        
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
    
  /*  func scrollViewDidScroll(scrollView: UIScrollView) {
        if let navCtrl = self.navigationController {
            let alpha = scrollView.contentOffset.y / 0.0
            
            if alpha >= 1.0  {
                navCtrl.navigationBar.backgroundColor = UIColor.blackColor()
            } else {
//                let targetCIColor = CIColor(CGColor: self.TARGER_COLOR.CGColor)
//                let overlayColor = UIColor(red: targetCIColor.red, green: targetCIColor.green, blue: targetCIColor.blue, alpha: alpha)
                
                //self.overlayView.backgroundColor = UIColor.redColor().CGColor
                navCtrl.navigationBar.backgroundColor = UIColor.clearColor()
            }
        }
    }*/
    
    
    
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
                societyname = String(format: "# %@ - Notice #\n", arguments: [tempStr])
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
            //print(tempData)
            if let tempStr = tempData.object(forKey: "title") as? String {
                self.lblType.text = tempStr.uppercased()
            }
            if let tempStr = tempData.object(forKey: "number") as? String {
                self.lblNumber.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "time") as? String {
                self.lblTime.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "desc") as? String {
                self.lblDesc.text = tempStr
                
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
            
        }
        self.perform(#selector(setFooterView), with: nil, afterDelay: 0.1)
    }
    @objc func setFooterView(){
        self.lblDesc.sizeToFit()
        self.lblDesc.frame.origin.x = 15

        self.footerView.frame.size.height = self.lblDesc.frame.size.height
        self.tableView.tableFooterView = self.footerView
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
