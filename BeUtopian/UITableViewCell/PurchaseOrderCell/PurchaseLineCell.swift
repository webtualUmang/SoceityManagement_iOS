//
//  PurchaseLineCell.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

protocol PurchaseLineDelegate {
    func ReloadMainTableView()
}

class PurchaseLineCell: UITableViewCell {

    var delegate : PurchaseLineDelegate?
    
    @IBOutlet var lblOrderLine: UILabel!
    @IBOutlet var lblPartNo: UILabel!
    @IBOutlet var lblPlantCode: UILabel!
    @IBOutlet var lblGroup: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblNominal: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblUnitPrice: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblDeliveryDepot: UILabel!
    @IBOutlet var lblInstructions: UILabel!
    
    var lineData : NSDictionary?{
        didSet{
            self.ConfigureUI()
        }
    }
    
    func ConfigureUI(){
        if self.lblOrderLine != nil {
            if let tempStr = lineData?.object(forKey: "LineNumber") as? NSNumber {
                self.lblOrderLine.text = tempStr.stringValue
            }
            if let tempStr = lineData?.object(forKey: "PartNumber") as? String {
                self.lblPartNo.text = tempStr
            }
            if let tempStr = lineData?.object(forKey: "PlantNumber") as? String {
                self.lblPlantCode.text = tempStr
            }
            if let tempStr = lineData?.object(forKey: "Group") as? String {
                self.lblGroup.text = tempStr
            }
            if let tempStr = lineData?.object(forKey: "Description") as? String {
                self.lblDescription.text = tempStr.capitalized
            }
            if let tempStr = lineData?.object(forKey: "StemNominalDesc") as? String {
                self.lblNominal.text = String(format: "%@", arguments: [tempStr])
            }
            if let tempStr = lineData?.object(forKey: "DeliveryDate") as? String {
                self.lblDate.text = GetDateOrTime(tempStr).dateStr
            }
            if let tempStr = lineData?.object(forKey: "Qty") as? NSNumber {
                self.lblQuantity.text = String(format: "%@", arguments: [tempStr.stringValue])
            }
            if let tempStr = lineData?.object(forKey: "UnitPrice") as? NSNumber {
                self.lblUnitPrice.text = String(format: "£%.2f", arguments: [tempStr.floatValue])

            }
            if let tempStr = lineData?.object(forKey: "Discount") as? NSNumber {
                self.lblDiscount.text = String(format: "%@%%", arguments: [tempStr.stringValue])
            }
            if let tempStr = lineData?.object(forKey: "LineTotal") as? NSNumber {
                self.lblTotal.text = String(format: "£%.2f", arguments: [tempStr.floatValue])
            }
            if let tempStr = lineData?.object(forKey: "DeliveryDepotNumber") as? NSNumber {
                self.lblDeliveryDepot.text = String(format: "%@", arguments: [tempStr.stringValue])
            }
            if let tempStr = lineData?.object(forKey: "LineComment") as? String {
                self.lblInstructions.text = String(format: "%@", arguments: [tempStr])
                
                self.perform("SetCellFrame", with: nil, afterDelay: 0.1)
//                self.performSelector("SetCellFrame")

                
            }else{
                self.lblInstructions.text = "N/A"
                self.lblInstructions.sizeToFit()
                
                
            }
        }else{
            self.perform("ConfigureUI", with: nil, afterDelay: 0.1)

        }
//        self.lblOrderLine.text = tempStr == "0" ? "N/A" : tempStr
    }
    
    func SetCellFrame(){
        self.lblInstructions.sizeToFit()
        DispatchQueue.main.async {
            
            var frmCell = self.frame
            frmCell.size.height = frmCell.size.height + self.lblInstructions.frame.size.height
            self.frame = frmCell
            
            if self.delegate != nil {
                self.delegate?.ReloadMainTableView()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
