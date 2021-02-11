//
//  DiscussionAddViewController.swift
//  BeUtopian
//
//  Created by tnmmac4 on 30/12/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit
protocol AddDiscussionDelegate{
    func reloadDisscutionData()
    
}
class DiscussionAddViewController: UIViewController, BSKeyboardControlsDelegate, UITextViewDelegate {

    var delegate : AddDiscussionDelegate?
    
    @IBOutlet var txtDiscussion: UITextField!
    @IBOutlet var txtDescription: UITextField!
    @IBOutlet var btnAllMember: UIButton!
    var keyboard: BSKeyboardControls!
    @IBOutlet var textview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.text = "Description*"
        textview.textColor = UIColor.lightGray
        
        let rightbtn = UIBarButtonItem(title: "Post", style: .plain, target: self, action:#selector(self.AddDiscussion))
        self.navigationItem.rightBarButtonItem = rightbtn
        
        btnAllMember.set(image: UIImage(named: "check_blue"), title: "  All Member", titlePosition: .right, additionalSpacing: 10, state: UIControl.State())
        
        keyboard = BSKeyboardControls(fields: [txtDiscussion])
        keyboard.delegate = self
        
        txtDiscussion.autocorrectionType = .no
        textview.autocorrectionType = .no
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description*"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func AddDiscussion()
    {
        var despction = ""
        if let tempStr = self.textview.text {
            despction = tempStr
        }
        var topic = ""
        if let tempStr = self.txtDiscussion.text {
            topic = tempStr
        }

        
        let urlStr = String(format: "%@?view=discussion&page=discussion_add&userID=%@&societyID=%@&description=%@&topic=%@&type=All", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,despction,topic])
        
         let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print(requestUrl)
        TNMWSMethod(nil, url: requestUrl!, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                                                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            isDataAddedToSociety = true
                            if let message = ResultData.object(forKey: "message") as? String {
                                self.TNMErrorMessage("", message: message)
                            }
                            
//                            if let bannerList = ResultData.objectForKey("discus_list") as? NSArray {
//                               
//                                
//                                
//                            }
                        }
                    }
                }
               
                
            }else{
                if let json = data as? NSDictionary {
                    if let messageStr = json.object(forKey: kMessage) as? String {
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
        
    }
    //MARK: - TNM Error Alert -
    func TNMErrorMessage(_ title : String, message : String){
        var titleStr = title
        if titleStr.isEmpty == true {
            titleStr = kAppName
        }
        
        let refreshAlert = UIAlertController(title: titleStr, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        //
        //        }))
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async {
                if self.delegate != nil {
                    self.delegate?.reloadDisscutionData()
                }
                self.navigationController?.popFadeViewController()
                
            }

        }))
        
        DispatchQueue.main.async {
            self.present(refreshAlert, animated: true, completion: { () -> Void in
                
            })
            
        }
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Discussion"
    }
    
    func PostComplain(){
        
        print(txtDiscussion.text)
        print(textview.text)
    }
    
    // MARK: - Keyboard Event -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        self.view.endEditing(true)
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
