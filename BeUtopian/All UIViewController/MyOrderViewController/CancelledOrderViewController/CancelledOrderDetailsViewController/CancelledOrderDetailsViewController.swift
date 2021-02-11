//
//  CancelledOrderDetailsViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 13/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class CancelledOrderDetailsViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = headerView
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
