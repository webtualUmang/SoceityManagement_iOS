//
//  BazzarDetailViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 30/12/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class BazzarDetailViewController: UIViewController {

    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var lblPrice : UILabel!
    @IBOutlet var lblTime : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var imageview : UIImageView!
    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    @IBOutlet var tableview : UITableView!
    @IBOutlet var btnCallNow : UIButton!
    
    
    var resultData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(resultData)
        // Do any additional setup after loading the view.
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(tapGestureRecognizer)
        
        DispatchQueue.main.async
            {
            self.tableview.tableFooterView = self.footerView
            self.tableview.tableHeaderView = self.headerView
                
            self.setHeaderView()
        }
    }
    @IBAction func callNowClick(_ sender : UIButton)
    {
        if let tempStr = resultData.object(forKey: "show_no") as? String
        {
            if tempStr.caseInsensitiveCompare("yes") == .orderedSame
           {
            self.btnCallNow.setTitle("CALL NOW", for:.normal)
            if let url = URL(string: "tel://\(resultData["phone"] as? String ?? "")"),
            UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10, *) {
                 UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                     // add error message here
            }
            
            }
           else
           {
            self.btnCallNow.setTitle("EMAIL NOW", for:.normal)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
    }
    
    @objc func imageTapped(_ img: AnyObject)
    {
        // Your action
            if let tempStr = resultData.object(forKey: "main_image") as? String {
                if tempStr.isEmpty == false {
                    appDelegate.DownloadImageFromUrl(tempStr)
                }
            }
    }
    
    func setHeaderView(){
       
        if self.tableview != nil
        {
           // print(resultData)
            if let tempStr = resultData.object(forKey: "title") as? String {
                self.lblTitle.text = tempStr
                
                if tempStr.isEmpty == false {
                    self.navigationItem.title = tempStr
                }
            }
            if let tempStr = resultData.object(forKey: "time_ago") as? String {
                self.lblTime.text = tempStr
            }
            var isNegotiable = "no"
            if let tempStr = resultData.object(forKey: "negotiable") as? String {
                isNegotiable = tempStr
            }
            if let tempStr = resultData.object(forKey: "price") as? String
            {
                var priceStr = ""
                if isNegotiable.caseInsensitiveCompare("yes") == .orderedSame
                {
                    priceStr = String(format: "₹ %@ (Negotiable)", arguments: [tempStr])
                }else
                {
                    priceStr =  "₹ " + "\(tempStr)"
                }
                
                self.lblPrice.text = priceStr
            }
            var areaStr = ""
            if let tempStr = resultData.object(forKey: "area") as? String {
                areaStr = tempStr
            }
            if let tempStr = resultData.object(forKey: "city") as? String {
                self.lblAddress.text = String(format: "%@, %@", arguments: [areaStr,tempStr])
            }
            if let tempStr = resultData.object(forKey: "description") as? String {
                self.lblDesc.text = tempStr
            }
            
            if let tempStr = resultData.object(forKey: "show_no") as? String
            {
                if tempStr.caseInsensitiveCompare("yes") == .orderedSame
                {
                    self.btnCallNow.isHidden = false
                    self.btnCallNow.isUserInteractionEnabled = true
                    self.btnCallNow.setTitle("CALL NOW", for: .normal)
                }
                else
                {
                    self.btnCallNow.isHidden = true
                    self.btnCallNow.isUserInteractionEnabled = false
                    self.btnCallNow.setTitle("EMAIL NOW", for:.normal)
                }
            }
            
            if let tempStr = resultData.object(forKey: "main_image") as? String {
                if tempStr.isEmpty == false {
                    let urlString : URL = URL(string: tempStr)!
                    self.imageview.clipsToBounds = true
                    self.imageview.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                        if image != nil {
                            self.imageview.image = image
                        }
                        
                    })
                    
                }
            }
            
            DispatchQueue.main.async
                {
                self.lblDesc.sizeToFit()
                self.footerView.frame.size.height = self.lblDesc.frame.size.height
                self.tableview.tableFooterView = self.footerView
                self.tableview.tableHeaderView = self.headerView
                self.setHeaderView()
            }

        }else{
            //self.performSelector("setHeaderView", withObject: nil, afterDelay: 0.2)
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
