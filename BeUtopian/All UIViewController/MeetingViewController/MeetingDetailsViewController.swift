//
//  EventDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 14/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class MeetingDetailsViewController: UIViewController {

    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var lblDayMonth : UILabel!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblIntrested : UILabel!
    @IBOutlet var lblGoing : UILabel!
    @IBOutlet var lblVenue : UILabel!
    @IBOutlet var lblDate : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var lblMeetingNo : UILabel!
    @IBOutlet var imageBig : UIImageView!
    
    @IBOutlet var btnInterest : UIButton!
    @IBOutlet var btnGoing : UIButton!
    
    var ResultData : NSDictionary?
    
    
    @IBOutlet var btnStatus : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(_:)))
        imageBig.isUserInteractionEnabled = true
        imageBig.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Meeting Details"
        
        DispatchQueue.main.async {
            self.SetDetailsHeader()
            
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
    
    @objc func imageTapped(_ img: AnyObject)
    {
        // Your action
        if let tempData = ResultData  {
            if let tempStr = tempData.object(forKey: "file") as? String {
                if tempStr.isEmpty == false {
                    appDelegate.DownloadImageFromUrl(tempStr)
                }
            }
            
        }
    }
    
    func MeetingGoing(_ isIntrest : String)
    {
        var meetingId = ""
        if let tempData = ResultData  {
            print(tempData)
            if let tempId = tempData.object(forKey: "meetingID") as? String {
                meetingId = tempId
            }
            if let tempId = tempData.object(forKey: "meetingID") as? NSNumber {
                meetingId = tempId.stringValue
            }
        }
        
        let urlStr = String(format: "%@?view=meeting&page=ongoing_meeting&userID=%@&societyID=%@&meetingID=%@&types=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,meetingId,isIntrest])
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
                                    if let tempStr = ResultData.object(forKey: "ongoing_count") as? String {
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
            if let tempId = tempData.object(forKey: "meetingID") as? String {
                meetingId = tempId
            }
            if let tempId = tempData.object(forKey: "meetingID") as? NSNumber {
                meetingId = tempId.stringValue
            }
        }

        let urlStr = String(format: "%@?view=meeting&page=interest_meeting&userID=%@&societyID=%@&meetingID=%@&types=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,meetingId,isIntrest])
        //        let urlStr = String(format: "%@?view=facility&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"1", "1",idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async{
                                
                                var newIntrest = ""
                                if let tempStr = ResultData.object(forKey: "interest_count") as? String {
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
//        if let tempData = ResultData  {
//            var shareTitle = ""
//            if let tempStr = tempData.objectForKey("share_msg") as? String {
//                shareTitle = String(format: "# %@ #\n\n", arguments: [tempStr])
//            }
//            var notes = ""
//            if let tempStr = tempData.objectForKey("notes") as? String {
//                notes = String(format: "%@", arguments: [tempStr])
//            }
//           
//            let shareList = [shareTitle, notes]
//            
//            appDelegate.ShareDetailsResult(shareList)
//        }
        
        if let tempData = ResultData  {
            
            let data = getLoginUser()
            
            var societyname = ""
            if let tempStr = data.object(forKey: "societyName") as? String {
                societyname = String(format: "# %@ - Meeting #\n", arguments: [tempStr])
            }
            
            var shareTitle = ""
            if let tempStr = tempData.object(forKey: "brief_topic") as? String {
                shareTitle = String(format: "%@\n", arguments: [tempStr])
            }
            
            
            var shareDesc = ""
            if let tempStr = tempData.object(forKey: "notes") as? String {
                shareDesc = String(format: "%@\n", arguments: [tempStr])
            }
            //            var urlString = ""
            //            if let tempStr = tempData.objectForKey("image") as? String {
            //                if tempStr.isEmpty == false {
            //                    urlString  = tempStr
            //
            //                }
            //            }
            
//            let shareImage = self.imageBig.image
            
            let shareList : NSArray = [appDelegate.GetEmptyString(societyname), appDelegate.GetEmptyString(shareTitle), appDelegate.GetEmptyString(shareDesc)]
            
            appDelegate.ShareDetailsResult(shareList)
        }

        
    }
    

    
    func SetDetailsHeader(){
       
        if let tempData = ResultData  {
            
            if let statusStr = tempData.object(forKey: "status") as? String {
                if statusStr.caseInsensitiveCompare("Close") == .orderedSame {
                    self.btnStatus.setImage(UIImage(named: "closed_blue"), for: UIControl.State())
                }else{
                    self.btnStatus.setImage(UIImage(named: "open_blue"), for: UIControl.State())
                }
            }
            //if let tempStr = tempData.objectForKey("initiated_by") as? String {
              //  self.lblTitle.text = tempStr
            //}
            
            if let tempStr = tempData.object(forKey: "brief_topic") as? String {
                self.lblTitle.text = tempStr.uppercased()
            }
            
            
            if let tempStr = tempData.object(forKey: "meeting_date") as? String {
                 let dateStr = tempStr.components(separatedBy: "-")
                var day = ""
                if dateStr.count > 0 {
                    day = dateStr[0]
                }
                let monthStr = tempStr.components(separatedBy: "_")
                var month = ""
                if monthStr.count > 0 {
                    month = monthStr[monthStr.count - 1]
                }
                let dateFullStr = String(format: "%@\n%@", arguments: [day,month])
                self.lblDayMonth.text = dateFullStr
            }
            if let tempStr = tempData.object(forKey: "venue") as? String {
                self.lblVenue.text = tempStr
            }
            
            var datetime: String = ""
            
            if let tempStr = tempData.object(forKey: "meeting_date") as? String {
                let monthStr = tempStr.components(separatedBy: "_")
                var month = ""
                if monthStr.count > 0 {
                    month = monthStr[0]
                }
                datetime = month
            }
            if let tempStr = tempData.object(forKey: "meeting_time") as? String {
                self.lblDate.text = String(format: "%@ @ %@", datetime, tempStr)
            }
            
            if let tempStr = tempData.object(forKey: "meeting_no") as? String {
                self.lblMeetingNo.text = String(format: "No. %@", tempStr)
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
            
            if let tempStr = tempData.object(forKey: "file") as? String {
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

            
            let mutableString = NSMutableAttributedString()
            
            if let tempStr = tempData.object(forKey: "notes") as? String {
                mutableString.NormalText(tempStr, color: UIColor.gray, size: 14)
                
            }
            print(tempData)
            if let dataList = tempData.object(forKey: "agenda_list") as? NSArray {
                if dataList.count > 0 {
                    
                    mutableString.BoldText("\n\nAgenda", color: UIColor.black, size: 15)
                }
                for agenda in dataList {
                    if let agendaData = agenda as? NSDictionary {
                        if let agdSr = agendaData.object(forKey: "Sr") as? NSNumber {
                            mutableString.NormalText("\n", color: UIColor.gray, size: 14)
                            mutableString.NormalText(agdSr.stringValue, color: UIColor.gray, size: 14)
                        }else if let agdSr = agendaData.object(forKey: "Sr") as? String {
                            mutableString.NormalText("\n", color: UIColor.gray, size: 14)
                            mutableString.NormalText(agdSr, color: UIColor.gray, size: 14)
                        }
                        if let agdSr = agendaData.object(forKey: "agenda") as? String {
                            mutableString.NormalText(" ", color: UIColor.gray, size: 14)
                            mutableString.NormalText(agdSr, color: UIColor.gray, size: 14)
                        }
                    }
                }
            }
            self.lblDetails.attributedText = mutableString
            self.lblDetails.sizeToFit()
            self.footerView.frame.size.height = self.lblDetails.frame.size.height

            
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
