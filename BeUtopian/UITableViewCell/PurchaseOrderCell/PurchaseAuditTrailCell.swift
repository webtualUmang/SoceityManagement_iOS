//
//  PurchaseAuditTrailCell.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

protocol PurchaseAuditTrailCellDelegate {
    func BtnPurchaseAuditTrailCall(_ cell: PurchaseAuditTrailCell)
}

class PurchaseAuditTrailCell: UITableViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDetail: UILabel!
    var data : NSDictionary? {
        didSet{
            self.SetAuditData()
        }
    }
    
    var delegate: PurchaseAuditTrailCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    func SetAuditData(){
        if let auditData = self.data {
            if self.lblName != nil {
                if let tempStr = auditData.object(forKey: "EmployeeFriendlyName") as? String {
                    self.lblName.text = tempStr.capitalized
                }
                if let tempStr = auditData.object(forKey: "Details") as? String {
                    self.lblDetail.text = tempStr
                }
                if let tempStr = auditData.object(forKey: "AuditDate") as? String {
                    
                    self.lblDate.text = GetDateOrTime(tempStr).dateStr
                    self.lblTime.text = GetDateOrTime(tempStr).timeStr
                    
                }
                DispatchQueue.main.async {
                    self.SetFrame()
                }

            }else{
                self.perform("SetAuditData", with: nil, afterDelay: 0.1)
            }
            
        }
        
    }
//    func GetDateFromString(dateString : String)->(date : String, time : String){
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        let dateObj = dateFormatter.dateFromString(dateString)
//        
//        dateFormatter.dateFormat = "dd/MM/yyyy"
//        var dateStr = ""
//        if dateObj != nil {
//            dateStr = dateFormatter.stringFromDate(dateObj!)
//        }
////        print("Dateobj: \(dateStr))")
//        
//        dateFormatter.dateFormat = "HH:mm:ss"
//        var timeStr = ""
//        if dateObj != nil {
//            timeStr = dateFormatter.stringFromDate(dateObj!)
//        }
////        print("Dateobj: \(timeStr))")
//        
//        return (dateStr, timeStr)
//    }
    func SetFrame(){
        
        var setMainDefaultFrm = self.frame
        setMainDefaultFrm.size.height = 128
        self.frame = setMainDefaultFrm
        
        var detailFrm = self.lblDetail.frame
        detailFrm.size.width = (self.frame.size.width - detailFrm.origin.x) - 10
        detailFrm.size.height = 1
        self.lblDetail.frame = detailFrm
        
        
        self.lblDetail.sizeToFit()
        
        var cellFrame = self.frame
        cellFrame.size.height = cellFrame.size.height + self.lblDetail.frame.size.height
        self.frame = cellFrame
    }
    
    @IBAction func BtnCallClick(_ sender: AnyObject){
        delegate?.BtnPurchaseAuditTrailCall(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
