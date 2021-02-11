//
//  AllServiceDetailsViewController.swift
//  BeUtopian
//
//  Created by Nikunj on 06/02/18.
//  Copyright © 2018 tnmmac4. All rights reserved.
//

import UIKit

class AllServiceDetailsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var arrService = NSMutableArray()
    
    var strServiceCatId = ""
    var strTitle = ""
    
    var colorArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         colorArray = [UIColor.init(hexString: "52BE82"), UIColor.init(hexString: "DADFE1"), UIColor.init(hexString: "EC984F"), UIColor.init(hexString: "E9D460"), UIColor.init(hexString: "AEA8D3"), UIColor.init(hexString: "D3674A"), UIColor.init(hexString: "CEC743"), UIColor.init(hexString: "4ECDC4"), UIColor.init(hexString: "E84C3D"), UIColor.init(hexString: "F2C311"), UIColor.init(hexString: "CEC743"), UIColor.init(hexString: "96A4A5"), UIColor.init(hexString: "CEA64F"), UIColor.init(hexString: "E9D460"), UIColor.init(hexString: "D3674A"), UIColor.init(hexString: "C54657"), UIColor.init(hexString: "336E7B"), UIColor.init(hexString: "CEC743"), UIColor.init(hexString: "67BB42"), UIColor.init(hexString: "41B691"), UIColor.init(hexString: "4ECDC4"), UIColor.init(hexString: "C54657"), UIColor.init(hexString: "5C97BF"), UIColor.init(hexString: "52BE82"), UIColor.init(hexString: "E84C3D"), UIColor.init(hexString: "AEA8D3"), UIColor.init(hexString: "D3674A"), UIColor.init(hexString: "81CFE0"), UIColor.init(hexString: "CEA64F"), UIColor.init(hexString: "BE90D4"), UIColor.init(hexString: "52BE82"), UIColor.init(hexString: "DADFE1"), UIColor.init(hexString: "EC984F"), UIColor.init(hexString: "E9D460"), UIColor.init(hexString: "AEA8D3"), UIColor.init(hexString: "D3674A"), UIColor.init(hexString: "CEC743"), UIColor.init(hexString: "4ECDC4"), UIColor.init(hexString: "E84C3D"), UIColor.init(hexString: "F2C311"), UIColor.init(hexString: "CEC743"), UIColor.init(hexString: "96A4A5"), UIColor.init(hexString: "CEA64F"), UIColor.init(hexString: "E9D460"), UIColor.init(hexString: "D3674A"), UIColor.init(hexString: "C54657"), UIColor.init(hexString: "336E7B"), UIColor.init(hexString: "CEC743"), UIColor.init(hexString: "67BB42"), UIColor.init(hexString: "41B691"), UIColor.init(hexString: "4ECDC4"), UIColor.init(hexString: "C54657"), UIColor.init(hexString: "5C97BF"), UIColor.init(hexString: "52BE82"), UIColor.init(hexString: "E84C3D"), UIColor.init(hexString: "AEA8D3"), UIColor.init(hexString: "D3674A"), UIColor.init(hexString: "81CFE0"), UIColor.init(hexString: "CEA64F"), UIColor.init(hexString: "BE90D4")]
        
        let nibName = UINib(nibName: "PopularServiceCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "PopularServiceCell")
        
        self.GetServicesCat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = strTitle
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let right = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .plain, target: self, action: #selector(SearchClick))
        self.navigationItem.rightBarButtonItem = right
    }
    
    @objc func SearchClick(){
        
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let frame = (UIScreen.main.bounds.size.width / 2)
        let height = (frame / 4) * 3
        return CGSize(width: frame, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrService.count > 0 {
            return arrService.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularServiceCell", for: indexPath) as! PopularServiceCell
        
        if colorArray.count > indexPath.row {
            if let color = colorArray.object(at: indexPath.row) as? UIColor {
                cell.bgview.backgroundColor = color
            }
        }
        else{
            
            if colorArray.count > indexPath.row - colorArray.count {
                if let color = colorArray.object(at: indexPath.row - colorArray.count) as? UIColor {
                    cell.bgview.backgroundColor = color
                }
            }
        }
        
        if let tempData = arrService.object(at: indexPath.row) as? NSDictionary {
            
            if let strTemp = tempData.object(forKey: "subservice_name") as? String {
                cell.lblTitle.text = strTemp
            }
            
            if let tempStr = tempData.object(forKey: "name") as? String {
                if tempStr.isEmpty == false {
                     let escapedString = String(format: "%@", arguments: [tempStr.replacingOccurrences(of: " ", with: "%20")])
                    
                    if let urlString : URL = URL(string: escapedString) {
                        cell.imageview.clipsToBounds = true
                        cell.imageview.sd_setImage(with: urlString, placeholderImage: UIImage(named: "homedelightLogo"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                            if image != nil {
                                cell.imageview.image = image
                            }
                        })
                    }
                    
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        if let tempData = arrService.object(at: indexPath.row) as? NSDictionary {
            
            if let strTemp = tempData.object(forKey: "subservice_id") as? String {
                print(strTemp)

                //********** mainDataDics **********
                appDelegate.HomeDelightData.setObject(strTemp, forKey: "service_id" as NSCopying)
                
                let rootObj = PopularServicesDetailsViewcontroller(nibName: "PopularServicesDetailsViewcontroller", bundle: nil)
                rootObj.strServiceId = strTemp
                self.navigationController?.pushViewController(rootObj, animated: true)
            }
        }
    }
    
    //MARK: - GetServicesCat
    
    func GetServicesCat(){
        
//        let urlStr = String(format: "%@?service_id=%@", arguments: [kGetServicesCat,strServiceCatId])
//        print(urlStr)
        
        let data = ["service_id":strServiceCatId]
        
        TNMWSMethod(data as AnyObject, url: kGetServicesCat, isMethod: kPostMethod, AuthToken: "", viewController: self) { (succeeded, data) -> () in
            
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
