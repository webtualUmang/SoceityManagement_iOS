//
//  DeskBoardViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 12/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class BazzarViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    @IBOutlet var btnAdd:UIButton!
    
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    var menuList : NSArray = NSArray()
    @IBOutlet var viewBack:UIView!
    var collectionHeader = UICollectionReusableView()
    var arrData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Bazaar"
        // Do any additional setup after loading the view.
//        self.view.frame = UIScreen.mainScreen().bounds
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name ("Bazzar_list"), object:nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(notificationSet),
                         name: NSNotification.Name ("Bazzar_list"),                                           object: nil)
       // let nipName=UINib(nibName: "BazzarCell", bundle:nil)
       // photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "BazzarCell")
     
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
       // self.perform("GetVendordMenu")
        self.GetVendordMenu()
        
        
        
        self.btnAdd.addTarget(self, action:#selector(self.AddBazzarData), for: .touchUpInside)
        
       
    }
    @objc func notificationSet()
       {
         self.GetVendordMenu()

       }
    @objc func AddBazzarData()
    {
        let objRoot: AddBazzarViewController = AddBazzarViewController(nibName: "AddBazzarViewController", bundle: nil)
        objRoot.category_list = self.menuList
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        if ((self.navigationController!.presentingViewController) != nil)
        {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:#selector(self.dismissview))
        }
        
    }
    @objc func dismissview()
    {
        self.dismiss(animated: true) {
            
        }
    }
    func GetVendordMenu()
    {
        
        let urlStr = String(format: "%@?view=bazar&page=category_list&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            

            
            if succeeded == true {
                //                print(data)
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0"
                        {
                            if let bannerList = ResultData.object(forKey: "bazar_cat_list") as? NSArray {
                                print(ResultData)
                                self.menuList = NSArray(array: bannerList)
                                
                                DispatchQueue.main.async
                                    {
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width / 3, height: collectionView.frame.width / 3)
    }
    
    // configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get collection view reusable  cell
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BazzarCell", for: indexPath) as! BazzarCell
        if self.menuList.count > indexPath.row {
            if let data = self.menuList.object(at: indexPath.row) as? NSDictionary {
                
                if let tempStr = data.object(forKey: "icon") as? String {
                    if tempStr.isEmpty == false
                    {
                        let urlString : URL = URL(string: tempStr)!
                        newCell.imgIcons.clipsToBounds = true
                        newCell.imgIcons.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options:.retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil
                            {
                                newCell.imgIcons.image = image
                            }
                            
                        })
                        
                    }
                }
                
                if let tempStr = data.object(forKey: "name") as? String
                {
                    newCell.lblTitle.text = tempStr.capitalized
                    newCell.lblTitle.minimumScaleFactor = 0.5
                }
                
                //Number Of Unread Data
                if let tempStr = data.object(forKey: "count") as? NSNumber
                {
                    
                    let number = Int(tempStr)
                    if number > 0
                    {
                        newCell.lblCounter.text = tempStr.stringValue
                         newCell.lblCounter.isHidden = false
                    }else
                    {
                        newCell.lblCounter.text = tempStr.stringValue
                        newCell.lblCounter.isHidden = false
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
                let objRoot: BazaarListViewController = BazaarListViewController(nibName: "BazaarListViewController", bundle: nil)
                objRoot.resultData = data
                self.navigationController?.pushViewController(objRoot, animated: true)
                
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
