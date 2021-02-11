//
//  OrderReviewViewController.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class OrderReviewViewController: UIViewController, OrderTotalCellDelegate {

    @IBOutlet var tableview: UITableView!
    var NoOfCell = NSMutableArray()
    
    var isSelectTerm: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableview.estimatedRowHeight = 44
        
        RegisterCell()
        CreateCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "WGATE - Order review"
    }
    
    //MARK: - CreateCell
    
    func RegisterCell(){
        let nibName = UINib(nibName: "OrderReviewTitleCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "OrderReviewTitleCell")
        
        let nibName1 = UINib(nibName: "OrderItemCell", bundle: nil)
        tableview.register(nibName1, forCellReuseIdentifier: "OrderItemCell")
        
        let nibName2 = UINib(nibName: "OrderJobDetailsCell", bundle: nil)
        tableview.register(nibName2, forCellReuseIdentifier: "OrderJobDetailsCell")

        let nibName3 = UINib(nibName: "OrderTotalCell", bundle: nil)
        tableview.register(nibName3, forCellReuseIdentifier: "OrderTotalCell")
    }
    
    func CreateCell(){
        
        if let cell = tableview.dequeueReusableCell(withIdentifier: "OrderReviewTitleCell") as? OrderReviewTitleCell {
            NoOfCell.add(cell)
        }
        if let cell = tableview.dequeueReusableCell(withIdentifier: "OrderItemCell") as? OrderItemCell {
            NoOfCell.add(cell)
        }
        if let cell = tableview.dequeueReusableCell(withIdentifier: "OrderJobDetailsCell") as? OrderJobDetailsCell {
            NoOfCell.add(cell)
        }
        if let cell = tableview.dequeueReusableCell(withIdentifier: "OrderTotalCell") as? OrderTotalCell {
            cell.delegate = self
            NoOfCell.add(cell)
        }
        
        tableview.reloadData()
    }
    
    //MARK: - OrderTotalCellDelegate
    
    func BtnTermAndCondition(cell: OrderTotalCell) {
        
        if cell.btnTerm.imageView?.image == #imageLiteral(resourceName: "uncheckbox") {
            isSelectTerm = true
            cell.btnTerm.set(image: #imageLiteral(resourceName: "check_box_blue"), title: cell.btnTerm.titleLabel?.text as! NSString, titlePosition: .right, additionalSpacing: 10, state: .normal)
        }
        else{
            isSelectTerm = false
            cell.btnTerm.set(image: #imageLiteral(resourceName: "uncheckbox"), title: cell.btnTerm.titleLabel?.text as! NSString, titlePosition: .right, additionalSpacing: 10, state: .normal)
        }
    }
    
    //MARK:  -  Table View DataSource -
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NoOfCell.count > 0 {
            return NoOfCell.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if let cell = NoOfCell.object(at: indexPath.row) as? UITableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    @IBAction func BtnContinueClick(sender: Any){
        
        
        var strFirstName = ""
        var strLastName = ""
        var strEmail = ""
        var strImageUrl = ""
        var strMobileNo = ""
        
        let loginData = getLoginUser()
        if let Fname = loginData.object(forKey: "firstname") as? String {
            strFirstName = Fname
        }
        if let Lname = loginData.object(forKey: "lastname") as? String {
            strLastName = Lname
        }
        if let emailId = loginData.object(forKey: "email") as? String {
            strEmail = emailId
        }
        if let imageurl = loginData.object(forKey: "userimage") as? String {
            strImageUrl = imageurl
        }
        if let phone = loginData.object(forKey: "phone") as? String {
            strMobileNo = phone
        }
        
        //********** userDataDics **********
        let userDataDics = NSMutableDictionary()
        userDataDics.setObject(appDelegate.homeUserId, forKey: "user_id" as NSCopying)
        userDataDics.setObject(strFirstName, forKey: "user_name" as NSCopying)
        userDataDics.setObject("", forKey: "password" as NSCopying)
        userDataDics.setObject(strFirstName, forKey: "first_name" as NSCopying)
        userDataDics.setObject(strLastName, forKey: "last_name" as NSCopying)
        userDataDics.setObject(strEmail, forKey: "email" as NSCopying)
        userDataDics.setObject("", forKey: "birth_date" as NSCopying)
        userDataDics.setObject(strImageUrl, forKey: "image_url" as NSCopying)
        userDataDics.setObject(strMobileNo, forKey: "mobileno" as NSCopying)
        userDataDics.setObject("", forKey: "address" as NSCopying)
        userDataDics.setObject("", forKey: "house_no_street" as NSCopying)
        userDataDics.setObject("", forKey: "landmark" as NSCopying)
        userDataDics.setObject("", forKey: "postcode" as NSCopying)
        userDataDics.setObject("", forKey: "user_city" as NSCopying)
        userDataDics.setObject("", forKey: "user_state" as NSCopying)
        userDataDics.setObject("", forKey: "user_country" as NSCopying)
        userDataDics.setObject("", forKey: "role_id" as NSCopying)
        userDataDics.setObject("", forKey: "fb_id" as NSCopying)
        userDataDics.setObject("", forKey: "google_id" as NSCopying)
        userDataDics.setObject("", forKey: "status" as NSCopying)
        userDataDics.setObject("", forKey: "agreement" as NSCopying)
        userDataDics.setObject("", forKey: "pan_card" as NSCopying)
        userDataDics.setObject("", forKey: "id_proof" as NSCopying)
        userDataDics.setObject("", forKey: "police_verification" as NSCopying)
        userDataDics.setObject("", forKey: "address_proof" as NSCopying)
        userDataDics.setObject("", forKey: "vendor_reg_form" as NSCopying)
        userDataDics.setObject("", forKey: "pan_number" as NSCopying)
        userDataDics.setObject("", forKey: "account_holder_name" as NSCopying)
        userDataDics.setObject("", forKey: "bank_account_number" as NSCopying)
        userDataDics.setObject("", forKey: "bank_name" as NSCopying)
        userDataDics.setObject("", forKey: "bank_branch" as NSCopying)
        userDataDics.setObject("", forKey: "ifsc_code" as NSCopying)
        userDataDics.setObject("", forKey: "account_type" as NSCopying)
        userDataDics.setObject("", forKey: "sharingpercent" as NSCopying)
        userDataDics.setObject("", forKey: "due" as NSCopying)
        userDataDics.setObject("", forKey: "experiance" as NSCopying)
        userDataDics.setObject("", forKey: "serviceable_area" as NSCopying)
        userDataDics.setObject("", forKey: "device_id" as NSCopying)
        userDataDics.setObject("ios", forKey: "mobile_type" as NSCopying)
        userDataDics.setObject("", forKey: "job_status" as NSCopying)
        userDataDics.setObject("", forKey: "created_date" as NSCopying)
        userDataDics.setObject("", forKey: "modified_date" as NSCopying)
        
        appDelegate.HomeDelightData.setObject(userDataDics, forKey: "userData" as NSCopying)
        print(appDelegate.HomeDelightData)
        
//        if isSelectTerm == false{
//            appDelegate.TNMErrorMessage("", message: "Please check term & condition")
//            return
//        }
        
        //************ BookServiceData *********
        
        TNMWSMethod([appDelegate.HomeDelightData] as AnyObject, url: kBookService, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, response) in
            print(succeeded)
            print(response)
            
            if succeeded == true {
                print(response)
                if let json = response as? NSDictionary {
                    if let messageStr = json.object(forKey: "response_message") as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                        self.navigationController?.popFadeToRootViewController()
                    }
                }
                
            }else{
                if let json = response as? NSDictionary {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
