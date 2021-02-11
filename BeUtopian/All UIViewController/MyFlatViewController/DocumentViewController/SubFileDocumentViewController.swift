//
//  SubFileDocumentViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 02/04/17.
//  Copyright © 2017 tnmmac4. All rights reserved.
//

import UIKit

class SubFileDocumentViewController: UIViewController, MLKMenuPopoverDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DocumentCellDelegate,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var tableView : UITableView!
    var ComplainsCells = NSMutableArray()
    @IBOutlet var btnAdd: UIButton!
    
    var FolderID : String = ""
    var SubFolderID : String = ""
    
    var imagePicker = UIImagePickerController()
    var strfileUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nibName = UINib(nibName: "DocumentCell", bundle: nil)
        self.tableView .register(nibName, forCellReuseIdentifier: "DocumentCell")
        
       // self.perform("GetNoticeBoard:", with: self.FolderID, afterDelay: 0.2)
        self.GetNoticeBoard(self.FolderID)
        DispatchQueue.main.async {
            self.imagePicker.delegate = self
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    @IBAction func BtnAddFolderClick(_ sender: AnyObject){
        
        let menuPopover: MLKMenuPopover = MLKMenuPopover(frame: CGRect(x: btnAdd.frame.origin.x - 80, y: btnAdd.frame.origin.y - 60, width: 130, height: 60), menuItems: ["Add File"])
        menuPopover.backgroundColor = UIColor.darkGray
        menuPopover.menuPopoverDelegate = self
        menuPopover.show(in: self.view)
    }

    func BtnMoreOption(_ cell: DocumentCell) {
        
        let refreshAlert = UIAlertController(title: "Action", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            
            if let strTemp = cell.data!.object(forKey: "subfolderID") as? String {
                self.FolderDeleteAlertView(strTemp)
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Download", style: .default, handler: { (action: UIAlertAction!) in
            
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
            
        }))
        
        self.navigationController?.present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK: - DropDown Delegate
    
    func menuPopover(_ menuPopover: MLKMenuPopover!, didSelectMenuItemAt selectedIndex: Int) {
        
                   
                   let refreshAlert = UIAlertController(title: "Select File", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                   
                   refreshAlert.addAction(UIAlertAction(title: "Take pictrure using Camera", style: .default, handler: { (action: UIAlertAction!) in
                       
                       if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
                        
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
    
    //MARK:- CreateCell
    
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
                    if let tempStr = tempData.object(forKey: "URL") as? String {
                        if(tempStr != ""){
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
                    
                }
                else{
                    if let tempStr = cell.data?.object(forKey: "URL") as? String {
                        appDelegate.DownloadImageFromUrl(tempStr)
                    }
                }
            }
        }
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

    //MARK: - API Delegate -
    
    func GetNoticeBoard(_ folderID : String)
    {

        
        let urlStr = String(format: "%@?view=documents&page=sublist&userID=%@&societyID=%@&folderID=%@&subfolderID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,folderID, SubFolderID])

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
                                
                                self.perform("GetNoticeBoard:", with: self.FolderID, afterDelay: 0.2)
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
