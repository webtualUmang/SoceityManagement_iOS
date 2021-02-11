//
//  CompainRegarding.swift
//  BeUtopian
//
//  Created by Jeevan on 30/12/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit
protocol RegardingPopupDelegate {
    func SelectRegardOption(_ data : NSDictionary)
}
class CompainRegarding: UIView,UITableViewDelegate,UITableViewDataSource
{

    var delegate : RegardingPopupDelegate?
    
    var resultList = NSArray()
    var resultKey = ""
    @IBOutlet var lblTopTitle : UILabel!
    
    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    
    class func instanceFromNib() -> CompainRegarding {
        return UINib(nibName: "CompainRegarding", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CompainRegarding
    }
    override func awakeFromNib() {
        let nibName = UINib(nibName: "RegardCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "RegardCell")
        self.CreateCell()
        
    }
    func CreateCell(){
        self.ComplainsCells = NSMutableArray()

        for resultStr in self.resultList {
            if let tempData = resultStr as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "RegardCell") as? RegardCell {
                    cell.data = tempData
                    if let titleStr = tempData.object(forKey: resultKey) as? String {
                        cell.titleLabel.text = titleStr
                    }
                    
                    self.ComplainsCells.add(cell)
                    
                }
            }
            

        }
        self.tableView.reloadData()
        
    }
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if let cell = ComplainsCells.object(at: indexPath.row) as? UITableViewCell {
            return cell.frame.size.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? UITableViewCell {
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? RegardCell {
            if self.delegate != nil {
                if let tempData = cell.data {
                    self.delegate?.SelectRegardOption(tempData)
                }
                
            }
        }
        
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
