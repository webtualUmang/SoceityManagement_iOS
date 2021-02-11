//
//  DeskBoardViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class VendorViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

  
    
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    var menuList : NSArray = NSArray()
    
    var collectionHeader = UICollectionReusableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Vendor"
        // Do any additional setup after loading the view.
//        self.view.frame = UIScreen.mainScreen().bounds
        
        
        let nipName=UINib(nibName: "VendorCell", bundle:nil)
        photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "VendorCell")
     
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.perform("GetVendordMenu")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if ((self.navigationController!.presentingViewController) != nil)
        {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:"dismiss")
        }
        
    }
    func dismiss()
    {
        self.dismiss(animated: true) {
            
        }
    }

    func GetVendordMenu()
    {
        
        let urlStr = String(format: "%@?view=vendor&page=list&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            

            
            if succeeded == true {
                //                print(data)
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "vendorcat_list") as? NSArray {
//                                print(bannerList)
                                self.menuList = NSArray(array: bannerList)
                                
                                DispatchQueue.main.async {
                                    self.calculateCellWidthHeight()
                                   self.photoCollectionView.reloadData()
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
    
    
    // calculate collection view cell width and height based on screen width
    fileprivate func calculateCellWidthHeight() {
        
        // how many photos display in one row
        let numberOfPhotoInRow : CGFloat = 3
        
        // find current screen width
        let screenWidth = self.photoCollectionView.frame.width - 20
        
        // deduct spacing from screen width
        // Formula: screeWidth - leftSpace - ( spaceBetweenThumb * (numberOfPhotoInRow - 1) ) - rightSpace
        let netWidth = screenWidth - 5 - ( 5 * (numberOfPhotoInRow - 1) ) - 5
        
        // calcualte single thumb width
        let thumbWidth = Int( netWidth / numberOfPhotoInRow)
        
        // assign width to class variable
        self.cellWidth = thumbWidth
        self.cellHeight = thumbWidth
    }
    // MARK: - Collection view dataSource
    
   
    
    // number of section in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of photos in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    // return width and height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    // configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get collection view reusable  cell
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VendorCell", for: indexPath) as! VendorCell
        if self.menuList.count > indexPath.row {
            if let data = self.menuList.object(at: indexPath.row) as? NSDictionary {
                
                if let tempStr = data.object(forKey: "icon") as? String {
                    if tempStr.isEmpty == false {
                        let urlString : URL = URL(string: tempStr)!
                        newCell.imgIcons.clipsToBounds = true
                        newCell.imgIcons.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil {
                                newCell.imgIcons.image = image
                            }
                            
                        })
                        
                    }
                }
                
                if let tempStr = data.object(forKey: "name") as? String {
                    newCell.lblTitle.text = tempStr.capitalized
                }
                
                //Number Of Unread Data
                if let tempStr = data.object(forKey: "count") as? NSNumber {
                    
                    let number = Int(tempStr)
                    if number > 0 {
                        newCell.lblCounter.text = tempStr.stringValue
                         newCell.lblCounter.isHidden = false
                    }else{
                        newCell.lblCounter.isHidden = true
                    }
                    
                }
            }
        }
       
        
        // return cell
        return  newCell
    }
    
    
    
    
    // MARK: - Collection view delegate
    
    // go to single photo list when clicked on any photo
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.menuList.count > indexPath.row {
            if let data = self.menuList.object(at: indexPath.row) as? NSDictionary {
                let objRoot: VendorListViewController = VendorListViewController(nibName: "VendorListViewController", bundle: nil)
                objRoot.resultData = data
                self.navigationController?.pushViewController(objRoot, animated: true)
                
            }
        }
        
        
    }
    
    func OpenDeskBoardSubMenu(_ menuId : String){
        print(menuId)
        if menuId == "2"
        {
          //  let objRoot: ComplainsViewController = ComplainsViewController(nibName: "ComplainsViewController", bundle: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let objRoot = storyboard.instantiateViewController(withIdentifier: "ComplainsViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "1"
        {
           // let objRoot: NoticeViewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objRoot = storyboard.instantiateViewController(withIdentifier: "NoticeViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if menuId == "3" {
            let objRoot: EventsViewController = EventsViewController(nibName: "EventsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "4" {
            let objRoot: GalleryViewController = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if menuId == "5"
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "DiscussionViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if menuId == "6" {
            let objRoot: MeetingViewController = MeetingViewController(nibName: "MeetingViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "7"
        {
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
        let objRoot = storyboard.instantiateViewController(withIdentifier: "FacilityViewController")
        self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if menuId == "8" {
            let objRoot: PollsViewController = PollsViewController(nibName: "PollsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "9"
        {            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "RulesViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "10" {
           
        }else if menuId == "11" {
            
        }else if menuId == "12" {
            let objRoot: DirectoryViewController = DirectoryViewController(nibName: "DirectoryViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
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
