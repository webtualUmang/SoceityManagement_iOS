//
//  VisitorViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 17/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class VisitorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Visitor"
        let nibName = UINib(nibName: "VisitorCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "VisitorCell")
        
        self.CreateCell()
    }

    func CreateCell(){
        
        ComplainsCells = NSMutableArray()
        for _ in 0...20 {
            let cell: VisitorCell! = self.self.tableView.dequeueReusableCell(withIdentifier: "VisitorCell") as? VisitorCell
            
            ComplainsCells.add(cell)
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
        return ComplainsCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell = ComplainsCells.object(at: indexPath.row) as? VisitorCell
        return cell!.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? VisitorCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
