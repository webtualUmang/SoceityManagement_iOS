//
//  AboutViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 11/17/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async
            {
          
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "About Wgate"
    }
   
   
    func BackClick()
    {
        DispatchQueue.main.async
            {
            // update some UI
             self.navigationController?.popViewController(animated: true)
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
/**
The html replacement regular expression
*/

