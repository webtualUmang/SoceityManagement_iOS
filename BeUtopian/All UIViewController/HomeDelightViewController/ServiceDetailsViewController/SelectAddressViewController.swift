//
//  SelectAddressViewController.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class SelectAddressViewController: UIViewController, SelectAddressCellDelegate {

    @IBOutlet var tableview: UITableView!
    var NoOfCell = NSMutableArray()
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var btnContinues : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableview.estimatedRowHeight = 44
        tableview.tableHeaderView = headerView
        
        RegisterCell()
//        CreateCell()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Select Address"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        /*if(UserDefaults.standard.object(forKey: "AddressList") != nil ){
            let outData = UserDefaults.standard.data(forKey: "AddressList")
            let dict = (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSMutableArray)!
            self.CreateCell(arrData: dict)
        }*/
        
        self.GetAddressList()
    }

    //MARK: - CreateCell
    
    func RegisterCell(){
        let nibName = UINib(nibName: "SelectAddressCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "SelectAddressCell")
    }
    
    func CreateCell(arrData: NSArray){
        
       
        
        self.NoOfCell = NSMutableArray()
        
        var index : Int = 0
        for item in arrData {
            
            if let dics = item as? NSDictionary {
                
                if let cell = tableview.dequeueReusableCell(withIdentifier: "SelectAddressCell") as? SelectAddressCell {
                    
                    cell.delegete = self
                    cell.data = dics
                    
                    if let strTemp = dics.object(forKey: "location") as? String {
                        cell.lblTitle.text = strTemp
                    }
                    
                    var strLocation = ""
                    var strArea = ""
                    var strLandMark = ""
                    var strCityName = ""
                    var strPinCode = ""
                    
                    if let strTemp = dics.object(forKey: "location") as? String {
                        strLocation = strTemp
                    }
                    if let strTemp = dics.object(forKey: "street_area") as? String {
                        strArea = strTemp
                    }
                    if let strTemp = dics.object(forKey: "landmark") as? String {
                        strLandMark = strTemp
                    }
                    if let strTemp = dics.object(forKey: "city_name") as? String {
                        strCityName = strTemp
                    }
                    if let strTemp = dics.object(forKey: "pincode") as? String {
                        strPinCode = strTemp
                    }
                    
                    cell.lblAddress.text = String(format: "%@\n%@,%@,%@ - %@", arguments: [strLocation, strArea, strLandMark, strCityName, strPinCode])
                    
                    if let strTemp = dics.object(forKey: "mobileno") as? String {
                        cell.lblPhoneNo.text = strTemp
                    }
                    
                    if index == 0 {
                        self.selectAddress(cell: cell)
                    }
                    index = index + 1
                    NoOfCell.add(cell)
                }
            }
        }
        
        if NoOfCell.count > 0 {
            self.btnContinues?.isHidden = false
        }else{
            self.btnContinues?.isHidden = true
        }
        
        self.tableview.reloadData()
    }
    
    //MARK:- SelectAddressCellDelegate
    
    func BtnAddressEdit(cell: SelectAddressCell) {
        let rootObj = AddAddressViewController(nibName: "AddAddressViewController", bundle: nil)
        rootObj.navigationItem.title = "Update Address"
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    func BtnAddressDelete(cell: SelectAddressCell) {
        
    }
    
    func BtnSelectAddress(cell: SelectAddressCell) {
        
        if cell.btnSelect.imageView?.image == #imageLiteral(resourceName: "un_check") {
            cell.btnSelect.setImage(#imageLiteral(resourceName: "check_blue"), for: .normal)
        }
        else{
            cell.btnSelect.setImage(#imageLiteral(resourceName: "un_check"), for: .normal)
        }
    }
    
    @IBAction func BtnAddNewAddressClick(sender: Any){
        let rootObj = AddAddressViewController(nibName: "AddAddressViewController", bundle: nil)
        rootObj.navigationItem.title = "Add Address"
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    @IBAction func BtnContinueClick(sender: Any){
        let rootObj = ScheduleViewController(nibName: "ScheduleViewController", bundle: nil)
        self.navigationController?.pushViewController(rootObj, animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = NoOfCell.object(at: indexPath.row) as? SelectAddressCell {
            
            self.selectAddress(cell: cell)
        }
    }
    
    func selectAddress(cell : SelectAddressCell){
        cell.btnSelect.setImage(#imageLiteral(resourceName: "check_blue"), for: .normal)
        
        var strId = ""
        var strUserId = ""
        var strLocation = ""
        var strArea = ""
        var strLandMark = ""
        var strCityName = ""
        var strPinCode = ""
        var strMobileNo = ""
        var strCreateDate = ""
        var strIsDelete = ""
        
        if let strTemp = cell.data.object(forKey: "id") as? String {
            strId = strTemp
        }
        if let strTemp = cell.data.object(forKey: "user_id") as? String {
            strUserId = strTemp
        }
        if let strTemp = cell.data.object(forKey: "location") as? String {
            strLocation = strTemp
        }
        if let strTemp = cell.data.object(forKey: "street_area") as? String {
            strArea = strTemp
        }
        if let strTemp = cell.data.object(forKey: "landmark") as? String {
            strLandMark = strTemp
        }
        if let strTemp = cell.data.object(forKey: "city_name") as? String {
            strCityName = strTemp
        }
        if let strTemp = cell.data.object(forKey: "pincode") as? String {
            strPinCode = strTemp
        }
        if let strTemp = cell.data.object(forKey: "mobileno") as? String {
            strMobileNo = strTemp
        }
        if let strTemp = cell.data.object(forKey: "created_date") as? String {
            strCreateDate = strTemp
        }
        if let strTemp = cell.data.object(forKey: "isDeleted") as? String {
            strIsDelete = strTemp
        }
        
        //********** selectedUserAddress **********
        let selectedUserAddress = NSMutableDictionary()
        
        selectedUserAddress.setObject(strId, forKey: "id" as NSCopying)
        selectedUserAddress.setObject(strUserId, forKey: "user_id" as NSCopying)
        selectedUserAddress.setObject(strLocation, forKey: "location" as NSCopying)
        selectedUserAddress.setObject(strArea, forKey: "street_area" as NSCopying)
        selectedUserAddress.setObject(strLandMark, forKey: "landmark" as NSCopying)
        selectedUserAddress.setObject(strCityName, forKey: "city_name" as NSCopying)
        selectedUserAddress.setObject("", forKey: "state_name" as NSCopying)
        selectedUserAddress.setObject(strPinCode, forKey: "pincode" as NSCopying)
        selectedUserAddress.setObject(strIsDelete, forKey: "isDeleted" as NSCopying)
        selectedUserAddress.setObject(strCreateDate, forKey: "created_date" as NSCopying)
        selectedUserAddress.setObject("", forKey: "modified_date" as NSCopying)
        selectedUserAddress.setObject(strMobileNo, forKey: "mobileno" as NSCopying)
        selectedUserAddress.setObject("1", forKey: "checked" as NSCopying)
        
        appDelegate.HomeDelightData.setObject(selectedUserAddress, forKey: "selectedUserAddressObj" as NSCopying)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = NoOfCell.object(at: indexPath.row) as? SelectAddressCell {
            cell.btnSelect.setImage(#imageLiteral(resourceName: "un_check"), for: .normal)
        }
    }
    
    //MARK: - GetAddressList
    
    func GetAddressList(){

        ProgressHUD.show("Loading...")
        
        let param: Parameters = ["user_id":appDelegate.homeUserId]
        
        request(kGetUserAddressList, method: .post, parameters: param, encoding: JSONEncoding(options: [])).responseJSON { (responseData) in
            
            ProgressHUD.dismiss()
            
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                if let resData = swiftyJsonVar.arrayObject {
                    
                    if resData.count > 0 {
                        if let arrData = resData as? NSArray {
                            self.CreateCell(arrData: arrData)
                        }
                    }else{
                        self.btnContinues?.isHidden = true
                    }
                }else{
                    self.btnContinues?.isHidden = true
                }
            }else{
                self.btnContinues?.isHidden = true
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
