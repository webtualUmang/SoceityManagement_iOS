//
//  PollAnswerView.swift
//  BeUtopian
//
//  Created by tnmmac4 on 04/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

protocol PollOpenResultsViewDelegate{
    
    func Btnclose()
    func BtnUserVote(_ data: NSDictionary, pollid: String)
}

class PollOpenResultsView: UIView {

    @IBOutlet var lblTitle: UILabel!
    var delegate: PollOpenResultsViewDelegate?
    
    @IBOutlet var tableView: UITableView!
    var ComplainsCells: NSMutableArray = NSMutableArray()
    var isSelect: Bool?
    var strpollid: String = ""
    
    var data = NSDictionary(){
        didSet{
            
            if(isSelect == true){
                self.perform("CreateVoteCell", with: data, afterDelay: 0.5)
            }
            else{
                self.perform("CreateCell", with: data, afterDelay: 0.5)
            }
        }
    }
    
    class func instanceFromNib() -> PollOpenResultsView {
        return UINib(nibName: "PollOpenResultsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PollOpenResultsView
    }
    override func awakeFromNib() {
        
        let nibName = UINib(nibName: "PollsResultsCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "PollsResultsCell")
        
        let nibName1 = UINib(nibName: "PollsVotesCell", bundle: nil)
        self.tableView .register(nibName1, forCellReuseIdentifier: "PollsVotesCell")
    }
    
    @IBAction func BtnCloseClick(_ sender: AnyObject){
        if(delegate != nil){
            delegate?.Btnclose()
        }
    }
    
    func CreateCell(){
        
        ComplainsCells = NSMutableArray()
        
        if let strTemp = data.object(forKey: "title") as? String {
            lblTitle.text = strTemp
        }
        
        let screenframes = UIScreen.main.bounds.size
        
        var ypostion: CGFloat = 0
        
        if let answers_list = data.object(forKey: "answers_list") as? NSArray {
            
            for list in answers_list {
                
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "PollsResultsCell") as? PollsResultsCell {
                    
                    if let tempdic = list as? NSDictionary {
                        
                        
                        if let strTemp = tempdic.object(forKey: "answer") as? String {
                            cell.lblTitle.text = strTemp
                        }
                        
                        if let strTemp = tempdic.object(forKey: "total_votes") as? String {
                            cell.lblVote.text = String(format: "%@ Vote(s)", strTemp)
                            
                            if(strTemp != "0"){
                                cell.Percentage.backgroundColor = UIColor(hexString: "2995CC")
                            }
                        }

                        
                        var frames = self.frame
                        
                        
                        if ypostion == screenframes.height {
                            
                        }
                        else if ypostion != 65 {
                            
                            frames.size.height += 65 //* CGFloat(data.count)
                            self.frame = frames
                        }
                        else{
                            
                            frames.size.height = 65
                            self.frame = frames
                            ypostion = frames.size.height
                        }
                    }
                    ComplainsCells.add(cell)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func CreateVoteCell(){
        
        ComplainsCells = NSMutableArray()
        
        if let strTemp = data.object(forKey: "title") as? String {
            lblTitle.text = strTemp
        }
        
        if let strTemp = data.object(forKey: "pollID") as? String {
            strpollid = strTemp
        }
        
        let screenframes = UIScreen.main.bounds.size
        
        var ypostion: CGFloat = 0
        
        if let answers_list = data.object(forKey: "answers_list") as? NSArray {
            
            for list in answers_list {
                
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "PollsVotesCell") as? PollsVotesCell {
                    
                    if let tempdic = list as? NSDictionary {
                        
                        cell.data = tempdic
                        
                        if let strTemp = tempdic.object(forKey: "answer") as? String {
                            cell.lblTitle.text = strTemp
                        }
                        
                        var frames = self.frame
                        
                        
                        if ypostion == screenframes.height {
                            
                        }
                        else if ypostion != 65 {
                            
                            frames.size.height += 65 //* CGFloat(data.count)
                            self.frame = frames
                        }
                        else{
                            
                            frames.size.height = 65
                            self.frame = frames
                            ypostion = frames.size.height
                        }
                    }
                    ComplainsCells.add(cell)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - TableView Delegate Method
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat{
        let cell = ComplainsCells.object(at: indexPath.row) as? UITableViewCell
        return cell!.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? UITableViewCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = ComplainsCells.object(at: indexPath.row) as? PollsVotesCell {
            
            cell.imgRadio.image = UIImage(named: "check_blue")
            
            if(delegate != nil){
                delegate?.BtnUserVote(cell.data!, pollid: strpollid)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = ComplainsCells.object(at: indexPath.row) as? PollsVotesCell {
            
            cell.imgRadio.image = UIImage(named: "un_check")
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
