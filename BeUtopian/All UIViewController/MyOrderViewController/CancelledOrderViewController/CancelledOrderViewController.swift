//
//  CancelledOrderViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 13/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class CancelledOrderViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    var NoOfCell = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.estimatedRowHeight = 44
        
        self.RegisterCell()
        self.CreateCell()
    }

    //MARK: - RegisterCell
    
    func RegisterCell(){
        
        let nibName = UINib(nibName: "CancelledOrderCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "CancelledOrderCell")
    }
    
    func CreateCell(){
        
        let data = [["Title":"ELECTRICIAN", "OrderId":"AHMEDABAD14578", "PlaceOn":"21-02-2018", "Status":"Cancelled"]]
        
        for item in data {
            
            if let dics = item as? NSDictionary {
                if let cell = self.tableView.dequeueReusableCell(withIdentifier: "CancelledOrderCell") as? CancelledOrderCell {
                    
                    cell.dataDic = dics
                    
                    if let strName = dics.object(forKey: "Title") as? String {
                        cell.lblTitle.text = strName
                    }
                    
                    let attributeString = NSMutableAttributedString()
                    
                    if let strName = dics.object(forKey: "OrderId") as? String {
                        attributeString.NormalText(String(format: "Order Id: ", strName), color: UIColor.darkGray, size: cell.lblDescription.font.pointSize)
                        attributeString.NormalText(String(format: "%@\n", strName), color: UIColor.black, size: cell.lblDescription.font.pointSize)
                    }
                    
                    if let strName = dics.object(forKey: "PlaceOn") as? String {
                        attributeString.NormalText(String(format: "Place On: ", strName), color: UIColor.darkGray, size: cell.lblDescription.font.pointSize)
                        attributeString.NormalText(String(format: "%@\n", strName), color: UIColor.black, size: cell.lblDescription.font.pointSize)
                    }
                    
                    if let strName = dics.object(forKey: "Status") as? String {
                        attributeString.NormalText(String(format: "Status: ", strName), color: UIColor.darkGray, size: cell.lblDescription.font.pointSize)
                        attributeString.NormalText(String(format: "%@", strName), color: UIColor.black, size: cell.lblDescription.font.pointSize)
                    }
                    
                    cell.lblDescription.attributedText = attributeString
                    
                    NoOfCell.add(cell)
                }
            }
        }
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
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
            if let cell = NoOfCell.object(at: indexPath.row) as? UITableViewCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        if let cell = NoOfCell.object(at: indexPath.row) as? CancelledOrderCell {
            
            var title = ""
            if let strName = cell.dataDic?.object(forKey: "Title") as? String {
                title = strName
            }
            
            let rootObj = CancelledOrderDetailsViewController(nibName: "CancelledOrderDetailsViewController", bundle: nil)
            rootObj.navigationItem.title = title
            self.navigationController?.pushViewController(rootObj, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

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
