//
//  DeclineCommentVC.swift
//  BeUtopian
//
//  Created by desap on 15/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit
protocol DeclineCommentDelegate {
    func DeclineCommentSuccess()
}
class DeclineCommentVC: UIViewController {

    var delegate : DeclineCommentDelegate?
    
    @IBOutlet var texcommnet: UITextView!
    var strTitle: String?
    
    var PurchaseOrderData : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        texcommnet.becomeFirstResponder()
        
        texcommnet.text = "Please leave a comment..."
        texcommnet.textColor = UIColor.lightGray
        
        let newPosition = texcommnet.beginningOfDocument
        texcommnet.selectedTextRange = texcommnet.textRange(from: newPosition, to: newPosition)
        
        addDoneButtonOnKeyboard()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(strTitle == ""){
            self.navigationItem.title = "Comment"
        }
        else{
            self.navigationItem.title = strTitle
        }
      
        
        let right = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .plain, target: self, action: #selector(DeclineCommentVC.CloseClick))
        self.navigationItem.rightBarButtonItem = right
        
        appDelegate.SetNavigationBar(self.navigationController!)
    }
    
    @objc func PostClick(){
        
        texcommnet.resignFirstResponder()
        if let tempStr = texcommnet.text {
            if tempStr.isEmpty == true {
                appDelegate.TNMErrorMessage("", message: "Please enter comment.")
            }else{
                self.DeclinePurchaseOrder()
            }
        }
        
    }
    func DeclinePurchaseOrder(){
        
        var releaseNumber = "0"
        if let data = self.PurchaseOrderData {
            if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                releaseNumber = tempStr.stringValue
            }
            
        }
        
        if let textStr = texcommnet?.text {
            if textStr.isEmpty == false {
                let urlStr = String(format: "%@/api/%@/PurchasingSystem/DeclinePurchaseOrder?companyID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,appDelegate.CompanyID])
                
                let data : NSDictionary = ["ReleaseNumber" : releaseNumber, "Reason":textStr,"EmployeeID" : appDelegate.EmployeeID, "decline":"decline"]
                print(data)
                
                TNMWSMethod(data as? Dictionary<String, String> as AnyObject, url: urlStr, isMethod: kPostMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
                    if succeeded == true {
                        print(data)
                        self.DeclineSuccess()
                        
                    }else{
                        if let json = data as? NSDictionary {
                            if let messageStr = json.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                        }
                        
                    }
                }
            }
        }
        

    }
    func DeclineSuccess(){
        let alert=UIAlertController(title: "Declined", message: "Purchase order has been declined", preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
            self.dismiss(animated: true, completion: { () -> Void in
                if self.delegate != nil {
                    self.delegate?.DeclineCommentSuccess()
                }
                
            })
//            self.performSelector("GetPurchaseOrderHeaders")
            
        }));
        DispatchQueue.main.async
            {
            self.present(alert, animated: true, completion: nil);
        }
        
    }

    @objc func CloseClick(){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        if textView.textColor == UIColor.lightGrayColor() {
//            textView.text = nil
//            textView.textColor = UIColor.darkGrayColor()
//        }
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please leave a comment..."
            textView.textColor = UIColor.lightGray
        }
    }
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        let newPosition = texcommnet.beginningOfDocument
//        texcommnet.selectedTextRange = texcommnet.textRangeFromPosition(newPosition, toPosition: newPosition)
//    }
//    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        let newPosition = texcommnet.beginningOfDocument
//        texcommnet.selectedTextRange = texcommnet.textRangeFromPosition(newPosition, toPosition: newPosition)
//        return true
//    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"
//        {
//            textView.resignFirstResponder()
//            
//            let alert=UIAlertController(title: "Declined", message: "Order has been declined", preferredStyle: UIAlertControllerStyle.Alert);
//            
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil));
//            
//            //        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction) in
//            //        }));
//            
//            presentViewController(alert, animated: true, completion: nil);
//            
//            return false
//        }
        
        let currentText:NSString = textView.text as! NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {        
            
            textView.text = "Please leave a comment..."
            textView.textColor = UIColor.lightGray
            
            let newPosition = texcommnet.beginningOfDocument
            texcommnet.selectedTextRange = texcommnet.textRange(from: newPosition, to: newPosition)

            
//            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }


    //MARK: - SetKeyBoard Done Button
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(DeclineCommentVC.doneButtonAction))
        
        let done: UIBarButtonItem = UIBarButtonItem(title: "Decline", style: UIBarButtonItem.Style.done, target: self, action: #selector(DeclineCommentVC.PostClick))
        
        doneToolbar.items = [cancel,flexSpace, done]
        doneToolbar.sizeToFit()
        
        self.texcommnet.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.texcommnet.resignFirstResponder()
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
