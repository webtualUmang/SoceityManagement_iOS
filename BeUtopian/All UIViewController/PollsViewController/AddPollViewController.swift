//
//  AddPollViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 02/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class AddPollViewController: UIViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var btnAllMember: UIButton!
    @IBOutlet var btnInstant: UIButton!
    @IBOutlet var btnAfterReach: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.tableHeaderView = headerView
        tableview.tableFooterView = footerView
        
        btnAllMember.set(image: UIImage(named: "check_blue"), title: "All members", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        btnInstant.set(image: UIImage(named: "check_blue"), title: "Instant", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        btnAfterReach.set(image: UIImage(named: "un_check"), title: "After Reach End date", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "Add Poll"
        
        let right = UIBarButtonItem(title: "Post", style: .plain, target: self, action: "AddPoll")
        self.navigationItem.rightBarButtonItem = right
    }
    
    func AddPoll(){
        
    }
    
    @IBAction func BtnPollTypeClick(_ sender: AnyObject){
        let btn = sender as? UIButton
        if(btn?.tag == 0){
            btnInstant.set(image: UIImage(named: "check_blue"), title: "Instant", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            btnAfterReach.set(image: UIImage(named: "un_check"), title: "After Reach End date", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        }
        else{
            btnInstant.set(image: UIImage(named: "un_check"), title: "Instant", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
            btnAfterReach.set(image: UIImage(named: "check_blue"), title: "After Reach End date", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
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
