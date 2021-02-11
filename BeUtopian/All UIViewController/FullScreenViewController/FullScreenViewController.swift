//
//  FullScreenViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 12/5/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class FullScreenViewController: UIViewController {

    @IBOutlet var activity : UIActivityIndicatorView!
    @IBOutlet var imageview : UIImageView!
    var resultData : String?
     var angle: CGFloat?
    var strURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.SetFullScreenImage()
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = NSTheme().GetNavigationTitleColor()
        
        
        let left = UIBarButtonItem(image: UIImage(named: "ac_title_left"), style: .plain, target: self, action:#selector(self.backClick(_:)))
        self.navigationItem.leftBarButtonItem = left
        
        let right = UIBarButtonItem(image: UIImage(named: "more_icon"), style: .plain, target: self, action:#selector(self.onNavButtonTapped(_:event:)))
        self.navigationItem.rightBarButtonItem = right
        
        if let gettag = UserDefaults.standard.object(forKey: "Rotate") as? CGFloat {
            
            self.imageview.transform = CGAffineTransform(rotationAngle: gettag)
//            self.imageview.frame = CGRectMake(0, self.imageview.frame.origin.y, frames.width, frames.width)
        }
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
//    override func viewDidDisappear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
//    }
    @IBAction func backClick(_ sender : AnyObject){
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    @objc func onNavButtonTapped(_ sender: UIBarButtonItem, event: UIEvent) {
        
        FTPopOverMenu.show(from: event, withMenu: ["Share","Rotate"], imageNameArray: nil, doneBlock: { (selectedIndex) -> Void in
            
            if(selectedIndex == 0){
//                let shareList: NSArray = [self.strURL!, self.imageview.image!]

                let shareList: NSArray = [self.imageview.image!]
                let sharePicker = UIActivityViewController(activityItems: shareList as [AnyObject], applicationActivities: [])
                
                self.present(sharePicker, animated: true, completion: { () -> Void in
                    
                })
            }
            else if(selectedIndex == 1){
                
                    let gettag = UserDefaults.standard.object(forKey: "Tag") as? String
                    
                    if gettag == "1" {
                        self.angle = 90 * (CGFloat(M_PI) / 180.0)
                        // btn.tag = 2
                        UserDefaults.standard.set("2", forKey: "Tag")
                    }
                    else if gettag == "2" {
                        self.angle = 180 * (CGFloat(M_PI) / 180.0)
                        //btn.tag = 3
                        UserDefaults.standard.set("3", forKey: "Tag")
                    }
                    else if gettag == "3" {
                        self.angle = 270 * (CGFloat(M_PI) / 180.0)
                        // btn.tag = 4
                        UserDefaults.standard.set("4", forKey: "Tag")
                    }
                    else if gettag == "4" {
                        self.angle = 360 * (CGFloat(M_PI) / 180.0)
                        // btn.tag = 1
                        UserDefaults.standard.set("1", forKey: "Tag")
                    }
                    else {
                        self.angle = 90 * (CGFloat(M_PI) / 180.0)
                        // btn.tag = 2
                        UserDefaults.standard.set("2", forKey: "Tag")
                    }
                    
                    UserDefaults.standard.set(self.angle, forKey: "Rotate")
//                    let frames = UIScreen.mainScreen().bounds.size
                    self.imageview.transform = CGAffineTransform(rotationAngle: self.angle!)
//                    self.imageview.frame = CGRectMake(0, self.imageview.frame.origin.y, frames.width, frames.width)
            }
            
            }) { () -> Void in
                
        }
    }
   
    
    func SetFullScreenImage(){
        self.activity.isHidden = false
        self.activity.startAnimating()
        
        if let resultUrl = self.resultData
        {
            if resultUrl.isEmpty == false
            {
                let urlString : URL = URL(string: resultUrl)!
                self.imageview.clipsToBounds = true
                self.imageview.sd_setImage(with: urlString, placeholderImage: UIImage(named: "default_gray_image"), options: .retryFailed, completed: { (image, error, type, url) -> Void in
                    if image != nil {
                        self.strURL = resultUrl
                        self.imageview.image = image
                    }
                    self.activity.isHidden = true
                    self.activity.stopAnimating()
                })
                
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
