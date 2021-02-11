//
//  ComplainAddViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 13/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

//discussion
//compile
//help&photo

import UIKit
protocol AddFacilityDelegate
{
    func ReloadFacilityResult()
   
}
class FacilityAddViewController: UIViewController,   BSKeyboardControlsDelegate,RegardingPopupDelegate,UIActionSheetDelegate {
    @IBOutlet var tablewview : UITableView!
    @IBOutlet var headerView : UIView!
    var delegate : AddFacilityDelegate?
    
   var datePicker : UIDatePicker = UIDatePicker()
    
    @IBOutlet var txtDescription: UITextField!
    var keyboard: BSKeyboardControls!
   
    @IBOutlet var lblFromDate : UILabel!
    @IBOutlet var lblFromTime : UILabel!
    
    @IBOutlet var lblToDate : UILabel!
    @IBOutlet var lblToTime : UILabel!
    var facility_list = NSArray()
    
    @IBOutlet var lblFacility : UILabel!
    
    var popup: KOPopupView?
    
    var facilityID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.tablewview.tableHeaderView = self.headerView
            self.LoadDefaultDateAndTime()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(FacilityAddViewController.onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(FacilityAddViewController.onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        // Do any additional setup after loading the view.
//        let rightbtn = UIBarButtonItem(title: "POST", style: .Plain, target: self, action: "AddFacility")
//        
//        self.navigationItem.rightBarButtonItem = rightbtn
        
      
        
        keyboard = BSKeyboardControls(fields: [txtDescription])
        keyboard.delegate = self
        
        self.GetBookinTyp()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Add Facility"
    }
    
    func PostComplain(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- Date Picker -
    @IBAction func PickerClick(_ sender: UIButton) {
        self.CreatePickerTag(sender.tag)
    }
    //MARK: Date Picker
    //--- *** ---//
    
    func CreatePickerTag(_ tag : Int)
    {
        let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        viewDatePicker.backgroundColor = UIColor.clear
        
        
        self.datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        
        if tag == 1 || tag == 3 {
            self.datePicker.datePickerMode = UIDatePicker.Mode.date
            self.datePicker.locale = Locale(identifier: "en_GB")
        }else{
            self.datePicker.datePickerMode = UIDatePicker.Mode.time
            self.datePicker.locale = Locale(identifier: "en_US")
        }
        
        
        //        self.datePicker.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.ValueChanged)
        self.datePicker.addTarget(self, action: #selector(FacilityAddViewController.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        self.datePicker.tag = tag
        
        viewDatePicker.addSubview(self.datePicker)
        var titleStr = "Date"
        if tag == 1 {
            titleStr = "From Date"
        }else if tag == 2 {
            titleStr = "From Time"
        }else if tag == 3 {
            titleStr = "To Date"
        }else if tag == 4 {
            titleStr = "To Time"
        }
        
        let alertController = UIAlertController(title: titleStr, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.view.addSubview(viewDatePicker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            { (action) in
                // ...
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Done", style: .default)
            { (action) in
                
                self.setDate(tag)
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true)
            {
                // ...
        }
        
        
    }
    
    @objc func handleDatePicker(_ sender: UIDatePicker)
    {
        let tag = sender.tag
        let dateFormatter = DateFormatter()
        if tag == 1 {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.lblFromDate.text = dateFormatter.string(from: sender.date)
        }else if tag == 2 {
            dateFormatter.dateFormat = "HH:mm a"
            self.lblFromTime.text = dateFormatter.string(from: sender.date)
        }else if tag == 3 {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.lblToDate.text = dateFormatter.string(from: sender.date)
        }else if tag == 4 {
            dateFormatter.dateFormat = "HH:mm a"
            self.lblToTime.text = dateFormatter.string(from: sender.date)
        }

    }
    func setDate(_ tag : Int)
    {
        let dateFormatter = DateFormatter()
        if tag == 1 {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.lblFromDate.text = dateFormatter.string(from: datePicker.date)
        }else if tag == 2 {
            dateFormatter.dateFormat = "HH:mm a"
            self.lblFromTime.text = dateFormatter.string(from: datePicker.date)
        }else if tag == 3 {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            self.lblToDate.text = dateFormatter.string(from: datePicker.date)
        }else if tag == 4 {
            dateFormatter.dateFormat = "HH:mm a"
            self.lblToTime.text = dateFormatter.string(from: datePicker.date)
        }
       
    }
    func LoadDefaultDateAndTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.lblFromDate.text = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "HH:mm a"
        self.lblFromTime.text = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.lblToDate.text = dateFormatter.string(from: Date())
        
        dateFormatter.dateFormat = "HH:mm a"
        self.lblToTime.text = dateFormatter.string(from: Date())
        
    }

    //MARK:- Regard Popups -
    @IBAction func regardClick(_ sender : UIButton){
        if self.facility_list .count > 0 {
            self.OpenRegardPopups()
        }else{
            self.GetBookinTyp()
        }
        
    }
    func OpenRegardPopups(){
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        let mainFrame = UIScreen.main.bounds
        
        let regardView = CompainRegarding.instanceFromNib()
        regardView.resultKey = "facility_name"
        regardView.resultList = NSArray(array: self.facility_list)
        regardView.CreateCell()
        regardView.delegate = self
        var frmView = regardView.bounds
        frmView.origin.x = 0
        frmView.origin.y = 0
        frmView.size.height = mainFrame.height - 100
        frmView.size.width = mainFrame.width - 60
        regardView.frame = frmView
       
        popup?.handleView.addSubview(regardView)
        
        regardView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
            y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    func SelectRegardOption(_ data: NSDictionary) {
        popup?.hide(animated: true)
        
        if let tempStr = data.object(forKey: "facilityID") as? String {
            self.facilityID = tempStr
        }
        if let tempStr = data.object(forKey: "facility_name") as? String {
            self.lblFacility.text = tempStr
        }
        
    }
    
    // MARK: - Keyboard Event -
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        self.tablewview.scrollRectToVisible(field.frame, animated: true)
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
            self.tablewview.contentInset = edgeInsets
            self.tablewview.scrollIndicatorInsets = edgeInsets
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
            self.tablewview.contentInset = edgeInsets
            self.tablewview.scrollIndicatorInsets = edgeInsets
            if (self.keyboard.activeField) != nil
            {
                self.tablewview.scrollRectToVisible(self.keyboard.activeField!.frame, animated: true)
            }
        })
    }
    
    //MARK:- API Delegate 
    @IBAction func bookClick(_ sender : UIButton){
        self.AddFacility()
    }
    func GetBookinTyp(){
        
     
        let urlStr = String(format: "%@?view=facility&page=facility_list&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
//                            if let message = ResultData.objectForKey("message") as? String {
//                                self.TNMErrorMessage("", message: message)
//                            }
                            if let bannerList = ResultData.object(forKey: "facility_list") as? NSArray {
                                self.facility_list = NSArray(array: bannerList)
                                
                            }
                            
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
    
    
    func AddFacility()
    {

        var fromDate = ""
        
        if let tempStr = self.lblFromDate.text {
            fromDate = tempStr
        }
        var fromTime = ""

        if let tempStr = self.lblFromTime.text {
            fromTime = tempStr
        }
        
        var toDate = ""
        
        if let tempStr = self.lblToDate.text {
            toDate = tempStr
        }
        
        var toTime = ""
        
        if let tempStr = self.lblToTime.text {
            toTime = tempStr
        }
        
        var descption = ""
        
        if let tempStr = self.txtDescription.text {
            descption = tempStr
        }
        
        if self.facilityID.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please select facility")
            return
        }
        if descption.isEmpty == true {
            appDelegate.TNMErrorMessage("", message: "Please enter desption")
            return
        }
        
        let urlStr = String(format: "%@?view=facility&page=add_booking&userID=%@&societyID=%@&facilityID=%@&date_from=%@&time_from=%@&date_to=%@&time_to=%@&description=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,self.facilityID,fromDate,fromTime,toDate,toTime,descption])
        
         let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print(urlStr)
        TNMWSMethod(nil, url: requestUrl!, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let message = ResultData.object(forKey: "message") as? String {
                                self.TNMErrorMessage("", message: message)
                            }
                            
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
//                if self.delegate != nil {
//                    self.delegate?.reloadDisscutionData()
//                }
                self.navigationController?.popFadeViewController()
                if self.delegate != nil {
                    self.delegate?.ReloadFacilityResult()
                }
                
                
            }
            
        }))
        
        DispatchQueue.main.async {
            self.present(refreshAlert, animated: true, completion: { () -> Void in
                
            })
            
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
