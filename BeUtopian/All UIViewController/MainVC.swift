//
//  MainVC.swift
//  BeUtopian
//
//  Created by desap on 13/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UIGestureRecognizerDelegate {

    var arrdata: NSMutableArray = NSMutableArray()
    var TermsCell: NSMutableArray = NSMutableArray()
    @IBOutlet var tableview: UITableView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let logo = UIImage(named: "notifiicon")
        let imageView = UIImageView(image:logo)
        //imageView.frame = CGRectMake(0, 0, 26, 50)
        imageView.contentMode = .scaleAspectFit
      
        self.navigationItem.titleView = imageView

        let nibName = UINib(nibName: "MainCell", bundle: nil)
        self.tableview .register(nibName, forCellReuseIdentifier: "MainCell")
        
        let nibName1 = UINib(nibName: "ComingSoonCell", bundle: nil)
        self.tableview .register(nibName1, forCellReuseIdentifier: "ComingSoonCell")
        
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "GetPurchaseOrdersTodaySummary", for: UIControl.Event.valueChanged)
        self.tableview.addSubview(self.refreshControl)
        
        self.arrdata = [
        ["Today":"133", "Awaiting":"81", "Title":"Credit Notes", "LastApproval":"J Breheny Contractors LTD", "Icon":"Assets_DisposalGrey"],
        ["Today":"154", "Awaiting":"49", "Title":"Asset Disposals", "LastApproval":"N632428 - Scanners", "Icon":"Assets_DisposalGrey"]]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

//        self.sidePanelController?.showCenterPanelAnimated(true)
        
        self.navigationItem.hidesBackButton = true
        appDelegate.SetNavigationBar(self.navigationController!)
        
        self.CreateCell()
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func OpenSlider(){
        self.sidePanelController?.showLeftPanel(animated: true)
    }
    func CreateCell(){
        
        TermsCell = NSMutableArray()

        for item in arrdata {
            
            let dic = item as? NSDictionary
            
            let cell: ComingSoonCell! = self.tableview.dequeueReusableCell(withIdentifier: "ComingSoonCell") as? ComingSoonCell
            
            if let title = dic?.object(forKey: "Title") as? String {
                cell.lbltitle.text = title
            }
            
            if let image = dic?.object(forKey: "Icon") as? String {
                cell.imgicon.image = UIImage(named: image)
            }
            
            
            TermsCell.add(cell)
        }
        
        self.tableview.reloadData()
    }
    
    
    //MARK: - TableView Delegate Method
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TermsCell.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        if let cell = TermsCell.object(at: indexPath.row) as? MainCell {
            return cell.frame.size.height
        }else if let cell = TermsCell.object(at: indexPath.row) as? ComingSoonCell {
            return cell.frame.size.height
        }
        
        return 0 
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if TermsCell.count > indexPath.row {
            if let cell = TermsCell.object(at: indexPath.row) as? UITableViewCell {
                return cell
            }
        }
        return UITableViewCell()
    }

    
    
    //MARK:- GetPurchaseOrdersTodaySummary -
    func GetPurchaseOrdersTodaySummary()
    {
        
        let urlStr = String(format: "%@/api/%@/PurchasingSystem/GetPurchaseOrdersTodaySummary?companyID=%@&employeeID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,appDelegate.CompanyID, appDelegate.EmployeeID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            
            DispatchQueue.main.async {
                appDelegate.PulseHideProgress()
                self.refreshControl.endRefreshing()
            }
            
            if succeeded == true {
                print(data)
                if let tempData = data as? NSDictionary {
                    
                    DispatchQueue.main.async {
                        appDelegate.DeskboardCommonObject = NSDictionary(dictionary: tempData)
//                        self.CreateDynamicCell(tempData, titlStr: "Purchase Orders")
                    }
                    
                }

                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                DispatchQueue.main.async {
                    appDelegate.PulseHideProgress()
                    self.refreshControl.endRefreshing()
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
