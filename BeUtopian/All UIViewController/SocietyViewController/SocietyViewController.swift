//
//  SocietyViewController.swift
//  BeUtopian
//
//  Created by Jeevan on 18/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit
import MapKit

class SocietyViewController: UIViewController,TopBarMenuViewDelegate,UITableViewDelegate,UITableViewDataSource
{

    @IBOutlet var tableView : UITableView!
    @IBOutlet var tableViewOther : UITableView!
    @IBOutlet var headerView : UIView!
    @IBOutlet var menuHeaderView : UIView!
    
    @IBOutlet var aboutView : UIView!
    
    @IBOutlet var detailsView : UIView!
    @IBOutlet var locationView : UIView!
    
    @IBOutlet var logoImage : UIImageView!
    @IBOutlet var background : UIImageView!
    
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var lblPhone : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var socityName : UILabel!
    
    var latitude : Double = 0
    var logitude : Double = 0
    
    var otherCells = NSMutableArray()
    
    @IBOutlet var mapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Society"
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.aboutView
        
        let nibName = UINib(nibName: "SocietyOtherCell", bundle: nil)
        self.tableViewOther .register(nibName, forCellReuseIdentifier: "SocietyOtherCell")
        
        self.GetAboutSociety()
        
        self.perform(#selector(SocietyViewController.SetTopMenu), with: nil, afterDelay: 0.1)
        // Do any additional setup after loading the view.
    }

    @objc func SetTopMenu()
    {
        let topBarMenu = TopBarMenuView.instanceFromNib()
        
        topBarMenu.delegate = self
        var menuFrame = UIScreen.main.bounds
        menuFrame.origin.y = 0
        menuFrame.size.height = 55
        topBarMenu.frame = menuFrame
        self.menuHeaderView.addSubview(topBarMenu)
        topBarMenu.MenuList = ["ABOUT","DETAIL","LOCATION"]
        
        
        
    }
    
    func TopBarMenuSelectedIndex(_ index: Int)
    {
        self.navigationItem.rightBarButtonItem = nil
        
        print(index)
        if index == 0 {
            self.tableView.tableFooterView = self.aboutView
        }else if index ==  1 {
            if self.otherCells.count > 0 {
                self.tableView.tableFooterView = self.detailsView
            }else{
                self.tableView.tableFooterView = self.detailsView
                GetSocietyOtherDetails()
            }
            
        }else if index == 2 {
            self.tableView.tableFooterView = self.locationView
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(SocietyViewController.shareLocation))
        }else {
            self.tableView.tableFooterView = self.aboutView
            
        }
    }
    
    //MARK: - About -
    func GetAboutSociety()
    {
        
        let urlStr = String(format: "%@?view=about_society&page=about&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            DispatchQueue.main.async {
                                if let tempStr = ResultData.object(forKey: "description") as? String {
                                    self.lblDesc.text = tempStr
                                }
                                if let tempStr = ResultData.object(forKey: "email") as? String {
                                    self.lblEmail.text = tempStr
                                }
                                if let tempStr = ResultData.object(forKey: "phone") as? String {
                                    self.lblPhone.text = tempStr
                                }
                                if let tempStr = ResultData.object(forKey: "address") as? String {
                                    self.lblAddress.text = tempStr
                                }
                                if let tempStr = ResultData.object(forKey: "latitude") as? String {
                                    if tempStr.isEmpty == false {
                                        self.latitude = Double(tempStr)!
                                    }
                                    
                                }
                                if let tempStr = ResultData.object(forKey: "longitude") as? String {
                                    if tempStr.isEmpty == false {
                                        self.logitude = Double(tempStr)!
                                    }
                                    
                                }
                                var societyName = ""
                                if let tempStr = ResultData.object(forKey: "soc_name") as? String {
                                    societyName = tempStr
                                    self.socityName.text = tempStr
                                }
                                var address = ""
                                if let tempStr = ResultData.object(forKey: "address") as? String {
                                    address = tempStr
                                }
                                self.SetMKMapViewPin(societyName, subTitle: address)
                                
                                
                                
//                                if let tempStr = ResultData.objectForKey("logo_image") as? String {
//                                    if tempStr.isEmpty == false {
//                                        let urlString : NSURL = NSURL(string: tempStr)!
//                                        self.logoImage.clipsToBounds = true
//                                        self.logoImage.sd_setImageWithURL(urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .RetryFailed, completed: { (image, error, type, url) -> Void in
//                                            if image != nil {
//                                                self.logoImage.image = image
//                                            }
//                                            
//                                        })
//                                        
//                                    }
//                                }
                                if let tempStr = ResultData.object(forKey: "default_gray_image") as? String {
                                    if tempStr.isEmpty == false {
                                        let urlString : URL = URL(string: tempStr)!
                                        self.background.clipsToBounds = true
                                        self.background.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                                            if image != nil {
                                                self.background.image = image
                                            }
                                            
                                        })
                                        
                                    }
                                }
                                
                                if let tempStr = ResultData.object(forKey: "background_image") as? String {
                                    if tempStr.isEmpty == false {
                                        let urlString : URL = URL(string: tempStr)!
                                        self.background.clipsToBounds = true
                                        self.background.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                                            if image != nil {
                                                self.background.image = image
                                            }
                                            
                                        })
                                        
                                    }
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
    

    func SetMKMapViewPin(_ title : String , subTitle : String){
        // 1
                let location = CLLocationCoordinate2D(
                    latitude: self.latitude,
                    longitude: self.logitude
                )
                // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView.setRegion(region, animated: true)
//                mapView.delegate = self
        
        
        
      //  3
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = title
                annotation.subtitle = subTitle
                mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view?.canShowCallout = true
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            view?.annotation = annotation
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            let currentCoordinate = mapView.userLocation.location!
            print(currentCoordinate)
            let arrayLocation = [currentCoordinate]
            
            let activityController = UIActivityViewController(activityItems: arrayLocation, applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }
    }
    
    //MARK: - OtherDetails -
    func GetSocietyOtherDetails()
    {
        
        let urlStr = String(format: "%@?view=about_society&page=other_detail&userID=%@&societyID=%@", arguments: [kMainDomainUrl,appDelegate.LoginUserID, appDelegate.SocietyID])
        print(urlStr)
        TNMWSMethod(nil, url: urlStr, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            if succeeded == true {
                //                print(data)
                if let ResultData = data as? NSDictionary{
                    if let msgCode = ResultData.object(forKey: "msgcode") as? String {
                        if msgCode == "0" {
                            if let otherList = ResultData.object(forKey: "other_data") as? NSArray {
                                DispatchQueue.main.async {
                                    self.CreateCell(otherList)
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
    

    func CreateCell(_ resultList : NSArray){
        
        otherCells = NSMutableArray()
        var index : Int = 0
        for data in resultList {
            if let tempData = data as? NSDictionary {
                let cell: SocietyOtherCell! = self.tableViewOther.dequeueReusableCell(withIdentifier: "SocietyOtherCell") as? SocietyOtherCell

                if let tempStr = tempData.object(forKey: "title") as? String {
                    cell.lblName.text = tempStr.capitalized
                }
                if let tempStr = tempData.object(forKey: "value") as? String {
                    cell.lblCount.text = tempStr
                }else {
                    if let tempStr = tempData.object(forKey: "value") as? NSNumber {
                        cell.lblCount.text = tempStr.stringValue
                    }
                }
                
                index = index + 1
                if resultList.count == index {
                    cell.lineView.isHidden = true
                }else{
                    cell.lineView.isHidden = false
                }
                otherCells.add(cell)
                
            }
        }
        DispatchQueue.main.async {
            self.tableViewOther.reloadData()
        }
    }
    //MARK: - TableView Delegate Method
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherCells.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let cell = otherCells.object(at: indexPath.row) as? SocietyOtherCell
        return cell!.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if otherCells.count > indexPath.row {
            if let cell = otherCells.object(at: indexPath.row) as? SocietyOtherCell {
                return cell
            }
        }
        return UITableViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

    @objc func shareLocation() {
        var locationTitle = "WGATE"
        if let tempStr = self.socityName.text {
            locationTitle = tempStr
        }
        
        let coordinate = CLLocationCoordinate2D(
            latitude: self.latitude,
            longitude: self.logitude
        )
        
        guard let cachesPathString = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            print("Error: couldn't find the caches directory.")
            return
        }
        
        let vCardString = [
            "BEGIN:VCARD",
            "VERSION:3.0",
            "N:;\(locationTitle);;;",
            "FN:\(locationTitle)",
            "item1.URL;type=pref:http://maps.apple.com/?ll=\(coordinate.latitude),\(coordinate.longitude)",
            "item1.X-ABLabel:map url",
            "END:VCARD"
            ].joined(separator: "\n")
        
        let vCardFilePath = (cachesPathString as NSString).appendingPathComponent("vCard.loc.vcf")
        
        do {
            try vCardString.write(toFile: vCardFilePath, atomically: true, encoding: String.Encoding.utf8)
            let activityViewController = UIActivityViewController(activityItems: [URL(fileURLWithPath: vCardFilePath)], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print,
                                                            UIActivity.ActivityType.copyToPasteboard,
                                                            UIActivity.ActivityType.assignToContact,
                                                            UIActivity.ActivityType.saveToCameraRoll,
                                                            UIActivity.ActivityType.postToVimeo,
                                                            UIActivity.ActivityType.postToTencentWeibo,
                                                            UIActivity.ActivityType.postToWeibo]
            present(activityViewController, animated: true, completion: nil)
        } catch let error {
            print("Error, \(error), saving vCard: \(vCardString) to file path: \(vCardFilePath).")
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
