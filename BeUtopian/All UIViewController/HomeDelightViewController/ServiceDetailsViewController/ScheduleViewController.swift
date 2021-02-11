//
//  ScheduleViewController.swift
//  CollectionView
//
//  Created by tnmmac4 on 12/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet var tableview: UITableView!
    var NoOfCell = NSMutableArray()
    
    var isServiceAvailable : Bool = false
    
    @IBOutlet var collectionView: UICollectionView!
    var arrDate = NSMutableArray() //[["Day":"Sat", "Month":"Feb 10"], ["Day":"Sun", "Month":"Feb 11"], ["Day":"Mon", "Month":"Feb 12"], ["Day":"Tue", "Month":"Feb 13"], ["Day":"Web", "Month":"Feb 14"], ["Day":"Thus", "Month":"Feb 15"], ["Day":"Fri", "Month":"Feb 16"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableview.estimatedRowHeight = 44
        
        RegisterCell()
//        CreateCell()
        
        self.GetTimeSlotNew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Schedule"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func BtnContinueClick(sender: Any){
        
        if self.isServiceAvailable == true {
            let rootObj = OrderReviewViewController(nibName: "OrderReviewViewController", bundle: nil)
            self.navigationController?.pushViewController(rootObj, animated: true)
        }else{
            appDelegate.TNMErrorMessage("", message: "Please select date and time first!")
        }
        
    }
    
    //MARK: - UICollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleDateCell", for: indexPath) as? ScheduleDateCell {
            if let dics = arrDate.object(at: indexPath.row) as? NSDictionary {
                cell.data = dics
                if let strTemp = dics.object(forKey: "day") as? String {
                    cell.lblDay.text = strTemp
                }
                if let strTemp = dics.object(forKey: "date") as? String {
                    cell.lblMonth.text = strTemp
                }
                if let isChecked = dics.object(forKey: "checked") as? String {
                    if isChecked.caseInsensitiveCompare("yes") == .orderedSame {
                        self.checkedDateCell(cell: cell)
                    }else{
                        cell.lblDay.textColor = UIColor.black
                        cell.lblMonth.textColor = UIColor(hexString: "909090")
                        cell.bgView.backgroundColor = UIColor.white
                    }
                }
              
            return cell
            }
        
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let tempDataList = NSMutableArray()
        for (index, data) in self.arrDate.enumerated() {
            if let result = data as? NSDictionary {
                let tempResult = NSMutableDictionary(dictionary: result)
                if index == indexPath.row {
                    tempResult.setObject("yes", forKey: "checked" as NSCopying)
                }else{
                    tempResult.setObject("no", forKey: "checked" as NSCopying)
                }
                
                tempDataList.add(tempResult)
            }
        }
        
        self.arrDate = NSMutableArray(array: tempDataList)
        self.collectionView.reloadData()
        
        
    }
    func checkedDateCell(cell : ScheduleDateCell){
        cell.lblDay.textColor = UIColor.white
        cell.lblMonth.textColor = UIColor.white
        cell.bgView.backgroundColor = UIColor(hexString: "398CBE")
        
        if let time_data = cell.data.object(forKey: "time_data") as? NSArray {
            self.CreateCell(arrTime: time_data)
        }
        
        var strServiceDate = ""
        var strDayName = ""
        var strMonth = ""
        var strDate = ""
        
        
        if let serviceDate = cell.data.object(forKey: "service_date") as? String {
            strServiceDate = serviceDate
        }
        if let day = cell.data.object(forKey: "day") as? String {
            strDayName = day
        }
        if let month = cell.data.object(forKey: "date") as? String {
            
            let fullNameArr = month.components(separatedBy: " ")
            
            if fullNameArr.count > 0 {
                strMonth = fullNameArr[0]
                strDate = fullNameArr[1]
            }
        }
        
        //********** selectDateOrderDataDics **********
        let selectDateOrderDataDics = NSMutableDictionary()
        
        selectDateOrderDataDics.setObject(strServiceDate, forKey: "dateObj" as NSCopying)
        selectDateOrderDataDics.setObject(strDate, forKey: "day" as NSCopying)
        selectDateOrderDataDics.setObject(strMonth, forKey: "monthName" as NSCopying)
        selectDateOrderDataDics.setObject(strDayName, forKey: "dayName" as NSCopying)
        
        appDelegate.HomeDelightData.setObject(selectDateOrderDataDics, forKey: "selectedDateOrderObj" as NSCopying)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? ScheduleDateCell {
//            cell.lblDay.textColor = UIColor.black
//            cell.lblMonth.textColor = UIColor(hexString: "909090")
//            cell.bgView.backgroundColor = UIColor.white
//        }
        
    }
    
    //MARK: - CreateCell
    
    func RegisterCell(){
        let nibName = UINib(nibName: "ScheduleTimeCell", bundle: nil)
        tableview.register(nibName, forCellReuseIdentifier: "ScheduleTimeCell")
        
        let nibName1 = UINib(nibName: "ScheduleDateCell", bundle: nil)
        collectionView.register(nibName1, forCellWithReuseIdentifier: "ScheduleDateCell")
    }
    
    func CreateCell(arrTime: NSArray){
        
        //let arrData = [["Time":"10:00 to 12:00"], ["Time":"12:00 to 14:00"], ["Time":"14:00 to 16:00"], ["Time":"16:00 to 18:00"], ["Time":"18:00 to 20:00"]]
        
        NoOfCell = NSMutableArray()
        
        for item in arrTime {
            
            if let dics = item as? NSDictionary {
                
                if let cell = tableview.dequeueReusableCell(withIdentifier: "ScheduleTimeCell") as? ScheduleTimeCell {
                    
                    cell.data = dics
                    cell.imgCheck.image = #imageLiteral(resourceName: "un_check")
                    if let strTemp = dics.object(forKey: "times") as? String {
                        cell.lblTitle.text = strTemp
                    }
                    
                    NoOfCell.add(cell)
                }
            }
        }
        self.tableview.reloadData()
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
        
        if let cell = NoOfCell.object(at: indexPath.row) as? ScheduleTimeCell {
            
            if let available = cell.data.object(forKey: "available") as? String {
                if available.caseInsensitiveCompare("yes") == .orderedSame {
                    cell.imgCheck.image = #imageLiteral(resourceName: "check_blue")
                    
                    var strDate = ""
                    
                    if let strTemp = cell.data.object(forKey: "times") as? String {
                        strDate = strTemp
                    }
                    
                    //********** selectTimeSlotDataDics **********
                    let selectTimeSlotDataDics = NSMutableDictionary()
                    
                    selectTimeSlotDataDics.setObject("", forKey: "id" as NSCopying)
                    selectTimeSlotDataDics.setObject(strDate, forKey: "time" as NSCopying)
                    selectTimeSlotDataDics.setObject("1", forKey: "checked" as NSCopying)
                    
                    appDelegate.HomeDelightData.setObject(selectTimeSlotDataDics, forKey: "selectedTimeSlotObj" as NSCopying)
                    
                    if let available = cell.data.object(forKey: "available") as? String {
                        if available.caseInsensitiveCompare("yes") == .orderedSame {
                            self.isServiceAvailable = true
                        }else{
                            self.isServiceAvailable = false
                        }
                    }else{
                        self.isServiceAvailable = false
                    }
                    
                }else{
                    appDelegate.TNMErrorMessage("", message: "Service is not available for your selected time!")
                }
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = NoOfCell.object(at: indexPath.row) as? ScheduleTimeCell {
            cell.imgCheck.image = #imageLiteral(resourceName: "un_check")
        }
    }
    
    func GetTimeSlotNew(){
       
        TNMWSMethod(nil, url: "http://shivay.elrix.org/mapp?view=time_slot_new", isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            
            if succeeded == true {
                print(data)
                
                if let userDetails = data as? NSDictionary{
                    if let msgCode = userDetails.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let datas = userDetails.object(forKey: "time_slot") as? NSArray {
                                if datas.count > 0 {
                                    
                                    DispatchQueue.main.async {
                                        self.arrDate = NSMutableArray()
                                        
                                        
                                        for (index,data) in datas.enumerated() {
                                            if let result = data as? NSDictionary {
                                                let tempResult = NSMutableDictionary(dictionary: result)
                                                if index == 0 {
                                                    tempResult.setObject("yes", forKey: "checked" as NSCopying)
                                                }else{
                                                    tempResult.setObject("no", forKey: "checked" as NSCopying)
                                                }
                                                
                                                self.arrDate.add(tempResult)
                                            }
                                        }
                                        DispatchQueue.main.async {
                                            self.collectionView.reloadData()
                                        }
                                        
                                        
                                        
                                        if let firstDics = datas.object(at: 0) as? NSDictionary {
                                            
                                            if let time_data = firstDics.object(forKey: "time_data") as? NSArray {
                                                self.CreateCell(arrTime: time_data)
                                            }
                                        }
                                    }
                                }
                            }
                        }
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
