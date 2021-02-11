//
//  PurchaseDetailsCell.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

protocol PurchaseDetailsCellDelegate {
    func BtnPurchaseDetailsCall(_ cell: PurchaseDetailsCell)
    func reloadTableviewSize(_ cell : PurchaseDetailsCell)
}

class PurchaseDetailsCell: UITableViewCell {

    @IBOutlet var lblSupplierName: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblRequested: UILabel!
    @IBOutlet var lblDepot: UILabel!
    
    @IBOutlet var lblRef: UILabel!
    @IBOutlet var lblRefTitle: UILabel!
    
    @IBOutlet var lblOrderLines: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblOrderValue: UILabel!
    @IBOutlet var imageApproved: UIImageView!
    @IBOutlet var imageCheckApproved: UIImageView!
    
    @IBOutlet var imageJosephine: UIImageView!
    @IBOutlet var imageMatilda: UIImageView!
    @IBOutlet var imageAdeline: UIImageView!
    
    @IBOutlet var lblInstructions: UILabel!
    
    @IBOutlet var StatuGreenViewOne: UIView!
    
    var delegate: PurchaseDetailsCellDelegate?
    var data : NSDictionary? {
        didSet{
            self.SetCellData()
        }
    }
    
    @IBOutlet var tableview : UITableView!
    @IBOutlet var tblFooter : UIView!
    
    @IBOutlet var backgroundImage : UIImageView!
    
    var ApprovalCells = NSMutableArray()
    var viewController : UIViewController!{
        didSet{
            self.GetPurchaseOrderAuthorisationHistoryEmployees()
        }
    }
    
    func SetCellData(){
        if self.lblSupplierName != nil {
            if let tempData = self.data {
                if let suppiler = tempData.object(forKey: "SupplierName") as? String {
                    self.lblSupplierName.text = suppiler.capitalized
                }
                if let suppiler = tempData.object(forKey: "RequestedEmployeeName") as? String {
                    self.lblRequested.text = suppiler.capitalized
                }
                if let suppiler = tempData.object(forKey: "TotalOrderCost") as? NSNumber {
                    self.lblOrderValue.text = String(format: "£%.2f", arguments: [suppiler.floatValue])
                }
                
                if let suppiler = tempData.object(forKey: "DepotNumber") as? NSNumber {
                    self.lblDepot.text = String(format: "%@", arguments: [suppiler.stringValue])
                }
                if let name = tempData.object(forKey: "ReleaseNumber") as? NSNumber {
                    self.lblRef.text = String(format: "%@", arguments: [name.stringValue])
                    self.lblRefTitle.text = "Release No.:"
                    
                }
                if let name = tempData.object(forKey: "OrderLineCount") as? NSNumber {
                    self.lblOrderLines.text = String(format: "%@", arguments: [name.stringValue])
                }
                if let name = tempData.object(forKey: "DateCreated") as? String {
                    self.lblDate.text = GetFormatedDateromString(name)
                }
                if let name = tempData.object(forKey: "SpecialInstructions") as? String {
                    self.lblInstructions.text = String(format: "%@", arguments: [name])
                }else{
                    self.lblInstructions.text = "N/A"
                    
                }
                
                if let suppiler = tempData.object(forKey: "IsPendingApproval") as? NSNumber {
                    if suppiler == 1 {
                        self.imageApproved.isHidden = true
                        self.lblStatus.text = "Pending Approval"
                    }
                    
                    
                }
                
                if let suppiler = tempData.object(forKey: "IsApproved") as? NSNumber {
                    if suppiler == 1 {
                        self.imageApproved.isHidden = false
                        self.imageCheckApproved.image = UIImage(named: "tick_green")
                        self.StatuGreenViewOne.backgroundColor = UIColor(hexString: "00AC44")
                        self.lblStatus.text = "Approved"                        
                        if let name = tempData.object(forKey: "OrderNumber") as? String {
                            self.lblRef.text = String(format: "%@", arguments: [name])
                        }else if let name = tempData.object(forKey: "OrderNumber") as? NSNumber {
                            self.lblRef.text = String(format: "%@", arguments: [name.stringValue])
                        }
                        self.lblRefTitle.text = "Order No.:"
                    }
                    
                }
                if let suppiler = tempData.object(forKey: "IsDeclined") as? NSNumber {
                    if suppiler == 1 {
                        self.imageApproved.isHidden = false
                        self.imageApproved.image = UIImage(named: "Declined")
                        self.self.StatuGreenViewOne.backgroundColor = UIColor.red
                        self.lblStatus.text = "Declined"
                        
                    }
                    
                }
                
            }
        }else{
            self.perform("SetCellData", with: nil, afterDelay: 0.1)
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nibName = UINib(nibName: "ApprovalsCell", bundle: nil)
        self.tableview .register(nibName, forCellReuseIdentifier: "ApprovalsCell")
        
        let nibName1 = UINib(nibName: "CapexCell", bundle: nil)
        self.tableview .register(nibName1, forCellReuseIdentifier: "CapexCell")
        
        let nibName2 = UINib(nibName: "ApprovalsTitleCell", bundle: nil)
        self.tableview .register(nibName2, forCellReuseIdentifier: "ApprovalsTitleCell")
        
        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.SetLabelNFooter()
//        }
        self.perform("SetLabelNFooter", with: nil, afterDelay: 0.2)
       self.tableview.isUserInteractionEnabled = false
    }
    func SetLabelNFooter(){
        
        DispatchQueue.main.async {
            self.lblInstructions.sizeToFit()
            self.tableview.tableFooterView = self.tblFooter
            print(self.lblInstructions.frame)
            
            self.tblFooter.frame.size.height = self.lblInstructions.frame.height + 25
            self.lblInstructions.frame.origin.y = 15
            
            self.lblInstructions.frame.size.width = self.tblFooter.frame.width
            
//            //TableFrame 
//            var tblFrame = self.tableview.frame
//            tblFrame.size.height = tblFrame.size.height + self.tblFooter.frame.size.height
//            self.tableview.frame = tblFrame
//            
//            //MainCellFrame
//            var cellFrame = self.frame
//            cellFrame.size.height = cellFrame.size.height + self.tblFooter.frame.size.height
//            self.frame = cellFrame
            
            if self.delegate != nil {
                self.delegate?.reloadTableviewSize(self)
            }
            
        }
    }
    
    
    @IBAction func BtnCallClick(_ sender: AnyObject){
        delegate?.BtnPurchaseDetailsCall(self)
    }
    //MARK:- GetPurchaseOrderAuthorisationHistoryEmployees -
    func GetPurchaseOrderAuthorisationHistoryEmployees()
    {
        self.LoadingCell()
        
        
        var tempReleaseNumber = "0"
        if let tempData = self.data {
            if let name = tempData.object(forKey: "ReleaseNumber") as? NSNumber {
                tempReleaseNumber = name.stringValue
                
            }
        }
        
        let urlStr = String(format: "%@/api/%@/PurchasingSystem/GetPurchaseOrderAuthorisationHistoryEmployees?releaseNumber=%@&companyID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,tempReleaseNumber,appDelegate.CompanyID])
//        print(urlStr)
        
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: appDelegate.AuthToken, viewController: viewController) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let listData = data as? NSArray {
                    DispatchQueue.main.async {
                        if listData.count > 0 {
                            self.CreateCell(listData)
                        }else{
                            self.NoneCell()
                        }
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        self.NoneCell()
                    }
                }
                
            }else{
                DispatchQueue.main.async {
                    self.NoneCell()
                }
                
            }
        }
        
    }

    func CreateCell(_ listData : NSArray){
       
        self.ApprovalCells = NSMutableArray()
       
        //Capex cell
        self.CreateCapexCell()
        
        //Title Cell
        let titleCell: ApprovalsTitleCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsTitleCell") as? ApprovalsTitleCell
        self.ApprovalCells.add(titleCell)
        
        //Approvals Cell
        for appData in listData {
            if let appTempdata = appData as? NSDictionary {
                let cell: ApprovalsCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsCell") as? ApprovalsCell
                
                
                if let tempStr = appTempdata.object(forKey: "FriendlyName") as? String {
                    cell.lblName.text = tempStr
                }
                cell.tickImage.image = UIImage(named: "tick_green")
                
                if let IsDeclined = appTempdata.object(forKey: "IsDeclined") as? NSNumber {
                    if IsDeclined == 1 {
                        cell.tickImage.image = UIImage(named: "declinedSign")
                    }
                    
                }
                
                
                self.ApprovalCells.add(cell)
            }
        }
        
        //Next Employee Name
        if let tempData = self.data {
            if let name = tempData.object(forKey: "NextEmployeeName") as? String {
                if name.isEmpty == false {
                    let cell: ApprovalsCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsCell") as? ApprovalsCell
                    
                    let nameStr = String(format: "%@", arguments: [name])
                    cell.lblName.text = nameStr
                    cell.tickImage.image = UIImage(named: "tick_grey")
                    self.ApprovalCells.add(cell)
                }
            }
        }
        
        self.tableview.reloadData()
        
        DispatchQueue.main.async {
            self.setCellFrame()
        }
        
    }
    
    func CreateCapexCell(){
        if let tempData = self.data {
            var CustomerNumber = ""
            if let tempStr = tempData.object(forKey: "CustomerNumber") as? String {
                CustomerNumber = tempStr
            }
            var CustomerName = ""
            if let tempStr = tempData.object(forKey: "CustomerName") as? String {
                CustomerName = tempStr
            }
            var HireRate : NSNumber = 0
            if let tempStr = tempData.object(forKey: "HireRate") as? NSNumber {
                HireRate = tempStr
            }
            var PeriodOfHire = ""
            if let tempStr = tempData.object(forKey: "PeriodOfHire") as? String {
                PeriodOfHire = tempStr
            }
            var CapitalFactor : NSNumber = 0
            if let tempStr = tempData.object(forKey: "CapitalFactor") as? NSNumber {
                CapitalFactor = tempStr
            }
            var PaybackPeriod : NSNumber = 0
            if let tempStr = tempData.object(forKey: "PaybackPeriod") as? NSNumber {
                PaybackPeriod = tempStr
            }
            var Carriage : NSNumber = 0
            if let tempStr = tempData.object(forKey: "Carriage") as? NSNumber {
                Carriage = tempStr
            }
            
            if CustomerNumber != "" && CustomerName != "" && HireRate != 0 && PeriodOfHire != "" && CapitalFactor != 0 && PaybackPeriod != 0 && Carriage != 0 {
                //CapexCell
                let cell: CapexCell! = self.tableview.dequeueReusableCell(withIdentifier: "CapexCell") as? CapexCell
                if let tempStr = tempData.object(forKey: "CapexType") as? String {
                    cell.RequestedType.text = tempStr == "" ? "N/A" : tempStr
                }
                var custNo = ""
                if let tempStr = tempData.object(forKey: "CustomerNumber") as? String {
                    custNo = tempStr
                }
                if let tempStr = tempData.object(forKey: "CustomerName") as? String {
                    let nameStr = String(format: "%@ - %@", arguments: [custNo,tempStr])
                    cell.CustomerName.text = nameStr == "" ? "N/A" : nameStr
                }
                if let tempStr = tempData.object(forKey: "HireRate") as? NSNumber {
                    cell.HireRate.text = String(format: "£%.2f", arguments: [tempStr.floatValue])
                }
                if let tempStr = tempData.object(forKey: "PeriodOfHire") as? String {
                    cell.PeriodOfHire.text = tempStr == "" ? "N/A" : tempStr
                }
                if let tempStr = tempData.object(forKey: "PaybackPeriod") as? NSNumber {
                    cell.PaybackPeriod.text = tempStr.stringValue
                }
                if let tempStr = tempData.object(forKey: "CapitalFactor") as? NSNumber {
                    cell.CapitalFactor.text = tempStr.stringValue
                }
                if let tempStr = tempData.object(forKey: "Carriage") as? NSNumber {
                    cell.Carriage.text = String(format: "£%.2f", arguments: [tempStr.floatValue])
                }
                self.ApprovalCells.add(cell)
                self.tableview.reloadData()
            }
            
        }
        
        
    }
    func setCellFrame(){

        var height : CGFloat = 0
        
        for cell in self.ApprovalCells {
            if let tempCell = cell as? UITableViewCell {
                height = height + tempCell.frame.size.height
            }
        }
        height = height + self.tblFooter.frame.size.height
        
        print("height of tableview")
        print(height)
        
        var tblFrame = self.tableview.frame
        tblFrame.size.height = height
        self.tableview.frame = tblFrame
        
        //MainCell
        var cellFrame = self.frame
        print("before size of tableview")
        print(cellFrame.size.height)
        cellFrame.size.height = 392 + height //392 is defautl cell hight
        self.frame = cellFrame
        
        if self.delegate != nil {
            self.delegate?.reloadTableviewSize(self)
        }
        
        
    }
    func NoneCell(){
        
        
        self.ApprovalCells = NSMutableArray()
        
        self.CreateCapexCell()
        
        
        //Title Cell
        let titleCell: ApprovalsTitleCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsTitleCell") as? ApprovalsTitleCell
        self.ApprovalCells.add(titleCell)
        
        
        //None Cell
        let cell: ApprovalsCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsCell") as? ApprovalsCell
        var nameStr = "None"
        if let tempData = self.data {
            if let name = tempData.object(forKey: "NextEmployeeName") as? String {
                if name.isEmpty == false {
                    nameStr = name
                }
            }
        }
        
        cell.lblName.text = nameStr
        cell.tickImage.image = UIImage(named: "tick_grey")
        self.ApprovalCells.add(cell)
        
        self.tableview.reloadData()
        
        DispatchQueue.main.async {
            self.setCellFrame()
        }

    }
    func LoadingCell(){
        
        self.ApprovalCells = NSMutableArray()
        
        //Capex Cell
        self.CreateCapexCell()
        
        
        //Title Cell
        let titleCell: ApprovalsTitleCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsTitleCell") as? ApprovalsTitleCell
        self.ApprovalCells.add(titleCell)
        
        //Loading Cell
        let cell: ApprovalsCell! = self.tableview.dequeueReusableCell(withIdentifier: "ApprovalsCell") as? ApprovalsCell
        let nameStr = "Loading..."
        cell.lblName.text = nameStr
        cell.tickImage.isHidden = true
        self.ApprovalCells.add(cell)
        
        self.tableview.reloadData()
        
        DispatchQueue.main.async {
            self.setCellFrame()
        }
    }
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApprovalCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        if let cell = ApprovalCells.object(at: indexPath.row) as? UITableViewCell {
            return cell.frame.size.height
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if ApprovalCells.count > indexPath.row {
            if let cell = ApprovalCells.object(at: indexPath.row) as? UITableViewCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
