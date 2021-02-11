//
//  LanguageViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 11/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet var btnEnglish : UIButton!
    @IBOutlet var btnGujrati : UIButton!
    @IBOutlet var btnHindi : UIButton!
    
    @IBAction func languegeClick(_ sender : UIButton){
        if sender == btnEnglish {
            self.btnEnglish.isSelected = true
            self.btnGujrati.isSelected = false
            self.btnHindi.isSelected = false
        }else if sender == btnGujrati {
            self.btnEnglish.isSelected = false
            self.btnGujrati.isSelected = true
            self.btnHindi.isSelected = false
        }else if sender == btnHindi {
            self.btnEnglish.isSelected = false
            self.btnGujrati.isSelected = false
            self.btnHindi.isSelected = true
        }
    }
    
    @IBAction func continuesClick(_ sender : UIButton){
//        let objRoot : LoginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
//        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnEnglish.isSelected = true
        self.btnGujrati.isSelected = false
        self.btnHindi.isSelected = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Language"
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
