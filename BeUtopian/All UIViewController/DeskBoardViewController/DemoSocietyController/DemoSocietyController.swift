//
//  DeskBoardViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DemoSocietyController: UIViewController,imageSliderDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,CDRTranslucentSideBarDelegate,HeplPopupDelegate {

    
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    var menuList : NSArray = NSArray()
    var imageUrls = NSArray()
    
    var collectionHeader = UICollectionReusableView()
    let BannerSlider = ImageSliderView.instanceFromNib()
    
    //Slider
    var sideBar = CDRTranslucentSideBar()
    var isEnableSlider : Bool = false
    
    var helpPopups: KOPopupView = KOPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Your Society"
        // Do any additional setup after loading the view.
       

        //SliderMenu
        
        self.sideBar?.sideBarWidth = (UIScreen.main.bounds.width / 4) * 3
        self.sideBar?.delegate = self
        //    self.sideBar.translucentStyle = UIBarStyleBlack;
        self.sideBar?.tag = 1
        self.isEnableSlider = false
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DemoSocietyController.handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        let sliderMenu = SliderLeftMenu.instanceFromNib()
        sliderMenu.parentViewController = self
        self.sideBar?.setContentViewIn(sliderMenu)
        
        let nipName=UINib(nibName: "DeskBoardCell", bundle:nil)
        photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "DeskBoardCell")
     
        let myNib = UINib(nibName: "DeskBoardHeaderView",bundle: nil)
        self.photoCollectionView.register(myNib, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderViewTest")
        
       
        // if you don't do something about header size...
        // ...you won't see any headers
        
        
        let flowLayout = self.photoCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.headerReferenceSize = CGSize(width: self.photoCollectionView.frame.size.width, height: 120)
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self

//        self.performSelector("GetDeskBoardBanner")
        
        self.perform(#selector(DemoSocietyController.GetDeskBoardFromLocalDB))
//        self.performSelector("GetDeskBoardMenu")
        
        
        self.SetNavigationButton()
        
        self.LoadStartedHelp()
    }
    func LoadStartedHelp(){
        let notesView = GetStartedPopup.instanceFromNib()
        notesView.delegate = self
        
        self.helpPopups.handleView.addSubview(notesView)
        
        notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
            y: self.helpPopups.handleView.frame.size.height/2.0)
        self.helpPopups.show()
    }
    func LoadBanner(_ urlImages : NSArray){
        

        DispatchQueue.main.async{
            self.imageUrls = NSArray(array: urlImages)
            self.BannerSlider.imageUrls = self.imageUrls
            self.photoCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    func didMovedToIndex(_ index:Int)
    {
        print("did moved at Index : ",index)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    func SetNavigationButton(){
        
        //Left SliderButton
        let leftframe = CGRect(x: 0, y: 10, width: 30, height: 30)
        let leftButton = UIButton(frame: leftframe)
        leftButton.setImage(UIImage(named: "btnMenu"), for: UIControl.State())
        leftButton.addTarget(self, action: #selector(DemoSocietyController.OnSideBarButtonTapped(_:)), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    @IBAction func OnSideBarButtonTapped(_ sender : AnyObject){
        if self.isEnableSlider == true {
            self.sideBar?.dismiss(animated: true)
        }else{
            self.sideBar?.show(in: self)
        }
    }
    func OpenMyProfile(){
        let objRoot: ProfileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
                
    }
    func OpenNotifications(){
        let objRoot: NotificationViewController = NotificationViewController(nibName: "NotificationViewController", bundle: nil)
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
    
    @IBAction func menuClick(_ sender : UIButton) {
        if sender.tag == 2 {
         //   let objRoot: ComplainsViewController = ComplainsViewController(nibName: "ComplainsViewController", bundle: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let objRoot = storyboard.instantiateViewController(withIdentifier: "ComplainsViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 1
        {
          //  let objRoot: NoticeViewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "NoticeViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
            
            
        }
        else if sender.tag == 3 {
            let objRoot: EventsViewController = EventsViewController(nibName: "EventsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 4 {
            let objRoot: GalleryViewController = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
           
        }else if sender.tag == 5
        {
          //  let objRoot: DiscussionViewController = DiscussionViewController(nibName: "DiscussionViewController", bundle: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "DiscussionViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
            
            
            
        }
        else if sender.tag == 6
        {
          //  let objRoot: MeetingViewController = MeetingViewController(nibName: "MeetingViewController", bundle: nil)
          //  self.navigationController?.pushViewController(objRoot, animated: true)
            
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
        else if sender.tag == 8
        {
            let objRoot: PollsViewController = PollsViewController(nibName: "PollsViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if sender.tag == 9
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let objRoot = storyboard.instantiateViewController(withIdentifier: "RulesViewController")
            self.navigationController?.pushViewController(objRoot, animated: true)
        }

        
    }
    
    
    func GetDeskBoardBanner()
    {
        
        let urlStr = String(format: "%@?view=banner&page=home&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
//                print(data)
                 if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
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
   

    //MARK:- Open Slider ViewController -
    func OpenSubMenu(_ titleStr : String){
        
        if titleStr.caseInsensitiveCompare("About Wgate") == .orderedSame {
            let objRoot: AboutViewController = AboutViewController(nibName: "AboutViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if titleStr.caseInsensitiveCompare("Help / Support") == .orderedSame
        {
           // let objRoot: SupportViewController = SupportViewController(nibName: "SupportViewController", bundle: nil)
           // self.navigationController?.pushViewController(objRoot, animated: true)
            
          
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                       let vc = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
                       self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if titleStr.caseInsensitiveCompare("Visitor") == .orderedSame {
            let objRoot: VisitorViewController = VisitorViewController(nibName: "VisitorViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if titleStr.caseInsensitiveCompare("logout") == .orderedSame {
            let objRoot: LoginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            let navigation = UINavigationController(rootViewController: objRoot)
            appDelegate.SetNavigationBar(navigation)
//            self.sidePanelController?.centerPanel = navigation
            appDelegate.window?.rootViewController = navigation
            RemoveLoginUser()
            
        }else if titleStr.caseInsensitiveCompare("My Society") == .orderedSame {
            let objRoot: SocietyViewController = SocietyViewController(nibName: "SocietyViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("Blog") == .orderedSame {
            let objRoot: BrowserViewController = BrowserViewController(nibName: "BrowserViewController", bundle: nil)
            objRoot.websiteUrl = "http://sms.thewebtual.com/blog/"
            objRoot.navigationTitle = "Blog"
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if titleStr.caseInsensitiveCompare("profile") == .orderedSame {
            let objRoot: ProfileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            self.navigationController?.pushViewController(objRoot, animated: true)
            
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

                if let tempStr = data.object(forKey: "sort_id") as? String {

                    let image = UIImage(named: tempStr)
                    if image != nil {
                        newCell.imgIcons.image = image
                    }
                }
                if let tempStr = data.object(forKey: "title") as? String {
                    if tempStr.caseInsensitiveCompare("rule") == .orderedSame {
                        newCell.lblTitle.text = "Society rules"
                    }else{
                        newCell.lblTitle.text = tempStr.capitalized
                    }
                    
                }
                newCell.lblCounter.isHidden = true
               
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
    func helpPopupClose() {
        helpPopups.hide(animated: true)
    }
    
    func OpenDeskBoardSubMenu(_ menuId : String){
        print(menuId)
               
        helpPopups = KOPopupView()
        
        if menuId == "2" {
            DispatchQueue.main.async {
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Your Complain is just a click away! Now Register any complain with comments and status updates."
                notesView.lblMenu.text = "Complaint"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }

        }else if menuId == "1" {
            
            DispatchQueue.main.async {
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Save Time, make Faster and Smarter decisions by creating instant Opinion Polls among all members for better decision making!"
                notesView.lblMenu.text = "Notice Board"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()

            }
            

        }else if menuId == "3" {
            DispatchQueue.main.async { 
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Get instant Reminders of society gathering's and festive occasions. Also get Interested / Attending member list."
                notesView.lblMenu.text = "Event"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }

//            let objRoot: EventsViewController = EventsViewController(nibName: "EventsViewController", bundle: nil)
//            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "4" {
            DispatchQueue.main.async {
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Keep your memories alive by sharing society photographs and updates on a common platform!"
                notesView.lblMenu.text = "Gallery"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }
//            let objRoot: GalleryViewController = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
//            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else if menuId == "5" {
            DispatchQueue.main.async { ()
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Create meaningful and specific discussions to promote A Healthy and Eco-Smart way of Living!"
                notesView.lblMenu.text = "Discussion"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }

        }else if menuId == "6" {
            DispatchQueue.main.async {
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Get instant updates for society meetings including a list of participants attending / interested in meeting!"
                notesView.lblMenu.text = "Meetings"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }

        }else if menuId == "7" {
            DispatchQueue.main.async {
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Avoid last minutes booking hassles. Now Booking Common Facilities in advance is Just a Click away. Save Time! Save Efforts!"
                notesView.lblMenu.text = "Facility Bookings"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }

        }else if menuId == "8" {
            DispatchQueue.main.async {
                let notesView = DemoNotesPopup.instanceFromNib()
                notesView.delegate = self
                if let image = UIImage(named: menuId) {
                    notesView.menuImage.image = image
                }
                notesView.lblDesc.text = "Save Time, make Faster and Smarter decisions by creating instant Opinion Polls among all members for better decision making!"
                notesView.lblMenu.text = "Polls"
                self.helpPopups.handleView.addSubview(notesView)
                
                notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                    y: self.helpPopups.handleView.frame.size.height/2.0)
                self.helpPopups.show()
                
            }
//            let objRoot: PollsViewController = PollsViewController(nibName: "PollsViewController", bundle: nil)
//            self.navigationController?.pushViewController(objRoot, animated: true)
        }else if menuId == "9" {
            let notesView = DemoNotesPopup.instanceFromNib()
            notesView.delegate = self
            if let image = UIImage(named: menuId) {
                notesView.menuImage.image = image
            }
            notesView.lblDesc.text = "Maintain integrity and Harmony within the society by sharing / adding / amending society specific rules for Batter Community Living."
            notesView.lblMenu.text = "Society Rules"
            self.helpPopups.handleView.addSubview(notesView)
            
            notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                y: self.helpPopups.handleView.frame.size.height/2.0)
            self.helpPopups.show()

        }else if menuId == "10" {
            let notesView = DemoNotesPopup.instanceFromNib()
            notesView.delegate = self
            if let image = UIImage(named: menuId) {
                notesView.menuImage.image = image
            }
            notesView.lblDesc.text = "Add, Update and share reliable & cost effective vendor directory for society maintainance and house specific sevice. for your property."
            notesView.lblMenu.text = "Vendor Service"
            self.helpPopups.handleView.addSubview(notesView)
            
            notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                y: self.helpPopups.handleView.frame.size.height/2.0)
            self.helpPopups.show()
//            let objRoot: VendorViewController = VendorViewController(nibName: "VendorViewController", bundle: nil)
//            self.navigationController?.pushViewController(objRoot, animated: true)
           
        }else if menuId == "11" {
            let notesView = DemoNotesPopup.instanceFromNib()
            notesView.delegate = self
            if let image = UIImage(named: menuId) {
                notesView.menuImage.image = image
            }
            notesView.lblDesc.text = "Easily Sell & Buy products within your society members to get a best deal at your Doorstep."
            notesView.lblMenu.text = "Bazaar"
            self.helpPopups.handleView.addSubview(notesView)
            
            notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                y: self.helpPopups.handleView.frame.size.height/2.0)
            self.helpPopups.show()

        }else if menuId == "12" {
            let notesView = DemoNotesPopup.instanceFromNib()
            notesView.delegate = self
            if let image = UIImage(named: menuId) {
                notesView.menuImage.image = image
            }
            notesView.lblDesc.text = "Get an easy access to your society Directory of Committee / Members / Society Staff / Vehicles for smooth functioning!`"
            notesView.lblMenu.text = "Bazaar"
            self.helpPopups.handleView.addSubview(notesView)
            
            notesView.center = CGPoint(x: self.helpPopups.handleView.frame.size.width/2.0,
                y: self.helpPopups.handleView.frame.size.height/2.0)
            self.helpPopups.show()
//            let objRoot: DirectoryViewController = DirectoryViewController(nibName: "DirectoryViewController", bundle: nil)
//            self.navigationController?.pushViewController(objRoot, animated: true)
        }
        
        

    }

    //MARK:- Local Database Management
    @objc func GetDeskBoardFromLocalDB(){
        //Fetch data FRom SQLITE
        
        self.menuList = [[
            "dashID" : "1",
            "number" : "15",
            "sort_id" : "1",
            "title" : "notice"
            ],
            [
                "dashID" : "2",
                "number" : "24",
                "sort_id" : "2",
                "title" : "complain"
            ],
            [
                "dashID" : "3",
                "number" : "4",
                "sort_id" : "3",
                "title" : "event"
            ],
            [
                "dashID" : "4",
                "number" : "6",
                "sort_id" : "4",
                "title" : "gallery"
            ],[
                "dashID" : "5",
                "number" : "13",
                "sort_id" : "5",
                "title" : "discussion"
            ],
            [
                "dashID" : "6",
                "number" : "4",
                "sort_id" : "6",
                "title" : "meeting"
            ],
            [
                "dashID" : "7",
                "number" : "0",
                "sort_id" : "7",
                "title" : "facility"
            ],
            [
                "dashID" : "8",
                "number" : "19",
                "sort_id" : "8",
                "title" : "poll"
            ],
            [
                "dashID" : "9",
                "number" : "8",
                "sort_id" : "9",
                "title" : "rule"
            ],
            [
                "dashID" : "10",
                "number" : "0",
                "sort_id" : "10",
                "title" : "vendor"
            ],
            [
                "dashID" : "11",
                "number" : "0",
                "sort_id" : "11",
                "title" : "bazaar"
            ],
            [
                "dashID" : "12",
                "number" : "0",
                "sort_id" : "12",
                "title" : "directory"
            ]
            ]
        
        
        DispatchQueue.main.async { 
            
            self.calculateCellWidthHeight()
            self.photoCollectionView.reloadData()
        }
    }
    
    //MARK: - Gesture Handler -
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        // if you have left and right sidebar, you can control the pan gesture by start point.
        if recognizer.state == .began {
            let startPoint = recognizer.location(in: self.view)
            // Left SideBar
            if startPoint.x < self.view.bounds.size.width / 2.0 {
                self.sideBar?.isCurrentPanGestureTarget = true
            }
            
        }
        //	[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
        self.sideBar?.handlePanGesture(toShow: recognizer, in: self)

        // if you have only one sidebar, do like following
        // self.sideBar.isCurrentPanGestureTarget = YES;
        //[self.sideBar handlePanGestureToShow:recognizer inView:self.view];
    }
    
    //MARK: - CDRTranslucentSideBarDelegate -

    func sideBar(_ sideBar: CDRTranslucentSideBar, didAppear animated: Bool) {
        if sideBar.tag == 0 {
            print("Left SideBar did appear")
        }
        if sideBar.tag == 1 {
            print("Right SideBar did appear")
            self.isEnableSlider = true
        }
    }
    func sideBar(_ sideBar: CDRTranslucentSideBar, willDisappear animated: Bool) {
        if sideBar.tag == 0 {
            print("Left SideBar will disappear")
        }
        if sideBar.tag == 1 {
            print("Right SideBar will disappear")
            self.isEnableSlider = false
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
    
    /*OPration Count
    func calculate() {
    let queue = NSOperationQueue()
    let blockOperation = NSBlockOperation {
    
    var result = 0
    
    for i in 1...1000000000 {
    result += i
    }
    
    NSOperationQueue.mainQueue().addOperationWithBlock {
    //                self.activityIndicator.stopAnimating()
    //                self.label.text = "\(result)"
    //                self.label.hidden = false
    //                print(("result === ")
    //                print(result)
    print("result--------")
    print(result)
    }
    }
    
    queue.addOperation(blockOperation)
    }
    
    
    func blockOperationsTest1(){
    
    let operationQueue = NSOperationQueue()
    
    let operation1 : NSBlockOperation = NSBlockOperation (block: {
    self.doCalculations()
    
    let operation2 : NSBlockOperation = NSBlockOperation (block: {
    
    self.doSomeMoreCalculations()
    
    })
    operationQueue.addOperation(operation2)
    })
    operationQueue.addOperation(operation1)
    }
    func doCalculations(){
    NSLog("do Calculations")
    for i in 100...105{
    print("i in do calculations is \(i)")
    sleep(1)
    }
    }
    
    func doSomeMoreCalculations(){
    NSLog("do Some More Calculations")
    for j in 1...5{
    print("j in do some more calculations is \(j)")
    sleep(1)
    }
    
    }

*/

}
