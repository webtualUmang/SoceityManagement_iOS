//
//  LostFoundDetailsVC.swift
//  BeUtopian
//
//  Created by Rajesh Jain on 22/08/20.
//  Copyright © 2020 tnmmac4. All rights reserved.
//

import UIKit

class LostFoundDetailsVC: UIViewController
{
     @IBOutlet weak var lblTitle:UILabel!
       @IBOutlet weak var lblDic:UILabel!
       @IBOutlet weak var lblStatus:UILabel!
       @IBOutlet weak var lblMobile:UILabel!
    @IBOutlet weak var imgPost:UIImageView!
    @IBOutlet weak var activity:UIActivityIndicatorView!
    @IBOutlet weak var heightImage:NSLayoutConstraint!

    var dicData = NSDictionary()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setdata()
        // Do any additional setup after loading the view.
    }
    
    func setdata()
    {
        self.imgPost.clipsToBounds = true
        let photo = self.dicData["photo"] as? String ?? ""
        if !photo.isEmpty
        {
            self.heightImage.constant =  UIScreen.main.bounds.size.width * 0.4
            let urlString : URL = URL(string: "http://wgate.thewebtual.com/uploads/lostfound/" + "\(photo)")!
            self.activity.startAnimating()
            self.imgPost!.sd_setImage(with:urlString, placeholderImage: UIImage(named: "default_gray_image"), options:.retryFailed, completed: { (image, error, type, url) -> Void in
                self.activity.stopAnimating()

                                       if image != nil
                                       {
                                        self.activity.stopAnimating()

                                            self.imgPost.image = image
                                        self.imgPost.contentMode = .scaleAspectFill

                                       }
                else
                                       {
                                        self.activity.stopAnimating()

                }
                                       
                                   })
        }
        else
        {
             self.heightImage.constant = 0
            self.activity.stopAnimating()
        }
        
        self.lblTitle.text = dicData["item_name"] as? String ?? ""
        self.lblDic.text = dicData["description"] as? String ?? ""
        if dicData["isclosed"] as? String ?? "" == "0"
        {
            self.lblStatus.text = "Open"

        }
        else
        {
            self.lblStatus.text = "Close"

        }
        self.lblMobile.text = dicData["mobile"] as? String ?? ""
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
