//
//  CommitteeViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 27/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class CommitteeViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // final width will be calculated based on screen width and height
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    @IBOutlet var photoCollectionView: UICollectionView!
    
    var ComplainsCells = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nipName=UINib(nibName: "CommitteeGridCell", bundle:nil)
        photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "CommitteeGridCell")
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
       // self.perform("GetNoticeBoard")
        self.GetNoticeBoard()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        // Calculate cell width, height based on screen width
        self.calculateCellWidthHeight()
        
        // if photo list empty then try to load data
        //        if self.photoList.isEmpty {
        //            self.loadPhotoGallery()
        //        }
    }
    
    
    
    // number of section in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of photos in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ComplainsCells.count
    }
    
    // return width and height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width / 2, height: collectionView.frame.width / 2)
    }
    
    // configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get collection view reusable  cell
        
       
        if self.ComplainsCells.count > indexPath.row {
            // get current photo object from list
            if let data = self.ComplainsCells.object(at: indexPath.row) as? NSDictionary {
                
                let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommitteeGridCell", for: indexPath) as! CommitteeGridCell
                // set placeholder until image downloaded from server.
                
                if let tempStr = data.object(forKey: "name") as? String {
                    newCell.lblTitle.text = tempStr.uppercased()
                }
                if let tempStr = data.object(forKey: "type") as? String {
                    newCell.lblType.text = tempStr.uppercased()
                }
                if let tempStr = data.object(forKey: "user_image") as? String {
                    if tempStr.isEmpty == false {
                        let urlString : URL = URL(string: tempStr)!
                        newCell.profileImage.clipsToBounds = true
                        newCell.profileImage.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil {
                                newCell.profileImage.image = image
                            }
                            
                        })
                        
                    }
                }
                // return cell
                return  newCell
                
            }
        }
        
       
        
        return UICollectionViewCell()
        
        
    }
    
    
    
    
    // MARK: - Collection view delegate
    
    // go to single photo list when clicked on any photo
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        // find selected photo index path
//        if self.ComplainsCells.count > indexPath.row {
//            if let tempData = self.ComplainsCells.objectAtIndex(indexPath.row) as? NSDictionary {
//                // create destination view controller
//                let destViewCtrl: GalleryListViewController = GalleryListViewController(nibName: "GalleryListViewController", bundle: nil)
//                
//                
//                // set current screne photo list to new controller
//                destViewCtrl.albumResult = tempData
//                
//                self.navigationController?.pushViewController(destViewCtrl, animated: true)
//            }
//        }
        
    }
    
    
    //MARK: - API Delegate -
    
    func GetNoticeBoard()
    {
        
        let urlStr = String(format: "%@?view=committee&page=list&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
       
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "committee_list") as? NSArray {
                                DispatchQueue.main.async {
                                    self.ComplainsCells = NSMutableArray(array: bannerList)
//                                    self.CreateCell(bannerList)
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
        let numberOfPhotoInRow : CGFloat = 2
        
        // find current screen width
        let screenWidth = self.photoCollectionView.frame.width
        
        
        // deduct spacing from screen width
        // Formula: screeWidth - leftSpace - ( spaceBetweenThumb * (numberOfPhotoInRow - 1) ) - rightSpace
        let netWidth = screenWidth - 5 - ( 5 * (numberOfPhotoInRow - 1) ) - 5
        
        // calcualte single thumb width
        let thumbWidth = Int( netWidth / numberOfPhotoInRow)
        
        // assign width to class variable
        self.cellWidth = thumbWidth
        self.cellHeight = thumbWidth
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
