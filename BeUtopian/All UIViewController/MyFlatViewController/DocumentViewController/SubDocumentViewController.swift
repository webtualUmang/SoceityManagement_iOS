//
//  DocumentViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 18/03/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit
import AssetsLibrary

class SubDocumentViewController: UIViewController, DocumentCellDelegate, BSKeyboardControlsDelegate, MLKMenuPopoverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    var FolderID : String = ""
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet var txtFolder: UITextField!
    @IBOutlet var btnPrivate: UIButton!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var btnAdd: UIButton!
    var strPrivate: String?
    var subfolderID: String?
    
    //Popup
    @IBOutlet var MemberView: UIView!
    @IBOutlet var lbltitle: UILabel!
    var popup: KOPopupView?
    
    var keyboard: BSKeyboardControls!
    var imagePicker = UIImagePickerController()
    var strfileUrl: URL?
    var cameraBool: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "DocumentCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "DocumentCell")
        self.perform(#selector(SubDocumentViewController.GetNoticeBoard(_:)), with: self.FolderID, afterDelay: 0.2)
        
        btnPrivate.set(image: UIImage(named: "uncheckbox"), title: "Make A Private", titlePosition: .right, additionalSpacing: 20, state: UIControl.State())
        strPrivate = "No"
        
        
        keyboard = BSKeyboardControls(fields: [txtFolder])
        keyboard.delegate = self
        
        DispatchQueue.main.async { 
            self.imagePicker.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func BtnAddFolderClick(_ sender: AnyObject){
        
        let menuPopover: MLKMenuPopover = MLKMenuPopover(frame: CGRect(x: btnAdd.frame.origin.x - 80, y: btnAdd.frame.origin.y - 100, width: 130, height: 100), menuItems: ["Add Folder", "Add File"])
        menuPopover.backgroundColor = UIColor.darkGray
        menuPopover.menuPopoverDelegate = self
        menuPopover.show(in: self.view)
        
    }
    
    @IBAction func BtnMakePrivateClick(_ sender: AnyObject){
        
        if(btnPrivate.imageView?.image == UIImage(named: "uncheckbox")){
            btnPrivate.set(image: UIImage(named: "check_box_blue"), title: "Make A Private", titlePosition: .right, additionalSpacing: 20, state: UIControl.State())
            strPrivate = "Yes"
        }
        else{
            btnPrivate.set(image: UIImage(named: "uncheckbox"), title: "Make A Private", titlePosition: .right, additionalSpacing: 20, state: UIControl.State())
            strPrivate = "No"
        }
    }
    
    @IBAction func BtnCreateFolderClick(_ sender: AnyObject){
        
        if(txtFolder.text == ""){
            appDelegate.TNMErrorMessage("", message: "Please enter folder name")
            return
        }
        
        if(btnCreate.titleLabel?.text == "Rename"){
            self.RenameFolder()
        }
        else{
            CreateFolder()
        }
        self.popup?.hide(animated: true)
    }
    
    @IBAction func BtnCloseViewClick(_ sender: AnyObject){
        popup?.hide(animated: true)
    }
    
    func BtnMoreOption(_ cell: DocumentCell) {
        
        let refreshAlert = UIAlertController(title: "Action", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (action: UIAlertAction!) in
            
            self.OpenRegardPopups(cell.data!)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            
            if let strTemp = cell.data!.object(forKey: "subfolderID") as? String {
                self.FolderDeleteAlertView(strTemp)
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        self.navigationController?.present(refreshAlert, animated: true, completion: nil)
    }
    
    func FolderDeleteAlertView(_ sunfolderid: String){
        
        let refreshAlert = UIAlertController(title: "Are you sure want to delete this item ?", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            self.DeleteFolder(sunfolderid)
            
        }))
        
        self.navigationController?.present(refreshAlert, animated: true, completion: nil)
    }
    
    func OpenRegardPopups(_ data: NSDictionary){
        
        if (popup == nil) {
            popup = KOPopupView()
        }
        
        let frames = UIScreen.main.bounds.size
        
        if(frames.width == 320){
            popup?.frame.origin.y -= 50
        }
        
        
        lbltitle.text = "Rename Folder"
        btnCreate.setTitle("Rename", for: .normal)
        
        
        if let strTemp = data.object(forKey: "name") as? String {
            txtFolder.text = strTemp
        }
        
        if let strTemp = data.object(forKey: "subfolderID") as? String {
            subfolderID = strTemp
        }
        
        if let strTemp = data.object(forKey: "personal") as? String {
            
            if(strTemp.lowercased() == "no"){
                btnPrivate.set(image: UIImage(named: "uncheckbox"), title: "Make A Private", titlePosition: .right, additionalSpacing: 20, state: UIControl.State())
                strPrivate = "No"
            }
            else{
                btnPrivate.set(image: UIImage(named: "check_box_blue"), title: "Make A Private", titlePosition: .right, additionalSpacing: 20, state: UIControl.State())
                strPrivate = "Yes"
            }
        }
        
        popup?.handleView.addSubview(MemberView)
        
        MemberView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                    y: self.popup!.handleView.frame.size.height/2.0)
        popup?.show()
    }
    
    //MARK: - DropDown Delegate
    
    func menuPopover(_ menuPopover: MLKMenuPopover!, didSelectMenuItemAt selectedIndex: Int) {
        
        if(selectedIndex == 0){
            
            lbltitle.text = "Manage Folder"
            btnCreate.setTitle("Create", for: UIControl.State())
            
            if (popup == nil) {
                popup = KOPopupView()
            }
            
            let frames = UIScreen.main.bounds.size
            
            if(frames.width == 320){
                popup?.frame.origin.y -= 50
            }
            popup?.handleView.addSubview(MemberView)
            
            MemberView.center = CGPoint(x: self.popup!.handleView.frame.size.width/2.0,
                                        y: self.popup!.handleView.frame.size.height/2.0)
            popup?.show()
        }
        else if(selectedIndex == 1)
        {
            
            let refreshAlert = UIAlertController(title: "Select File", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            refreshAlert.addAction(UIAlertAction(title: "Take pictrure using Camera", style: .default, handler: { (action: UIAlertAction!) in
                
                if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                    self.cameraBool = true
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    let alert = UIAlertView(title: "No Camera", message: "Sorry, this device has no camera", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
                }
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { (action: UIAlertAction!) in
                
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            self.navigationController?.present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    func CreateCell(_ resultList : NSArray){
        
        ComplainsCells = NSMutableArray()
        for data in resultList {
            if let tempData = data as? NSDictionary {
                if let cell = self.self.tableView.dequeueReusableCell(withIdentifier: "DocumentCell") as? DocumentCell {
                    cell.data = tempData
                    cell.delegate = self
                    cell.btnMore.isHidden = false
                    if let tempStr = tempData.object(forKey: "name") as? String {
                        cell.lblName.text = tempStr
                    }
                    if let tempStr = tempData.object(forKey: "added_on") as? String {
                        cell.lblDetails.text = tempStr
                    }
                    
                    if let tempStr = tempData.object(forKey: "URL") as? String
                    {
                        if(tempStr != "")
                        {
                            cell.userImage.image = UIImage(named: "jpg")
                        }
                    }
                    
                    self.ComplainsCells.add(cell)
                }
                
            }
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
        
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? DocumentCell {
                return cell.frame.size.height
            }
        }
        
        
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ComplainsCells.count > indexPath.row {
            if let cell = ComplainsCells.object(at: indexPath.row) as? DocumentCell {
                return cell
            }
        }
        
        
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? DocumentCell {
            
            if let tempStr = cell.data?.object(forKey: "folderID") as? String {
                
                if(tempStr != ""){
                    
                    // let objRoot: SubFileDocumentViewController = SubFileDocumentViewController(nibName: "SubFileDocumentViewController", bundle: nil)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let objRoot:SubFileDocumentViewController = storyboard.instantiateViewController(withIdentifier: "SubFileDocumentViewController") as! SubFileDocumentViewController
                    objRoot.FolderID = tempStr
                    
                    if let tempStr = cell.data?.object(forKey: "name") as? String {
                        objRoot.navigationItem.title = tempStr
                    }
                    
                    if let tempStr = cell.data?.object(forKey: "subfolderID") as? String {
                        objRoot.SubFolderID = tempStr
                    }
                    self.navigationController?.pushViewController(objRoot, animated: true)
                }
                else{
                    if let tempStr = cell.data?.object(forKey: "URL") as? String {
                        appDelegate.DownloadImageFromUrl(tempStr)
                    }
                }
            }
            
        }
        
    }
    
    //MARK: - API Delegate -
    
    @objc func GetNoticeBoard(_ folderID : String)
    {
        
        let urlStr = String(format: "%@?view=documents&page=sublist&userID=%@&societyID=%@&folderID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,folderID])
        //        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"49", "1","0"])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "subfolder_list") as? NSArray {
                                DispatchQueue.main.async {
                                    
                                    self.CreateCell(bannerList)
                                }
                                
                                
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
    
    //MARK: - AddFile
    
    func AddFile()
    {
        
        
        
        
        let urlStr = String(format: "%@", arguments: [kMainDomainUrl])
        
        
        let requestBody = ["userID":appDelegate.LoginUserID,"societyID":appDelegate.SocietyID,"folderID":FolderID, "subfolderID":"0","view":"add_file","page":"add"] as [String : Any]
        
        // http://sms.thewebtual.com/mapp/index.php?view=profile&page=user_update
        let requestUrl = urlStr.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let imageArray = NSMutableArray()
        
        var imagedata = Data();
        
        imagedata = self.imgView.image!.jpegData(compressionQuality: 0.5) ?? Data()
//        imagedata =  self.imgView.image?.jpegData(compressionQuality: 0.5) ?? Data()
            imageArray.add(imagedata)
        
        
        self.JsonAdsPostImageRequest(APINAME:requestUrl, ParamDict:requestBody as NSDictionary, ImageData:imageArray,key:"uploaded_file",view:self, completion:
            {
                
                result in
                print(result)
                if result["msgcode"]  as? String ?? "1" == "0"
                {
                   
                            self.GetNoticeBoard(self.FolderID)
                }
                else
                {
                    if let message = result.object(forKey: "message") as? String
                    {
                        self.TNMErrorMessage("", message: message)
                    }
                }
                
        })
        
        
    }
    func TNMErrorMessage(_ title : String, message : String)
    {
        var titleStr = title
        if titleStr.isEmpty == true {
            titleStr = kAppName
        }
        
        let refreshAlert = UIAlertController(title: titleStr, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        //
        //        }))
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            DispatchQueue.main.async
                {
                    //                if self.delegate != nil {
                    //                    self.delegate?.reloadDisscutionData()
                    //                }
                    
                    
            }
            
        }))
        
        DispatchQueue.main.async {
            self.present(refreshAlert, animated: true, completion: { () -> Void in
                
            })
            
        }
        
    }
    //MARK: - AddFolder
    
    func CreateFolder(){
        
        
        let urlStr = String(format: "%@?view=documents&page=create_folder&userID=%@&societyID=%@&folderID=%@&folder_name=%@&private=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,FolderID,txtFolder.text!, strPrivate!])
        
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            DispatchQueue.main.async {
                                self.perform(#selector(SubDocumentViewController.GetNoticeBoard(_:)), with: self.FolderID, afterDelay: 0.2)
                            }
                            
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
    
    //MARK: - Rename Folder
    
    func RenameFolder(){
        
        
        let urlStr = String(format: "%@?view=documents&page=update_folder&userID=%@&societyID=%@&folderID=%@&subfolderID=%@&folder_name=%@&private=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,FolderID,subfolderID!,txtFolder.text!,strPrivate!])
        //        let urlStr = String(format: "%@?view=neighbour&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,"49", "1","0"])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.perform(#selector(SubDocumentViewController.GetNoticeBoard(_:)), with: self.FolderID, afterDelay: 0.2)
                            }
                        }
                        else{
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
    
    //MARK: - Delete Folder
    
    func DeleteFolder(_ subfolderId: String){
        
        
        let urlStr = String(format: "%@?view=documents&page=delete_folder&userID=%@&societyID=%@&folderID=%@&subfolderID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,FolderID,subfolderId])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
                            }
                            
                            DispatchQueue.main.async {
                                
                                self.perform(#selector(SubDocumentViewController.GetNoticeBoard(_:)), with: self.FolderID, afterDelay: 0.2)
                            }
                        }
                        else{
                            if let messageStr = ResultData.object(forKey: kMessage) as? String {
                                appDelegate.TNMErrorMessage("", message: messageStr)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboard.activeField = textField
        
        //        let searchTerm = "hihell.df/"
    }
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection) {
        //        self.tableView.scrollRectToVisible(field.frame, animated: true)
    }
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls) {
        view.endEditing(true)
        txtFolder.resignFirstResponder()
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            self.imgView.image = pickedImage
            self.AddFile()
        }
        dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//
//        if let pickedImage = info[.originalImage] as? UIImage
//        {
//            self.imgView.image = pickedImage
//            self.AddFile()
//            // imageView.contentMode = .ScaleAspectFit
//
//            //            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
//            //            let imageName = imageURL.lastPathComponent
//            //            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
//            //            let localPath = documentDirectory.stringByAppendingString(imageName!)
//
//            //            strfileUrl = NSURL(fileURLWithPath: localPath)
//            //
//            //            if(strfileUrl != nil){
//            //                AddFile()
//            //            }
//
//
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
