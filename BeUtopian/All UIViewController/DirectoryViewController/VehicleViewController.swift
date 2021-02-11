//
//  VehicleViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    @IBOutlet var lblNodataFound:UILabel!
    
    @IBOutlet var searchBar:UISearchBar!
    var searchActive : Bool = false
    
    @IBOutlet var headerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "VehicleCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "VehicleCell")
//        self.performSelector("GetNoticeBoard")
       // self.GetNoticeBoard("")
      //  self.GetNoticeBoard("")
        self.tableView.tableHeaderView = self.headerView
        
    }

    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList
        {
            if let tempData = data as? NSDictionary
            {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "VehicleCell") as? VehicleCell {
                    cell.data = tempData
                    if let tempStr = tempData.object(forKey: "vehicle_no") as? String {
                        cell.lblNumber.text = tempStr
                    }
                    var flatNo = ""
                    if let tempStr = tempData.object(forKey: "flat") as? String {
                        flatNo = tempStr
                    }
                    
                    if let tempStr = tempData.object(forKey: "name") as? String {
                        cell.lblName.text = String(format: "%@ (%@)", arguments: [tempStr,flatNo])
                    }
                    if let tempStr = tempData.object(forKey: "vehicle_type") as? String {
                        if tempStr.caseInsensitiveCompare("Four wheeler") == .orderedSame {
                            cell.vehicleImage.image = UIImage(named: "car")
                        }else{
                            cell.vehicleImage.image = UIImage(named: "bike")
                        }
                    }
                    self.ComplainsCells.add(cell)
                }
            }
        }
        
        DispatchQueue.main.async {
           if self.ComplainsCells.count == 0
            {
                self.lblNodataFound.isHidden = false
            }
            else
            {
                self.lblNodataFound.isHidden = true
            }
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
        if let cell = ComplainsCells.object(at: indexPath.row) as? VehicleCell {
            return cell.frame.size.height
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? VehicleCell {
                return cell
            }
        }
        return UITableViewCell()
       
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard(_ searchText : String)
    {
        
        let urlStr = String(format: "%@?view=society_vehicle_list&page=list&userID=%@&societyID=%@&search=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,searchText])

        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "vehicle_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.CreateCell(bannerList)
                                }
                                
                                
                            }
                        }
                    }
                }
                
                
                
            }else{
                self.lblNodataFound.isHidden = false

                if let json = data as? NSDictionary
                {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
        
    }
    

    // MARK: UISearchBarDelegate functions
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        // Stop doing the search stuff
        // and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.resignFirstResponder()
        
        searchActive = false
        self.tableView.reloadData()
        searchBar.showsCancelButton = false;
        // You could also change the position, frame etc of the searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
//        if searchBar.text!.isEmpty
//        {
//            self.searchActive = false
//            self.tableView.reloadData()
//            
//        }
//        else
//        {
//            searchBar.showsCancelButton = true;
//            self.searchActive = true
//            self.searchResultCells.removeAllObjects()
//            
//            for cell in self.ComplainsCells
//            {
//                if let tempCell = cell as? NieghbourCell {
//                    if let tempStr = tempCell.lblName.text {
//                        
//                        if tempStr.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil
//                        {
//                            self.searchResultCells.addObject(cell)
//                        }
//                    }
//                    
//                }
//                
//                
//            }
//            self.tableView.reloadData()
//            
//        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = true;
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false;
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("BarSearch")
        
        print(searchBar.text)
        if searchBar.text?.isEmpty == false {
            print(searchBar.text)
            self.GetNoticeBoard(searchBar.text!)
        }
        searchBar.resignFirstResponder()
        
        
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
