//
//  EventDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 14/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var lblDay : UILabel!
    @IBOutlet var lblDayMonth : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblIntrested : UILabel!
    @IBOutlet var lblGoing : UILabel!
    @IBOutlet var lblVenue : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var imageBig : UIImageView!
    
    @IBOutlet var btnInterest : UIButton!
    @IBOutlet var btnGoing : UIButton!
    @IBOutlet var btnDownload : UIButton!
    var ResultData : NSDictionary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(EventDetailsViewController.imageTapped(_:)))
        imageBig.isUserInteractionEnabled = true
        imageBig.addGestureRecognizer(tapGestureRecognizer)
        
        self.btnDownload.layer.shadowOpacity = 0.5
        self.btnDownload.layer.shadowColor = UIColor.lightGray.cgColor
        self.btnDownload.layer.shadowOffset = CGSize(width: 0,height: 7)
        self.btnDownload.layer.cornerRadius = 25

        
//        let right = UIBarButtonItem(image: UIImage(named: "ic_menu_share"), style: .Plain, target: self, action: "shareClick:")
//        self.navigationItem.rightBarButtonItem = right
        
        // Do any additional setup after loading the view.
        //self.navigationItem.title = "Event Details"
        self.tableView.tableFooterView = self.footerView
                
        DispatchQueue.main.async {
            self.SetDetailsHeader()
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        let right = UIBarButtonItem(image: UIImage(named: "ic_menu_share"), style: .plain, target: self, action: #selector(EventDetailsViewController.shareClick(_:)))
        self.navigationItem.rightBarButtonItem = right
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        scrollViewDidScroll(tableView)
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
            print(tempData)
            let data = getLoginUser()
            
            var societyname = ""
            if let tempStr = data.object(forKey: "societyName") as? String {
                societyname = String(format: "# %@ - Event #\n\n", arguments: [tempStr])
            }
            
            var shareTitle = ""
            if let tempStr = tempData.object(forKey: "title") as? String {
                shareTitle = String(format: "%@\n\n", arguments: [tempStr])
            }
            
            
            var shareDesc = ""
            if let tempStr = tempData.object(forKey: "desc") as? String {
                shareDesc = String(format: "%@\n\n", arguments: [tempStr])
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
    

    @IBAction func GoingClick(_ sender : UIButton){
        if let tempData = ResultData  {
            if let tempStr = tempData.object(forKey: "on_going") as? String {
                let subStr = tempStr.components(separatedBy: "_")
                if subStr.count > 1 {
                    
                    let trueStr = subStr[1]
                    if trueStr.caseInsensitiveCompare("yes") == .orderedSame {
                        //                        self.btnGoing.setImage(UIImage(named: "event_going_no"), forState: .Normal)
                        self.MeetingGoing("No")
                    }else{
                        //                        self.btnGoing.setImage(UIImage(named: "event_going_yes"), forState: .Normal)
                        self.MeetingGoing("Yes")
                    }
                }
                
            }
        }
        
    }
    
    func MeetingGoing(_ isIntrest : String)
    {
        var meetingId = ""
        if let tempData = ResultData  {
            print(tempData)
            if let tempId = tempData.object(forKey: "eventID") as? String {
                meetingId = tempId
            }
            if let tempId = tempData.object(forKey: "eventID") as? NSNumber {
                meetingId = tempId.stringValue
            }
        }
        
        let urlStr = String(format: "%@?view=event&page=ongoing_events&userID=%@&societyID=%@&eventID=%@&types=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,meetingId,isIntrest])
        //        let urlStr = String(format: "%@?view=facility&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"1", "1",idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async {
                                
                                DispatchQueue.main.async {
                                    
                                    var newIntrest = ""
                                    if let tempStr = ResultData.object(forKey: "ongoing_event_count") as? String {
                                        newIntrest = tempStr
                                        let intrestStr = String(format: "%@ Going", arguments: [tempStr])
                                        self.lblGoing.text = intrestStr
                                    }
                                    
                                    if isIntrest.caseInsensitiveCompare("yes") == .orderedSame {
                                        self.btnGoing.setImage(UIImage(named: "event_going_yes"), for: UIControl.State())
                                        newIntrest = newIntrest + "_" + "Yes"
                                        
                                    }else{
                                        self.btnGoing.setImage(UIImage(named: "event_going_no"), for: UIControl.State())
                                        newIntrest = newIntrest + "_" + "No"
                                    }
                                    
                                    if let tempData = self.ResultData {
                                        let mutableResult = NSMutableDictionary(dictionary: tempData)
                                        mutableResult.setObject(newIntrest, forKey: "on_going" as NSCopying)
                                        self.ResultData = NSDictionary(dictionary: mutableResult)
                                    }
                                    
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
    
    
    
    @IBAction func IntrestClick(_ sender : UIButton){
        if let tempData = self.ResultData  {
            if let tempStr = tempData.object(forKey: "interested") as? String {
                let subStr = tempStr.components(separatedBy: "_")
                if subStr.count > 1 {
                    
                    let trueStr = subStr[1]
                    if trueStr.caseInsensitiveCompare("yes") == .orderedSame {
                        //                        self.btnInterest.setImage(UIImage(named: "event_intersed_no"), forState: .Normal)
                        self.MeetingIntrest("No")
                    }else{
                        //                        self.btnInterest.setImage(UIImage(named: "event_intersed_yes"), forState: .Normal)
                        self.MeetingIntrest("Yes")
                    }
                }
                
            }
        }
        
        
        
    }
    func MeetingIntrest(_ isIntrest : String)
    {
        var meetingId = ""
        if let tempData = ResultData  {
            print(tempData)
            if let tempId = tempData.object(forKey: "eventID") as? String {
                meetingId = tempId
            }
            if let tempId = tempData.object(forKey: "eventID") as? NSNumber {
                meetingId = tempId.stringValue
            }
        }
        
        let urlStr = String(format: "%@?view=event&page=interest_events&userID=%@&societyID=%@&eventID=%@&types=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,meetingId,isIntrest])
        //        let urlStr = String(format: "%@?view=facility&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"1", "1",idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async {
                                
                                var newIntrest = ""
                                if let tempStr = ResultData.object(forKey: "interest_event_count") as? String {
                                    newIntrest = tempStr
                                    let intrestStr = String(format: "%@ Interested", arguments: [tempStr])
                                    self.lblIntrested.text = intrestStr
                                }
                                
                                if isIntrest.caseInsensitiveCompare("yes") == .orderedSame {
                                    self.btnInterest.setImage(UIImage(named: "event_intersed_yes"), for: UIControl.State())
                                    newIntrest = newIntrest + "_" + "Yes"
                                    
                                }else{
                                    self.btnInterest.setImage(UIImage(named: "event_intersed_no"), for: UIControl.State())
                                    newIntrest = newIntrest + "_" + "No"
                                }
                                
                                if let tempData = self.ResultData {
                                    
                                    let mutableResult = NSMutableDictionary(dictionary: tempData)
                                    mutableResult.setObject(newIntrest, forKey: "interested" as NSCopying)
                                    self.ResultData = NSDictionary(dictionary: mutableResult)
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
    

    
    func SetDetailsHeader(){
        if let tempData = ResultData  {
            print(tempData)
            if let tempStr = tempData.object(forKey: "title") as? String {
                self.lblTitle.text = tempStr
            }
            
            if let tempStr = tempData.object(forKey: "detail") as? String {
                self.lblDetails.text = tempStr
                self.lblDetails.sizeToFit()
                self.footerView.frame.size.height = self.lblDetails.frame.size.height
            }
            if let tempStr = tempData.object(forKey: "day_month") as? String {
                let dateArray = tempStr.components(separatedBy: "-")
                var dayStr = ""
                if dateArray.count > 0 {
                    dayStr = dateArray[0]
                }
                var monthStr = ""
                if dateArray.count > 1 {
                    monthStr = dateArray[1]
                }
                self.lblDay.text = dayStr
                self.lblDayMonth.text = monthStr
            }
            if let tempStr = tempData.object(forKey: "venue") as? String {
                self.lblVenue.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "detail_date") as? String {
                self.lblDate.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "interested") as? String {
                let subStr = tempStr.components(separatedBy: "_")
                if subStr.count > 1 {
                    let intrestStr = String(format: "%@ Interested", arguments: [subStr[0]])
                    self.lblIntrested.text = intrestStr
                    let trueStr = subStr[1]
                    if trueStr.caseInsensitiveCompare("yes") == .orderedSame {
                        self.btnInterest.setImage(UIImage(named: "event_intersed_yes"), for: UIControl.State())
                    }else{
                        self.btnInterest.setImage(UIImage(named: "event_intersed_no"), for: UIControl.State())
                    }
                }

            }
            if let tempStr = tempData.object(forKey: "on_going") as? String {
                let subStr = tempStr.components(separatedBy: "_")
                if subStr.count > 1 {
                    let intrestStr = String(format: "%@ Going", arguments: [subStr[0]])
                    self.lblGoing.text = intrestStr
                    let trueStr = subStr[1]
                    if trueStr.caseInsensitiveCompare("yes") == .orderedSame {
                        self.btnGoing.setImage(UIImage(named: "event_going_yes"), for: UIControl.State())
                    }else{
                        self.btnGoing.setImage(UIImage(named: "event_going_no"), for: UIControl.State())
                    }
                }
                
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
