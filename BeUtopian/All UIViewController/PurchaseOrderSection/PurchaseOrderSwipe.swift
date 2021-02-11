//
//  PurchaseOrderVC.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//

import UIKit

protocol PurchaseOrderDelegate{
    func DidReloadPurchaseOrder()
}

class PurchaseOrderSwipe: UIViewController, SMSwipeableTabViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate, CarbonTabSwipeNavigationDelegate, HPGrowingTextViewDelegate, DeclineCommentDelegate {

    var delegate : PurchaseOrderDelegate?
    
    let customize = true
    let showImageOnButton = false
    let titleBarDataSource = ["Details", "Order lines", "Audit Trail"]
    let swipeableView = SMSwipeableTabViewController()
    @IBOutlet var views: UIView!
    var isApproval: String?
    var right: UIBarButtonItem?
    var objPurchaseOrderDetails = PurchaseOrderDetails()
    var objPurchaseOrderLines = PurchaseOrderLines()
    var objPurchaseOrderAuditTrail = PurchaseOrderAuditTrail()
    

    var PurchaseOrderData : NSDictionary?
    
    
   @IBOutlet var containerView: UIView?
   @IBOutlet var textView: HPGrowingTextView?
    @IBOutlet var btnpost: UIButton!
    
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseOrderSwipe.onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(PurchaseOrderSwipe.onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        /* Old Conditional Code
        if let data = self.PurchaseOrderData {
            if let isApproved = data.objectForKey("IsApproved") as? NSNumber {
                if isApproved == 1 {
                    self.views.hidden = true
                }else {
                    if let isApproved = data.objectForKey("IsDeclined") as? NSNumber {
                        if isApproved == 1 {
                            self.views.hidden = true
                        }
                    }
                }
            }
            
        }
        */
        //New Conditional Code
        if(self.isApproval == "Approved"){
            self.views.isHidden = true
        }

        
        //SetKeyboard()
        
        SetKeyboard()
        
        SetSwipeBar()
        
        
//        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: titleBarDataSource as [AnyObject], delegate: self)
//        carbonTabSwipeNavigation.insertIntoRootViewController(self)
////        carbonTabSwipeNavigation.view.frame = UIScreen.mainScreen().bounds
//        
//        self.style()
        
        // Do any additional setup after loading the view.
    }
    
    func style() {
        let color: UIColor = UIColor(hexString: "414141")
        self.navigationController!.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.barTintColor = color
        self.navigationController!.navigationBar.barStyle = .blackTranslucent
        
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(UIColor(hexString: "00AC44"))
        carbonTabSwipeNavigation.setTabExtraWidth(23)
//        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(125, forSegmentAtIndex: 0)
//         carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(125, forSegmentAtIndex: 1)
//         carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(125, forSegmentAtIndex: 2)
        
        carbonTabSwipeNavigation.setNormalColor(UIColor(hexString: "AFAFAF").withAlphaComponent(1.0))
        carbonTabSwipeNavigation.setSelectedColor(color, font: UIFont(name: ".SFUIText-Medium", size: 15.0)!)
        
        let screenSize = UIScreen.main.bounds
        let widthOfScreen : CGFloat = screenSize.width / 3
        
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(widthOfScreen, forSegmentAt: 0)
        
//        carbonTabSwipeNavigation.setTabExtraWidth(widthOfScreen)
        
        self.view.addSubview(views)
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        switch index {
        case 0:
            
            objPurchaseOrderDetails.isApproval = isApproval
            self.navigationItem.rightBarButtonItem = nil
            if let data = self.PurchaseOrderData {
                if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                    objPurchaseOrderDetails.releaseNumber = tempStr.stringValue
                }
                objPurchaseOrderDetails.PurchaseOrderData = data
            }
            return objPurchaseOrderDetails
        case 1:
            self.navigationItem.rightBarButtonItem = nil
            objPurchaseOrderLines.isApproval = isApproval
            if let data = self.PurchaseOrderData {
                if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                    objPurchaseOrderLines.releaseNumber = tempStr.stringValue
                }
                
            }
            return objPurchaseOrderLines
        default:
            if let data = self.PurchaseOrderData {
                if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                    objPurchaseOrderAuditTrail.releaseNumber = tempStr.stringValue
                }
                
            }
            objPurchaseOrderAuditTrail.isApproval = isApproval
            return objPurchaseOrderAuditTrail

        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NSLog("Did move at index: %ld", index)
        
        if(index == 2){
            let right = UIBarButtonItem(image: UIImage(named: "comment_icon"), style: .plain, target: self, action: #selector(PurchaseOrderSwipe.CommentClick))
            self.navigationItem.rightBarButtonItem = right
        }
        else{
            self.navigationItem.rightBarButtonItem = nil
        }
        

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Purchase Order"
        
        let left = UIBarButtonItem(image: UIImage(named: "Back_button"), style: .plain, target: self, action: #selector(PurchaseOrderSwipe.BackClick))
        self.navigationItem.leftBarButtonItem = left
        
        appDelegate.SetNavigationBar(self.navigationController!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    
    @objc func BackClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func SetSwipeBar(){
        
        let frame = UIScreen.main.bounds
        self.view.frame = frame
        
        swipeableView.titleBarDataSource = titleBarDataSource
        swipeableView.delegate = self
        swipeableView.viewFrame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        
        if customize {
            swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.white]
            swipeableView.selectionBarAttributes = [
                SMBackgroundColorAttribute : NSTheme().GetGreenColor(),
                SMAlphaAttribute : 0.8 as AnyObject
            ]
            if (!showImageOnButton) {
                swipeableView.buttonAttributes = [
                    SMBackgroundColorAttribute : UIColor.clear,
                    SMAlphaAttribute : 0.8 as AnyObject,
                    SMFontAttribute : UIFont(name: ".SFUIText-Medium", size: 15.0)!,
                    SMForegroundColorAttribute : UIColor(hexString: "414141")
                ]
                swipeableView.selectionBarHeight = 3.0 //For thin line
                swipeableView.segementBarHeight = 50.0 //Default is 44.0
                swipeableView.buttonPadding = 10.0 //Default is 8.0
               // swipeableView.buttonWidth = 85.0
                
                let screenSize = UIScreen.main.bounds
                let widthOfScreen : CGFloat = screenSize.width / 3
                
                swipeableView.buttonWidth = widthOfScreen - swipeableView.buttonPadding * 2

            }
            else {
                swipeableView.buttonAttributes = [
                    SMBackgroundColorAttribute : UIColor.red,
                    SMAlphaAttribute : 0.8 as AnyObject,
                    SMButtonHideTitleAttribute : true as AnyObject,
                    SMButtonNormalImagesAttribute : ["ic_call_made", "ic_call_missed", "ic_call_received", "ic_chat" , "ic_contacts"] as [String] as AnyObject,
                    SMButtonHighlightedImagesAttribute : ["ic_call_made", "ic_call_missed", "ic_call_received", "ic_chat" , "ic_contacts"] as [String] as AnyObject
                ]
                swipeableView.selectionBarHeight = 3.0 //For thin line
                swipeableView.segementBarHeight = 40.0 //Default is 44.0
                swipeableView.buttonPadding = 10.0 //Default is 8.0
                swipeableView.buttonWidth = 50.0
            }
        }
        
        self.addChild(swipeableView)
        
        
        swipeableView.view.addSubview(views)
        swipeableView.view.addSubview(containerView!)
        
        self.view.addSubview(swipeableView.view)
        swipeableView.didMove(toParent: self)
    }
    
    //MARK: SMSwipeableTabViewController Delegate CallBack
    
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController {
        
        self.view.endEditing(true)
        
        switch index {
        case 0:
            
            objPurchaseOrderDetails.isApproval = isApproval
            self.navigationItem.rightBarButtonItem = nil
            if let data = self.PurchaseOrderData {
                if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                    objPurchaseOrderDetails.releaseNumber = tempStr.stringValue
                }
                objPurchaseOrderDetails.PurchaseOrderData = data
            }
            return objPurchaseOrderDetails
        case 1:
            self.navigationItem.rightBarButtonItem = nil
            objPurchaseOrderLines.isApproval = isApproval
            if let data = self.PurchaseOrderData {
                if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                    objPurchaseOrderLines.releaseNumber = tempStr.stringValue
                }
                
            }
            return objPurchaseOrderLines
        default:
            
            let right = UIBarButtonItem(image: UIImage(named: "comment_icon"), style: .plain, target: self, action: #selector(PurchaseOrderSwipe.CommentClick))
            self.navigationItem.rightBarButtonItem = right
            if let data = self.PurchaseOrderData {
                if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                    objPurchaseOrderAuditTrail.releaseNumber = tempStr.stringValue
                }
                
                
            }
            objPurchaseOrderAuditTrail.isApproval = isApproval
            return objPurchaseOrderAuditTrail
        }
    }
    
    
    //MARK: - Button Click Event
    
    @IBAction func BtnApproveClick(_ sender: AnyObject) {
        
        self.ApprovePurchaseOrder()
    }
    
    func ApprovePurchaseOrder(){
        
        var releaseNumber = "0"
        if let data = self.PurchaseOrderData {
            if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                releaseNumber = tempStr.stringValue
            }
            
        }
                
        let urlStr = String(format: "%@/api/%@/PurchasingSystem/ApprovePurchaseOrder?companyID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,appDelegate.CompanyID])
        
        let data = ["ReleaseNumber" : releaseNumber,"EmployeeID" : appDelegate.EmployeeID]
        print(data)
        
        TNMWSMethod(data as AnyObject, url: urlStr, isMethod: kPostMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                if let tempData = data as? NSDictionary {
                    self.ApprovedSuccess(tempData)
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
    func DeclineCommentSuccess() {
        self.navigationController?.popViewController(animated: true)
        if self.delegate != nil {
            self.delegate?.DidReloadPurchaseOrder()
        }
    }
    func ApprovedSuccess(_ data : NSDictionary){
        var messageStr = "Purchase order has been approved"
        
        if let tempStr = data.object(forKey: "Status") as? String {
            if tempStr.caseInsensitiveCompare("FULLY_APPROVED") == .orderedSame {
                messageStr = "Purchase order has been approved"
            }else{
                //Get Fiendly name
                if let employeeData = data.object(forKey: "Employee") as? NSDictionary {
                    if let nameStr = employeeData.object(forKey: "FriendlyName") as? String {
                        if nameStr.isEmpty == false {
                            messageStr = String(format: "Purchase Order exceeds your limit, forwarded to %@", arguments: [nameStr.capitalized])
                        }
                    }
                }
            }
        }
        let alert=UIAlertController(title: "Approved", message: messageStr, preferredStyle: UIAlertController.Style.alert);
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
            if self.delegate != nil {
                self.delegate?.DidReloadPurchaseOrder()
            }
            
        }));
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil);
        }
        
    }
    
    @IBAction func BtnDeclinedClick(_ sender: AnyObject) {

        let objRoot: DeclineCommentVC = DeclineCommentVC(nibName: "DeclineCommentVC", bundle: nil)
        objRoot.delegate = self
        objRoot.strTitle = "Purchase Order"
        if let data = self.PurchaseOrderData {
            objRoot.PurchaseOrderData = data
        }
        let navigate = UINavigationController(rootViewController: objRoot)
        self.navigationController?.present(navigate, animated: true, completion: nil)
    }
    
    //MARK: SetKeyboard
    
    @objc func CommentClick(){
        textView?.becomeFirstResponder()
        textView?.text = ""
    }
    
    @IBAction func CommentPostClicl(_ sender: AnyObject){
        
        self.view.endEditing(true)
       
        
        print(textView?.text ?? "<#default value#>")
        var releaseNumber = "0"
        if let data = self.PurchaseOrderData {
            if let tempStr = data.object(forKey: "ReleaseNumber") as? NSNumber {
                releaseNumber = tempStr.stringValue
            }
            
        }
        
        let statusStr : String = "null"
        if let textStr = textView?.text {
            if textStr.isEmpty == false {
                let urlStr = String(format: "%@/api/%@/PurchasingSystem/InsertAuditDetailsByReleaseNumber?companyID=%@", arguments: [kMainDomainUrl,appDelegate.ClientTag,appDelegate.CompanyID])
                print(urlStr)
                let data : NSDictionary = ["ReleaseNumber" : releaseNumber, "Details" : textStr, "OldStatus" : statusStr, "NewStatus" : statusStr,"EmployeeID" : appDelegate.EmployeeID]
                print(data)
                TNMWSMethod(data as? Dictionary<String, String> as AnyObject, url: urlStr, isMethod: kPostMethod, AuthToken: appDelegate.AuthToken, viewController: self) { (succeeded, data) -> () in
                    if succeeded == true {
                        print(data)
                        
                        let alert=UIAlertController(title: "Comment", message: "Message posted successfully", preferredStyle: UIAlertController.Style.alert);
                        
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
                            DispatchQueue.main.async {
                                self.objPurchaseOrderAuditTrail.GetPurchaseOrderAuditDetails(true)
                            }
                            
                        }));
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil);
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
        }
               
    }
    
    func SetKeyboard(){
        
//        containerView = UIView(frame: CGRectMake(0, self.view.frame.size.height - 40, 320, 40))
//        textView = HPGrowingTextView(frame: CGRectMake(6, 3, 240, 40))
        textView!.isScrollable = false
        textView!.contentInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        textView!.minNumberOfLines = 1
        textView!.maxNumberOfLines = 6
        
        // you can also set the maximum height in points with maxHeight
        // textView.maxHeight = 200.0f;
        //just as an example
        textView!.font = UIFont.systemFont(ofSize: 15.0)
        textView!.delegate = self
        textView!.internalTextView.scrollIndicatorInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: 5, right: 0)
        textView!.placeholder = "Comment"
        textView?.layer.cornerRadius = 2
        textView?.layer.borderColor = UIColor.lightGray.cgColor
        textView?.layer.borderWidth = 1
        
        btnpost.layer.cornerRadius = 4
        
        
        // textView.text = @"test\n\ntest";
        // textView.animateHeightChange = NO; //turns off animation
//        self.view.addSubview(containerView!)
        containerView?.addSubview(textView!)
 
        containerView!.autoresizingMask = [.flexibleWidth , .flexibleTopMargin]

    }
    
    func resignTextView(){
        textView?.resignFirstResponder()
    }
    
    @objc func onKeyboardHide(_ notification: Notification)
    {
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
        let duration = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            
            var containerFrame = self.containerView!.frame
            containerFrame.origin.y = self.swipeableView.view.bounds.size.height + containerFrame.size.height
            self.containerView!.frame = containerFrame
            // commit animations
        })
    }
    @objc func onKeyboardShow(_ notification: Notification)
    {
        // var keyboardBounds = CGRect.zero
        let userInfo : NSDictionary = notification.userInfo! as NSDictionary
       // let kbMain  = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue
        
        let duration  = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as! Double;
        UIView.animate(withDuration: duration, animations: { () -> Void in
            
            guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height else {
                return
            }
            
//            keyboardBounds = self.swipeableView.view.convertRect(keyboardBounds, toView: nil)
            var containerFrame = self.containerView!.frame
            containerFrame.origin.y = self.swipeableView.view.bounds.size.height - (keyboardHeight + containerFrame.size.height)
            self.containerView!.frame = containerFrame
            
        })

    }
    
    func growingTextView(_ growingTextView: HPGrowingTextView!, willChangeHeight height: Float) {
        
        let diff: CGFloat = (growingTextView.frame.size.height - CGFloat(height))
        var r = containerView!.frame
        r.size.height -= diff
        r.origin.y += diff
        containerView!.frame = r
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
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
