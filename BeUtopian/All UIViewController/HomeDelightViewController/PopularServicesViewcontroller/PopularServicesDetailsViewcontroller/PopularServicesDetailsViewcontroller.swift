//
//  PopularServicesDetailsViewcontroller.swift
//  BeUtopian
//
//  Created by Nikunj on 18/01/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class PopularServicesDetailsViewcontroller: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    var NoOfCell = NSMutableArray()
    
    @IBOutlet var headerView : UIView!
    @IBOutlet var footerView : UIView!
    @IBOutlet var txtSpecialInstructions: UITextView!
    var strServiceId = ""
    var serviceTypeArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 44
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        
        let nibName = UINib(nibName: "PopularDetailsCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "PopularDetailsCell")
        
        self.GetServicesType()
        
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Job Details"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    func CreateCell(_ resultList : NSArray){
        
        //        let data = ["Wiring", "Light", "Switch", "Others"]
        
        for item in resultList {
            
            if let dics = item as? NSDictionary {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "PopularDetailsCell") as? PopularDetailsCell {
                    
                    cell.data = dics
                    
                    var subServiceId = ""
                    var serviceName = ""
                    var servicePrice = ""
                    
                    if let strName = dics.object(forKey: "service_name") as? String {
                        cell.lblTitle.text = strName
                        serviceName = strName
                    }
                    if let strPrice = dics.object(forKey: "start_price") as? String {
                        cell.lblNo.text = strPrice
                        servicePrice = strPrice
                    }
                    
                    if let strTemp = cell.data.object(forKey: "sub_subservice_id") as? String {
                        subServiceId = strTemp
                    }
                    
                    let serviceTypeDics: NSDictionary = ["sub_service_id":subServiceId, "text":serviceName, "price":servicePrice, "checked":"0"]
                    cell.selectData = serviceTypeDics
//                    serviceTypeArray.add(serviceTypeDics)
                    
                    NoOfCell.add(cell)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func BtnContinueClick(sender: Any){
        self.serviceTypeArray = NSMutableArray()
        var isChecked : Bool = false
        for item in NoOfCell {
            if let cell = item as? PopularDetailsCell {
                if let checked = cell.selectData.object(forKey: "checked") as? String {
                    if checked == "1" {
                        isChecked = true
                    }
                }
                serviceTypeArray.add(cell.selectData)
            }
        }

        if isChecked == true {
            //********** serviceTypeArray **********
            appDelegate.HomeDelightData.setObject(txtSpecialInstructions.text!, forKey: "SpecialInstructions" as NSCopying)
            appDelegate.HomeDelightData.setObject(serviceTypeArray, forKey: "serviceTypeObj" as NSCopying)
            
            let rootObj = SelectAddressViewController(nibName: "SelectAddressViewController", bundle: nil)
            self.navigationController?.pushViewController(rootObj, animated: true)
        }else{
            appDelegate.TNMErrorMessage("", message: "Select at least one option")
        }
        
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtSpecialInstructions.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.txtSpecialInstructions.resignFirstResponder()
    }
    
    //MARK: - TableView Delegate Method
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoOfCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if NoOfCell.count > indexPath.row {
            if let cell = NoOfCell.object(at: indexPath.row) as? PopularDetailsCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        
        if self.NoOfCell.count > indexPath.row {
            if let cell = self.NoOfCell.object(at: indexPath.row) as? PopularDetailsCell {
                
                var subServiceId = ""
                var serviceName = ""
                var servicePrice = ""
                
                if let strTemp = cell.data.object(forKey: "sub_subservice_id") as? String {
                    subServiceId = strTemp
                }
                if let strTemp = cell.data.object(forKey: "service_name") as? String {
                    serviceName = strTemp
                }
                if let strTemp = cell.data.object(forKey: "start_price") as? String {
                    servicePrice = strTemp
                }
                
                
                if let isChecked = cell.selectData.object(forKey: "checked") as? String {
                    if isChecked == "0" {
                        cell.checkimg.image = #imageLiteral(resourceName: "checkbox")
                        cell.checkimg.tintColor = NSTheme().GetNavigationBGColor()
                        let serviceTypeDics: NSDictionary = ["sub_service_id":subServiceId, "text":serviceName, "price":servicePrice, "checked":"1"]
                        cell.selectData = serviceTypeDics
                    }else{
                        cell.checkimg.image = #imageLiteral(resourceName: "uncheckbox")
                        let serviceTypeDics: NSDictionary = ["sub_service_id":subServiceId, "text":serviceName, "price":servicePrice, "checked":"0"]
                        cell.selectData = serviceTypeDics
                    }
                }
            }
        }
        
       /* if let cell = NoOfCell.object(at: indexPath.row) as? PopularDetailsCell {
            
            var subServiceId = ""
            var serviceName = ""
            var servicePrice = ""
            
            if let strTemp = cell.data.object(forKey: "sub_subservice_id") as? String {
                subServiceId = strTemp
            }
            if let strTemp = cell.data.object(forKey: "service_name") as? String {
                serviceName = strTemp
            }
            if let strTemp = cell.data.object(forKey: "start_price") as? String {
                servicePrice = strTemp
            }
            
            cell.checkimg.image = #imageLiteral(resourceName: "checkbox")
            cell.checkimg.tintColor = NSTheme().GetNavigationBGColor()
            
            let serviceTypeDics = ["sub_service_id":subServiceId, "text":serviceName, "price":servicePrice, "checked":"1"]
            serviceTypeArray.replaceObject(at: indexPath.row, with: serviceTypeDics)
        }*/
    }
    
    /*func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = NoOfCell.object(at: indexPath.row) as? PopularDetailsCell {
            cell.checkimg.image = #imageLiteral(resourceName: "uncheckbox")
            
            var subServiceId = ""
            var serviceName = ""
            var servicePrice = ""
            
            if let strTemp = cell.data.object(forKey: "sub_subservice_id") as? String {
                subServiceId = strTemp
            }
            if let strTemp = cell.data.object(forKey: "service_name") as? String {
                serviceName = strTemp
            }
            if let strTemp = cell.data.object(forKey: "start_price") as? String {
                servicePrice = strTemp
            }
            
            let serviceTypeDics = ["sub_service_id":subServiceId, "text":serviceName, "price":servicePrice, "checked":"0"]
            serviceTypeArray.replaceObject(at: indexPath.row, with: serviceTypeDics)
        }
    }*/
    
    //MARK: - GetServicesType
    
    func GetServicesType(){
        
        let data = ["service_id":strServiceId]
        
        TNMWSMethod(data as AnyObject, url: kGetServicesType, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            
            if succeeded == true {
                print(data)
                DispatchQueue.main.async {
                    
                    if let datas = data as? NSArray {
                        self.CreateCell(datas)
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
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

