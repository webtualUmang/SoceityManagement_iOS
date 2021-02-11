//
//  NeighbourViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class NeighbourViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    @IBOutlet var searchBar:UISearchBar!
    var searchActive : Bool = false
    var searchResultCells = NSMutableArray()
    @IBOutlet var headerView : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        // Do any dditional setup after loading the view.
        let nibName = UINib(nibName: "NieghbourCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "NieghbourCell")
        //self.perform("GetNoticeBoard")
        self.GetNoticeBoard()
        self.tableView.tableHeaderView = self.headerView
    }

//    func setSearchBar(){
//        searchBar.barStyle = UIBarStyle.Black
//        searchBar.showsCancelButton = true
//        searchBar.placeholder = "Search..."
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "NieghbourCell") as? NieghbourCell {
                    cell.data = tempData
                    if let tempStr = tempData.object(forKey: "name") as? String {
                        cell.lblName.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "data") as? String {
                        cell.lblDetails.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "user_image") as? String {
                        if tempStr.isEmpty == false {
                            let urlString : URL = URL(string: tempStr)!
                            cell.userImage.clipsToBounds = true
                            cell.userImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                                if image != nil {
                                    cell.userImage.image = image
                                }
                                
                            })
                            
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
        if self.searchActive == true {
            return searchResultCells.count
        }else{
            return ComplainsCells.count
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if self.searchActive == true {
            if searchResultCells.count > indexPath.row {
                if let cell = searchResultCells.object(at: indexPath.row) as? NieghbourCell {
                    return cell.frame.size.height
                }
            }
        }else{
            if ComplainsCells.count > indexPath.row {
                if let cell = ComplainsCells.object(at: indexPath.row) as? NieghbourCell {
                    return cell.frame.size.height
                }
            }
        }
        
        
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.searchActive == true {
            if searchResultCells.count > indexPath.row {
                if let cell = searchResultCells.object(at: indexPath.row) as? NieghbourCell {
                    return cell
                }
            }
        }else{
            if ComplainsCells.count > indexPath.row {
                if let cell = ComplainsCells.object(at: indexPath.row) as? NieghbourCell {
                    return cell
                }
            }
            
        }
        
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? NieghbourCell
        {
            if let tempStr = cell.data?.object(forKey: "memberID") as? String
            {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc:NieghbourDetailsViewController = storyboard.instantiateViewController(withIdentifier: "NieghbourDetailsViewController") as! NieghbourDetailsViewController
                vc.neighbourID = tempStr
            self.navigationController?.pushViewController(vc, animated: true)
                //let objRoot: NieghbourDetailsViewController = NieghbourDetailsViewController(nibName: "NieghbourDetailsViewController", bundle: nil)
               // objRoot.neighbourID = tempStr
               // self.navigationController?.pushViewController(objRoot, animated: true)
               
                
                
            }
        }
       
        
    }
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard()
    {

        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,"0"])
//        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"49", "1","0"])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "member_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.CreateCell(bannerList)
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
        if searchBar.text!.isEmpty
        {
            self.searchActive = false
            self.tableView.reloadData()
            
        }
        else
        {
            searchBar.showsCancelButton = true;
            self.searchActive = true
            self.searchResultCells.removeAllObjects()
            
            for cell in self.ComplainsCells
            {
                if let tempCell = cell as? NieghbourCell {
                    if let tempStr = tempCell.lblName.text {
                        
                        if tempStr.lowercased().range(of: searchText.lowercased())  != nil
                        {
                            self.searchResultCells.add(cell)
                        }
                    }
                    
                }
                
                
            }
            self.tableView.reloadData()
            
        }
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
