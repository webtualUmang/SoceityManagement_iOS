//
//  MyFlatMemberViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 25/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class VehiclesListViewController: UIViewController, VehiclesListCellDelegate,UITableViewDelegate,UITableViewDataSource
{

    var ComplainsCells = NSMutableArray()
    @IBOutlet var tableView: UITableView!

    var popup: KOPopupView?
    var flatID : String = ""
    var data = NSDictionary()

    //Popup
    @IBOutlet var MemberView: UIView!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumber: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblGender: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    @IBOutlet var lblNodata: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "VehiclesListCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "VehiclesListCell")
        
        self.navigationItem.title = "Vehicles"
        // Do any additional setup after loading the view.
        
//        GetFlatMemberList(flatID)
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        GetVehiclesList(appDelegate.FlatID)
    }
    
    @IBAction func BtnAddMemberClick(_ sender: AnyObject){
        let rootObj: AddVehiclesViewController = AddVehiclesViewController(nibName: "AddVehiclesViewController", bundle: nil)
//        rootObj.flatId = flatID
        rootObj.isAdd = false
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    func BtnMoreOptions(_ cell: VehiclesListCell) {
        
        let refreshAlert = UIAlertController(title: "Action", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        refreshAlert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action: UIAlertAction!) in
            
            let rootObj: AddVehiclesViewController = AddVehiclesViewController(nibName: "AddVehiclesViewController", bundle: nil)
            
            rootObj.isAdd = true
            rootObj.data = cell.data
            self.navigationController?.pushViewController(rootObj, animated: true)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            
            if let strTemp = cell.data!.object(forKey: "vehicle_ID") as? String {
                self.DeleteVehicle(strTemp)
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        self.navigationController?.present(refreshAlert, animated: true, completion: nil)
    }
    
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "VehiclesListCell") as? VehiclesListCell {
                    cell.data = tempData
                    cell.delegate = self
                    
                    if let tempStr = tempData.object(forKey: "vehicle_no") as? String {
                        cell.lblVehicleNo.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "sticker_no") as? String {
                        cell.lblStickerNo.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "make_model") as? String {
                        cell.lblModelNo.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "type") as? String {
                        if(tempStr == "2_wheeler"){
                            cell.bikeImage.image = UIImage(named: "bike")
                        }
                        else{
                            cell.bikeImage.image = UIImage(named: "car")
                        }
                    }
                    
                    self.ComplainsCells.add(cell)
                }
                
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? VehiclesListCell {
                return cell.frame.size.height
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? VehiclesListCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? VehiclesListCell {
            
//            data = cell.data!
//            OpenRegardPopups()
        }
    }

    
    //MARK:- Get Flat MemberList -
    func GetVehiclesList(_ flatId : String){
        

        
        let urlStr = String(format: "%@?view=my_parking&page=flat_vehicle&userID=%@&societyID=%@&flatID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,flatId])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            self.lblNodata.isHidden = true
                            if let bannerList = ResultData.object(forKey: "parking_vehicles") as? NSArray {
                                DispatchQueue.main.async {
                                    self.CreateCell(bannerList)
                                }
                            }
                        }
                        else{
                            self.lblNodata.isHidden = false
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
    
    //MARK: - Delete Member
    
    func DeleteVehicle(_ vehicleid: String){
   
        
        
        let urlStr = String(format: "%@?view=my_parking&page=delete_vehicle&userID=%@&societyID=%@&flatID=%@&vehicle_ID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,appDelegate.FlatID, vehicleid])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            self.GetVehiclesList(appDelegate.FlatID)
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                        }
                        else{
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
