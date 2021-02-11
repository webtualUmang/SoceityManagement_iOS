//
//  FacilityDetailsViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class FacilityDetailsViewController: UIViewController {

    @IBOutlet var lblStatus : UILabel!
    @IBOutlet var lblFacilityName : UILabel!
    @IBOutlet var lblDetails : UILabel!
    @IBOutlet var lblBookingFrom : UILabel!
    @IBOutlet var lblBookingTo : UILabel!
    @IBOutlet var lblAmount : UILabel!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblRemark : UILabel!
    var resultData : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.perform(#selector(self.SetResultData), with: nil, afterDelay: 0.1)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Facility Detail"
    }
    @objc func SetResultData() {
        if let tempData = self.resultData {
            if let tempStr = tempData.object(forKey: "facility_name") as? String {
                self.lblFacilityName.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "detail") as? String {
                self.lblDetails.text = tempStr
            }
            
            if let tempStr = tempData.object(forKey: "booking_from") as? String {
                self.lblBookingFrom.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "booking_to") as? String {
                self.lblBookingTo.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "amount") as? String {
                self.lblAmount.text = "₹ " + tempStr
            }
            if let tempStr = tempData.object(forKey: "payment_status") as? String {
                self.lblStatus.text = tempStr.isEmpty == true ? "N/A" : tempStr
            }
            if let tempStr = tempData.object(forKey: "user_name") as? String {
                self.lblName.text = tempStr
            }
            if let tempStr = tempData.object(forKey: "remark") as? String {
                self.lblRemark.text = tempStr
                self.lblRemark.sizeToFit()
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
