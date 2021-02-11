//
//  AllServiceViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 10/01/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class AllServiceViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var arrService = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nibName = UINib(nibName: "HomeDelightCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "HomeDelightCell")
        
        self.GetService()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let frame = (UIScreen.main.bounds.size.width / 2) - 3
        return CGSize(width: frame, height: frame)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrService.count > 0 {
            return arrService.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeDelightCell", for: indexPath) as! HomeDelightCell
        
        if let tempData = arrService.object(at: indexPath.row) as? NSDictionary {

            if let strTemp = tempData.object(forKey: "service_name") as? String {
                cell.lblTitle.text = strTemp
            }

            if let tempStr = tempData.object(forKey: "banner_image_url") as? String {
                if tempStr.isEmpty == false {
                    let urlString : URL = URL(string: kImageUrl + tempStr)!
                    cell.imageview.clipsToBounds = true
                    cell.imageview.sd_setImage(with: urlString, placeholderImage: UIImage(named: "homedelightLogo"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                        if image != nil {
                            cell.imageview.image = image
                        }
                    })
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        let rootObj = AllServiceDetailsViewController(nibName: "AllServiceDetailsViewController", bundle: nil)
        
        if let tempData = arrService.object(at: indexPath.row) as? NSDictionary {
            
            var mainServiceId = ""
            var Servicename = ""
         
            if let strTemp = tempData.object(forKey: "service_id") as? String {
                rootObj.strServiceCatId = strTemp
                mainServiceId = strTemp
            }
            if let strTemp = tempData.object(forKey: "service_name") as? String {
                rootObj.strTitle = strTemp
                Servicename = strTemp
            }
            
            //********** mainDataDics **********
            appDelegate.HomeDelightData.setObject("", forKey: "booking_id" as NSCopying)
            appDelegate.HomeDelightData.setObject(mainServiceId, forKey: "mainService_id" as NSCopying)
            appDelegate.HomeDelightData.setObject(Servicename, forKey: "service_name" as NSCopying)
        }
        self.navigationController?.pushViewController(rootObj, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! HomeDelightCell
//        cell.imageview.backgroundColor = UIColor.gray
    }
    
    //MARK: - GetService
    
    func GetService(){
        
        TNMWSMethod(nil, url: kGetServices, isMethod: kGetMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in

            if succeeded == true {
                print(data)
                DispatchQueue.main.async {
                    self.self.arrService = NSMutableArray()
                    if let datas = data as? NSArray {
                        self.arrService = NSMutableArray(array: datas)
                    }
                    self.collectionView.reloadData()
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
