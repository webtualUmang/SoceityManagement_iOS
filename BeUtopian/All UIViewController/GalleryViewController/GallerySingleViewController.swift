//
//  GallerySingleViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 11/18/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit
import AssetsLibrary

class GallerySingleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // collection view cell default width, height
    // final width will be calculated based on screen width and height
    var cellWidth: Int = 100
    var cellHeight: Int = 100
    
    // variable keep track that view appear or not.
    // we have to load collection view after view appear so correct cell size achieved.
    var isViewAppear: Bool = false
    
    // clicked photo indexPath (will be set by parent controller)
    var clickedPhotoIndexPath : IndexPath?
    
    // photo list (will be set by parent controller)
//    var photoList: [Photo] = [Photo]()
    
    var NoticeBoardIDArray = NSArray()
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    var images = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set collectionview delegate and datasource
        self.navigationItem.title = "Gallery"
        let nipName=UINib(nibName: "GallerySingleCell", bundle:nil)
        photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "GallerySingleCell")
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool)
    {
//        self.navigationController?.navigationBarHidden = false
//        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.translucent = true
//        self.navigationController?.navigationBar.tintColor = NSTheme().GetNavigationTitleColor()
        
        
//        let left = UIBarButtonItem(image: UIImage(named: "ac_title_left"), style: .Plain, target: self, action: "backClick:")
//        self.navigationItem.leftBarButtonItem = left
        
//        let right = UIBarButtonItem(image: UIImage(named: "ic_menu_share"), style: .Plain, target: self, action: "shareClick:")
//        self.navigationItem.rightBarButtonItem = right
        
        let right = UIBarButtonItem(title: "More", style: .plain, target: self, action: #selector(GallerySingleViewController.OpenAlertView))
        self.navigationItem.rightBarButtonItem = right
    }
    
    //    override func viewWillDisappear(animated: Bool) {
    //        self.navigationController?.navigationBarHidden = false
    //    }
    //    override func viewDidDisappear(animated: Bool) {
    //        self.navigationController?.navigationBarHidden = false
    //    }
    @IBAction func shareClick(_ sender : AnyObject){
//        let shareList: NSArray = [self.imageview.image!]
//        let sharePicker = UIActivityViewController(activityItems: shareList as [AnyObject], applicationActivities: [])
//        
//        self.presentViewController(sharePicker, animated: true, completion: { () -> Void in
//            
//        })
    }
    
    @objc func OpenAlertView(){
        
        // create alert controller
        let alertCtrl = UIAlertController(title: nil, message: "Option", preferredStyle: UIAlertController.Style.actionSheet) as UIAlertController
        
        // create action
        let shareAction = UIAlertAction(title: "Share", style: UIAlertAction.Style.default, handler:
            { (action: UIAlertAction) -> Void in
                // you can add code here if needed
                
                let shareList: NSArray = [(self.images.image)!]
                let sharePicker = UIActivityViewController(activityItems: shareList as [AnyObject], applicationActivities: [])
                self.present(sharePicker, animated: true, completion: { () -> Void in
                })
        })
        
        let downloadAction = UIAlertAction(title: "Download", style: UIAlertAction.Style.default, handler:
            { (action: UIAlertAction) -> Void in
                // you can add code here if needed
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let imageData = self.images.image!.jpegData(compressionQuality: 0.6)
//                let imageData = (self.images.image)!.jpegData(compressionQuality: 0.6)
                let compressedJPGImage = UIImage(data: imageData!)
                ALAssetsLibrary().writeImage(toSavedPhotosAlbum: compressedJPGImage!.cgImage, orientation: ALAssetOrientation(rawValue: compressedJPGImage!.imageOrientation.rawValue)!,
                    completionBlock:{ (path:URL!, error:NSError!) -> Void in
                        print("\(path)")  //Here you will get your path
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        if(UIApplication.shared.isIgnoringInteractionEvents){
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        } as! ALAssetsLibraryWriteImageCompletionBlock)
        })
        
        let CancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:
            { (action: UIAlertAction) -> Void in
                // you can add code here if needed
        })
        
        // add ok action
        alertCtrl.addAction(shareAction)
        alertCtrl.addAction(downloadAction)
        alertCtrl.addAction(CancelAction)
        
        // present alert
        self.present(alertCtrl, animated: true, completion:nil)

    }
    
    @IBAction func backClick(_ sender : AnyObject){
       self.navigationController?.popFadeViewController()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        // set view as appear
        self.isViewAppear = true
        
        // Calculate cell width, height based on screen width
        self.calculateCellWidthHeight()
        
        if self.NoticeBoardIDArray.count == 0 {
            self.showAlertMessage(alertTitle: "Error", alertMessage: "Photo list found empty.")
        }else{
            // reload collection view data
            self.photoCollectionView.reloadData()
            
            // scroll collection view at selected photo
            self.photoCollectionView.scrollToItem(at: clickedPhotoIndexPath!, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
        }
    }

    // MARK: - Collection view data source
    
    // number of section in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of photos in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isViewAppear {
            return self.NoticeBoardIDArray.count
        }else{
            return 0
        }
    }
    
    // return width and height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellHeight)
    }
    
    // configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get reusable cell
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallerySingleCell", for: indexPath) as! GallerySingleCell
        
        // get current photo from list
        if NoticeBoardIDArray.count > indexPath.row {
            // get current photo object from list
            if let data = self.NoticeBoardIDArray.object(at: indexPath.row) as? NSDictionary {
                // set placeholder until image downloaded from server.
                newCell.largeImageView.image = UIImage(named: "default_gray_image")
                // Download photo asynchronously
                if let imagePath = data.object(forKey: "big_image_url") as? String {
                    // if image path convertible to url then load image asynchronously and set within cell
                    if let imageURL = URL(string: imagePath) {
                        self.downloadCellPhotoInBackground(imageUrl: imageURL, photoCell: newCell)
                    }
                    
                }
                // return cell
                return  newCell
                
            }

        }
        return UICollectionViewCell()
        // set placeholder until image downloaded from server.
        
    }
    
    
    
    
    // MARK: - Utility functions
    
    // download Image asynchronously and assign to cell once downloaded
    func downloadCellPhotoInBackground( imageUrl: URL, photoCell: GallerySingleCell ) {
        
        let task = URLSession.shared.dataTask(with: imageUrl, completionHandler:
            {
                (data, response, error) -> Void in
                
                // if no error then update photo
                if (error == nil) {
                    
                    // update cell photo (GUI must updated in main_queue)
                    DispatchQueue.main.async(execute: {
                        
                        // conver to NSData
                        let imageData = NSData(data: data!) as Data
                        
                        // set image to large image view within cell
                        photoCell.largeImageView.image = UIImage(data: imageData )
                        self.images.image = UIImage(data: imageData )
                        // stop the spinner
                        photoCell.spinner.stopAnimating()
                        
                    })
                }
        })
        
        // important
        task.resume()
    }
    
    // calculate collection view cell width same as full screen
    fileprivate func calculateCellWidthHeight() {
        
        // find cell width same as screen width
        self.cellWidth = Int(UIScreen.main.bounds.size.width)
        
        // find cell height
        self.cellHeight = Int(self.photoCollectionView.frame.height) - 64  // deduct nav bar and status bar height
    }
    
    // show alert with ok button
    fileprivate func showAlertMessage(alertTitle: String, alertMessage: String ) -> Void {
        
        // create alert controller
        let alertCtrl = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert) as UIAlertController
        
        // create action
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:
            { (action: UIAlertAction) -> Void in
                // you can add code here if needed
        })
        
        // add ok action
        alertCtrl.addAction(okAction)
        
        // present alert
        self.present(alertCtrl, animated: true, completion:nil)
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
