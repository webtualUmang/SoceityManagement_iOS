//
//  GalleryViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 11/18/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

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
    
    var refreshControl: UIRefreshControl!
    // outlet - photo collection view
    @IBOutlet var photoCollectionView: UICollectionView!
    var NoticeBoardIDArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Gallery"
        
        let nipName=UINib(nibName: "GalleryCell", bundle:nil)
        photoCollectionView!.register(nipName, forCellWithReuseIdentifier: "GalleryCell")
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.perform(#selector(self.GetNoticeBoard(_:)), with: "0")
        //self.perform(#selector(self.GetNoticeBoard(_:)), with:nil, afterDelay:0.0)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action:#selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        self.photoCollectionView.addSubview(refreshControl)
    }
    @objc func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        //        self.performSelector("GetNoticeFromLocalDB:", withObject: NSArray())
        self.perform(#selector(self.GetNoticeBoard(_:)), with: "0")
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
    override func viewDidAppear(_ animated: Bool) {
        
        // Calculate cell width, height based on screen width
        self.calculateCellWidthHeight()
        
        // if photo list empty then try to load data
//        if self.photoList.isEmpty {
//            self.loadPhotoGallery()
//        }
    }
    
    // MARK: - Collection view dataSource
    
    // number of section in collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of photos in collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.NoticeBoardIDArray.count
    }
    
    // return width and height of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width / 2, height: collectionView.frame.width / 2)
    }
    
    // configure cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get collection view reusable  cell
        let newCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        // set corner radious for image
//        newCell.setPhotoCornerRadious(radious: self.cellWidth/4)
        
        // get current photo object from list
        if let data = self.NoticeBoardIDArray.object(at: indexPath.row) as? NSDictionary {
            // set placeholder until image downloaded from server.
            newCell.galleryImage.image = UIImage(named: "default_gray_image")
            if let tempStr = data.object(forKey: "album_name") as? String {
                newCell.lblName.text = tempStr
            }
            if let tempStr = data.object(forKey: "total_files") as? NSNumber {
                newCell.lblCount.text = tempStr.stringValue
            }
            // Download photo asynchronously
            if let imagePath = data.object(forKey: "image") as? String {
                // if image path convertible to url then load image asynchronously and set within cell
                if let imageURL = URL(string: imagePath) {
                    self.downloadCellPhotoInBackground(imageUrl: imageURL, photoCell: newCell)
                }
                
            }
            // return cell
            return  newCell
            
        }
        
        return UICollectionViewCell()
        
        
    }
    
    
    
    
    // MARK: - Collection view delegate
    
    // go to single photo list when clicked on any photo
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // find selected photo index path
        if self.NoticeBoardIDArray.count > indexPath.row {
            if let tempData = self.NoticeBoardIDArray.object(at: indexPath.row) as? NSDictionary {
                // create destination view controller
                let destViewCtrl: GalleryListViewController = GalleryListViewController(nibName: "GalleryListViewController", bundle: nil)
                
                
                // set current screne photo list to new controller
                destViewCtrl.albumResult = tempData
                
                self.navigationController?.pushViewController(destViewCtrl, animated: true)
            }
        }
       
    }
    
    
    //MARK:- API Funcation
    @objc func GetNoticeBoard(_ idStr : String)
    {
       
        let urlStr = String(format: "%@?view=album&page=new_added&userID=%@&societyID=%@&count=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID,idStr])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let bannerList = ResultData.object(forKey: "album_list") as? NSArray {
                                print(bannerList)
                                
                                self.NoticeBoardIDArray = MyDbManager.sharedClass().sorting(NSMutableArray(array: bannerList), sortBool: false, sortingKey: "albumID")
                                
                                DispatchQueue.main.async {
                                    self.refreshControl.endRefreshing()
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
                        self.refreshControl.endRefreshing()
                        appDelegate.TNMErrorMessage("", message: messageStr)
                    }
                }
                
            }
        }
        
    }

    
    // MARK: - Utility function
    
    // load gallery json file data from remove server and parse it to array
    // then reload collection view for display photo gallery
    fileprivate func loadPhotoGallery() -> Void {
        
        // make existing photo list empty if any data
//        self.photoList.removeAll(keepCapacity: false)
        
        // reload collection view so content become clear
        self.photoCollectionView.reloadData()
        
        // start the spinner
//        self.spinner.startAnimating()
        
        // create path for photo gallery json file
        let galleryJsonFilePath : String = REMOTE_DATA_FOLDER_PATH + "gallery.json"
        
        //  fetch json data
        self.fetchJsonData(
            jsonFilePath: galleryJsonFilePath,
            onCompletion: { (jsonData: JSON) -> Void in
                
                // fetch Photo object
                let photosJSON = jsonData["Photos"]
                for (_, subJson): (String, JSON) in photosJSON {
                    
//                    print(subJson)
                    
                    // creare photo object
                    let newPhoto = Photo()
                    newPhoto.title = subJson["title"].string!
                    newPhoto.thumbImage = subJson["thumbImage"].string!
                    newPhoto.largeImage = subJson["largeImage"].string!
                    
                    // append photo to list
//                    self.photoList.append(newPhoto)
                }
                
                // stop spinner and refresh collection view
                // important - gui operation must be within main queue
                DispatchQueue.main.async {
//                    self.spinner.stopAnimating()
                    self.photoCollectionView.reloadData()
                }
                
            },
            onError: { () -> Void in
                // important - gui operation must be within main queue
                DispatchQueue.main.async{
                    
                    // stop the spinner
//                    self.spinner.stopAnimating()
                    
                    // show error message
                    self.showAlertMessage(alertTitle: "Error", alertMessage: "Data fetching error. \n" + galleryJsonFilePath)
                }
            }
        )
    }
    
    // download Image asynchronously and assign to collection view cell
    func downloadCellPhotoInBackground( imageUrl: URL, photoCell: GalleryCell ) {
        
        let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            // if no error then update photo
            if (error == nil) {
                // update cell photo (GUI must updated in main_queue)
                DispatchQueue.main.async {
                    let imageData = NSData(data: data!) as Data
                    photoCell.galleryImage.image = UIImage(data: imageData )
                    photoCell.galleryImage.contentMode = UIView.ContentMode.scaleAspectFill
                }
            }
        }
        
        
        // resume - important
        task.resume()
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
    
    // fetch json file content from a given path and convert it to JSON object
    // json object conversion done using swifyJSON library
    // this function can be used to fetch any json file stored at remote url
    fileprivate func fetchJsonData(jsonFilePath: String, onCompletion: @escaping (_ jsonData: JSON) -> Void, onError: @escaping () -> Void ) {
        
        // convert file path to url
        if let jsonFileUrl = URL(string: jsonFilePath) {
            
            // create url request
            let urlRequest : URLRequest = NSMutableURLRequest(url: jsonFileUrl) as URLRequest
            
            // create url session
            let sharedSession : URLSession = URLSession.shared
            
            // request data task
            let dataTask = sharedSession.dataTask(with: urlRequest,
                completionHandler:
                {
                    (data: Data?, response: URLResponse?, error: NSError?) -> Void in
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                            // convert data to JSON object
                            let receivedJSON : JSON = try JSON(data: data!)
                            
                            // call the completion block
                            onCompletion(receivedJSON)
                        }else{
                            // call error block
                            onError()
                        }
                    }else{
                        // call error block
                        onError()
                    }
                    } as! (Data?, URLResponse?, Error?) -> Void as! (Data?, URLResponse?, Error?) -> Void
            )
            
            dataTask.resume() // important
            
        } else {
            // call error block
            onError()
        }
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
