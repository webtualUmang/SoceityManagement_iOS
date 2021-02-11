//
//  ResetPasswordViewController.swift
//  BeUtopian
//
//  Created by tnmmac4 on 01/06/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, BSKeyboardControlsDelegate {

    @IBOutlet var tableview: UITableView!
    @IBOutlet var headerview: UIView!
    var keyboard: BSKeyboardControls!
    
    @IBOutlet var txtOldPassword: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.tableHeaderView = headerview
        
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPasswordViewController.onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(ResetPasswordViewController.onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        keyboard = BSKeyboardControls(fields: [txtOldPassword,txtNewPassword,txtConfirmPassword])
        keyboard.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Reset Password"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Keyboard Event -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        self.tableview.scrollRectToVisible(field.frame, animated: true)
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        view.endEditing(true)
    }
    @objc func onKeyboardHide(_ notification: Notification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let duration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        UIView.animate(withDuration: duration, animations: { () -> Void in
            let edgeInsets  = UIEdgeInsets.zero;
            self.tableview.contentInset = edgeInsets
            self.tableview.scrollIndicatorInsets = edgeInsets
        })
    }
    @objc func onKeyboardShow(_ notification: Notification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let kbMain  = (userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)! as AnyObject).cgRectValue
        let kbSize = kbMain?.size
        let duration  = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double;
        UIView.animate(withDuration: duration, animations: { () -> Void in
            let edgeInsets  = UIEdgeInsets.init(top: 0, left: 0, bottom: (kbSize?.height)!, right: 0)
            self.tableview.contentInset = edgeInsets
            self.tableview.scrollIndicatorInsets = edgeInsets
            if (self.keyboard.activeField) != nil
            {
                self.tableview.scrollRectToVisible(self.keyboard.activeField!.frame, animated: true)
            }
        })
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
