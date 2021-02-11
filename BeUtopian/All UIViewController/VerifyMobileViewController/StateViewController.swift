//
//  StateViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 03/01/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit
var selectedStateName = ""
class StateViewController: UIViewController {

    
    @IBOutlet var tableview : UITableView!
    var stateResult = NSArray()
    var ComplainsCells = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibName = UINib(nibName: "StateCell", bundle: nil)
        self.tableview .register(nibName, forCellReuseIdentifier: "StateCell")
        
        self.perform("CreateCell", with: nil, afterDelay: 0.1)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Select State"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
//    func GetResult(){
//        print(stateResult)
//    }
    func CreateCell(){
        
        if self.tableview != nil {
            ComplainsCells = NSMutableArray()
            
            for data in self.stateResult {
                if let tempData = data as? NSDictionary {
                    if let cell = self.tableview.dequeueReusableCell(withIdentifier: "StateCell") as? StateCell {
                        if let tempStr = tempData.object(forKey: "name") as? String {
                            cell.lableTitle.text = tempStr
                        }
                        cell.data = tempData
                        ComplainsCells.add(cell)
                    }
                    
                }
            }
            DispatchQueue.main.async {
                self.tableview.reloadData()
            }
        }else{
            self.perform("CreateCell", with: nil, afterDelay: 0.1)
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
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? StateCell {
                return cell.frame.size.height
            }
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? StateCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? StateCell {
            DispatchQueue.main.async {
                let objRoot: CityViewController = CityViewController(nibName: "CityViewController", bundle: nil)
                if let tempData = cell.data {
                    objRoot.resultData = tempData
                    
                    if let tempStr = tempData.object(forKey: "name") as? String {
                        selectedStateName = tempStr
                    }
                }
                self.navigationController?.pushFadeViewController(viewcontrller: objRoot)
                
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
