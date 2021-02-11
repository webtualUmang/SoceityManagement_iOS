//
//  DeskBoardViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DeskBoardViewController: UIViewController,imageSliderDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CDRTranslucentSideBarDelegate
{

    @IBOutlet var footerView : UIView!
    @IBOutlet var headerView : CLabsImageSlider!
    @IBOutlet var tableView : UITableView!
    
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    var menuList : NSMutableArray = NSMutableArray()
    var imageUrls = NSArray()
    
    var collectionHeader = UICollectionReusableView()
    let BannerSlider = ImageSliderView.instanceFromNib()
    @IBOutlet var viewGlobal:[UIView]!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds
        
        // Do any additional setup after loading the view.
        headerView.sliderDelegate   =   self
        
       
        
        
        let nipName=UINib(nibName: "DeskBoardCell", bundle:nil)
        photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "DeskBoardCell")
     
        let myNib = UINib(nibName: "DeskBoardHeaderView",bundle: nil)
        self.photoCollectionView.register(myNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewTest")
        
        
        let flowLayout = self.photoCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.headerReferenceSize = CGSize(width: self.photoCollectionView.frame.size.width, height: 160)
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        

        self.perform(#selector(DeskBoardViewController.GetDeskBoardMenu))
        
    }
    func LoadBanner(_ urlImages : NSArray){
        

        DispatchQueue.main.async {
            self.imageUrls = NSArray(array: urlImages)
            self.BannerSlider.imageUrls = self.imageUrls
            self.photoCollectionView.reloadData()
        }


    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        headerView.StopTimer()
        
    }
    func didMovedToIndex(_ index:Int)
    {
        print("did moved at Index : ",index)
    }
    override func viewWillAppear(_ animated: Bool)
    {
        for viewmain in self.viewGlobal
               {
                   viewmain.layer.cornerRadius = 10
                   viewmain.layer.shadowColor = UIColor.black.cgColor
                   viewmain.layer.shadowOffset = CGSize(width: 0, height: 0)
                   viewmain.layer.shadowOpacity = 0.2
                   viewmain.layer.shadowRadius = 4.0
               }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
//        
//        let data = getLoginUser()
//        self.navigationItem.title = "BeUtopian"
//        if let tempStr = data.objectForKey("societyName") as? String {
//            self.navigationItem.title = tempStr
//        }
    }
        
    func SetFooterView(){
       let width = UIScreen.main.bounds.width
        var frame = self.footerView.frame
        if width >= 414 {
            frame.size.width = 414
            frame.size.height = 550
        }else if width >= 373 {
            frame.size.width = 373
            frame.size.height = 496
        }else if width >= 320 {
            frame.size.width = 320
            frame.size.height = 420
        }else{
            frame.size.width = 414
            frame.size.height = 550
        }
        self.footerView.frame = frame
        
//        self.tableView.tableFooterView = self.footerView
        
        self.tableView.tableHeaderView = self.headerView
        
        self.tableView.tableFooterView = self.photoCollectionView
    }
    @IBAction func menuClick(_ sender : UIButton) {
        if sender.tag == 2
        {
           // let objRoot: ComplainsViewController = ComplainsViewController(nibName: "ComplainsViewController", bundle: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "ComplainsViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 1
        {
           // let objRoot: NoticeViewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let objRoot = storyboard.instantiateViewController(withIdentifier: "NoticeViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 3 {
            let objRoot: EventsViewController = EventsViewController(nibName: "EventsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 4 {
            let objRoot: GalleryViewController = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
           
        }else if sender.tag == 5
        {
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "DiscussionViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if sender.tag == 6
        {
           
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "MeetingViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)

        }
        else if sender.tag == 7
        {
          
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "FacilityViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if sender.tag == 8 {
            let objRoot: PollsViewController = PollsViewController(nibName: "PollsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 9
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objRoot = storyboard.instantiateViewController(withIdentifier: "RulesViewController")
           
            self.navigationController?.pushViewController(objRoot, animated: true)
        }

        
    }
    
    @objc func GetDeskBoardMenu()
    {
      
        let urlStr = String(format: "%@?view=dashboard&userID=%@&societyID=%@&gtoken=%@&gdevice=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,iDeviceToken,iDeviceType])
        
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            
            if succeeded == true {
//                                print(data)
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "data_list") as? NSArray {
                                print(bannerList)
                                self.menuList = NSMutableArray(array: bannerList)
                                
                                DispatchQueue.main.async {
                                   
                                    self.calculateCellWidthHeight()
                                   self.photoCollectionView.reloadData()
                                }
                                
                            }
                            
                            if let bannerList = ResultData.object(forKey: "banners") as? NSArray {
                                let bannerUrls = NSMutableArray()
                                for bannerData in bannerList {
                                    if let tempData = bannerData as? NSDictionary {
                                        if let tempStr = tempData.object(forKey: "image") as? String {
                                            bannerUrls.add(tempStr)
                                        }
                                    }
                                    
                                }
                                
                                DispatchQueue.main.async {
                                    self.LoadBanner(bannerUrls)
                                    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView1 = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderViewTest", for: indexPath)
            self.collectionHeader = headerView1
            
            BannerSlider.imageUrls = self.imageUrls
            
            BannerSlider.frame = headerView1.frame
            headerView1.addSubview(BannerSlider)

            return headerView1
        } else {
            return UICollectionReusableView()
        }
        
        
//        return reusableView!
    }

    
    // number of section in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of photos in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    // return width and height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    // configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get collection view reusable  cell
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeskBoardCell", for: indexPath) as! DeskBoardCell
        if self.menuList.count > indexPath.row {
            if let data = self.menuList.object(at: indexPath.row) as? NSDictionary {
//                var menuSortId = "1"
                if let tempStr = data.object(forKey: "sort_id") as? String {
//                    menuSortId = tempStr
                    let image = UIImage(named: tempStr)
                    if image != nil {
                        newCell.imgIcons.image = image
                    }
                }
                newCell.hdView.backgroundColor = UIColor.white
                if let tempStr = data.object(forKey: "title") as? String {
                    if tempStr.caseInsensitiveCompare("rule") == .orderedSame {
                        newCell.lblTitle.text = "Society rules"
                    }else if tempStr.caseInsensitiveCompare("complain") == .orderedSame {
                        newCell.lblTitle.text = "Complaints"
                    }else if tempStr.caseInsensitiveCompare("vendor") == .orderedSame {
                        newCell.lblTitle.text = "WGATE"
                        newCell.imgIcons.image = #imageLiteral(resourceName: "homedelightLogo")
                        newCell.hdView.backgroundColor = UIColor(hexString: "e3f2fd")
                    }
                    else{
                        newCell.lblTitle.text = tempStr.capitalized
                    }
                    
                }
                newCell.lblCounter.isHidden = true
                //Number Of Unread Data
              
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
                
                if let tempStr = data.object(forKey: "sort_id") as? String {
                    self.OpenDeskBoardSubMenu(tempStr)
                }
            }
        }
        
        
    }
    
    func OpenDeskBoardSubMenu(_ menuId : String){
        print(menuId)
        if menuId == "2" {
           // let objRoot: ComplainsViewController = ComplainsViewController(nibName: "ComplainsViewController", bundle: nil)
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
        }else if menuId == "6"
        {
          
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "MeetingViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }
        else if menuId == "7"
        {
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "FacilityViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if menuId == "8"
        {
            let objRoot: PollsViewController = PollsViewController(nibName: "PollsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "9"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "RulesViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if menuId == "10" {
            let objRoot = HomeDelightViewController(nibName: "HomeDelightViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
           
        }else if menuId == "11"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot:BazzarViewController = storyboard.instantiateViewController(withIdentifier: "BazzarViewController") as! BazzarViewController
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }
        else if menuId == "12" {
            let objRoot: DirectoryViewController = DirectoryViewController(nibName: "DirectoryViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        else if menuId == "19"
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot:lostfoundlistVC = storyboard.instantiateViewController(withIdentifier: "lostfoundlistVC") as! lostfoundlistVC
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
