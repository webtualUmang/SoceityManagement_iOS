//
//  HelpViewController.swift
//  synax
//
//  Created by TNM3 on 6/14/16.
//  Copyright © 2016 TNM3. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var btnNext : UIButton!
    @IBOutlet weak var collectionView:UICollectionView!
    
    
    var totalPages = 4
    
    //    let sampleBGColors: Array<UIColor> = [UIColor.redColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.magentaColor(), UIColor.orangeColor()]
    
    let helpImage: Array<String> = ["001","002","003","004"]
    
    let data = [["title":"Move Towards Paperless Office","desc":"Document storage, e-invoices & receipts, e-notice & discussion, SMS alert, reminders and many more features for paperless Society management system","image":"splash1"],["title":"Maintain Complete Documentation","desc":"Managing and organizing documents is never easy but by using W-Gate app, all of your records will be right at your fingertips.","image":"splash2"],["title":"Cost vs. Value","desc":"Use our app like professional management to save lot of time, efforts and money. It ultimately helps to create happy living community.","image":"splash3"],["title":"Support and Training","desc":"Get full support with Live demo and training from our team to understand, implement and manage your society with W-Gate app.","image":"splash4"]]
    
    @IBAction func closeClick(_ sender : AnyObject){
        //        self.navigationController?.popFadeViewController()
        self.dismiss(animated: true) { () -> Void in
            //            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds
        // Do any additional setup after loading the view.
        
        self.configureScrollView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    //    override func prefersStatusBarHidden() -> Bool {
    //        return false
    //    }
    // MARK: Custom method implementation
    
    func configureScrollView()
    {
        totalPages = self.data.count
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = 0
    }
    
    
    // MARK: UIScrollViewDelegate method implementation
    
    //  func scrollViewDidScroll(_ scrollView: UIScrollView)
    // {
    // Calculate the new page index depending on the content offset.
    //    let currentPage = floor(scrollView.contentOffset.x / UIScreen.main.bounds.size.width);
    
    // Set the new page index to the page control.
    //  pageControl.currentPage = Int(currentPage)
    //   if pageControl.currentPage >= 3 {
    //       self.btnNext.setTitle("GOT IT", for: UIControl.State())
    //   }else{
    //      self.btnNext.setTitle("NEXT", for: UIControl.State())
    
    //   }
    //   print(pageControl.currentPage)
    //}
    //    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    //
    //        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    //        pageControl.currentPage = Int(pageNumber)
    //    }
    
    // MARK: IBAction method implementation
    
    
    @IBAction func nextClick(_ sender : AnyObject)
    {
        
        print(pageControl.currentPage)
        //  var newFrame = scrollView.frame
        //  newFrame.origin.x = newFrame.size.width * CGFloat(pageControl.currentPage + 1)
        let cout = self.collectionView.indexPathsForVisibleItems.count
        if cout > 0
        {
        var indexpath = self.collectionView.indexPathsForVisibleItems[0] as? IndexPath ?? IndexPath(row:0, section: 0)
        
        if indexpath.row == 3
        {
            self.btnNext.setTitle("GOT IT", for: UIControl.State())
            let objRoot: VerifyMobileViewController = VerifyMobileViewController(nibName: "VerifyMobileViewController", bundle: nil)
          
            
            self.navigationController?.pushViewController(objRoot, animated: true)
            
        }else
        {
            self.btnNext.setTitle("NEXT", for: UIControl.State())
            self.collectionView.scrollToItem(at:NSIndexPath(row:indexpath.row + 1, section:0) as IndexPath, at: .centeredHorizontally, animated: false)
        }
        }
        
    }
    @IBAction func skipClick(_ sender : AnyObject)
    {
        let objRoot: VerifyMobileViewController = VerifyMobileViewController(nibName: "VerifyMobileViewController", bundle: nil)
        
        self.navigationController?.pushViewController(objRoot, animated: true)
    }
    
    var mainDataDics = NSMutableDictionary()
    
    func SetData(){
        
        //********** mainDataDics **********
        mainDataDics.setObject("", forKey: "booking_id" as NSCopying)
        mainDataDics.setObject("8", forKey: "mainService_id" as NSCopying)
        mainDataDics.setObject("44", forKey: "service_id" as NSCopying)
        mainDataDics.setObject("Electrician", forKey: "service_name" as NSCopying)
        mainDataDics.setObject("", forKey: "SpecialInstructions" as NSCopying)
        
        //********** userDataDics **********
        let userDataDics = NSMutableDictionary()
        userDataDics.setObject("135", forKey: "user_id" as NSCopying)
        userDataDics.setObject("Jeevan", forKey: "user_name" as NSCopying)
        userDataDics.setObject("123456", forKey: "password" as NSCopying)
        userDataDics.setObject("Jeevan", forKey: "first_name" as NSCopying)
        userDataDics.setObject("Jeevan", forKey: "last_name" as NSCopying)
        userDataDics.setObject("jiven@beutopian.com", forKey: "email" as NSCopying)
        userDataDics.setObject("2016-09-15", forKey: "birth_date" as NSCopying)
        userDataDics.setObject("http://sms.thewebtual.com/images/user_profile_images/profile_1507094937_17-37-15-images.jpg", forKey: "image_url" as NSCopying)
        userDataDics.setObject("8000993047", forKey: "mobileno" as NSCopying)
        userDataDics.setObject("", forKey: "address" as NSCopying)
        userDataDics.setObject("", forKey: "house_no_street" as NSCopying)
        userDataDics.setObject("", forKey: "landmark" as NSCopying)
        userDataDics.setObject("", forKey: "postcode" as NSCopying)
        userDataDics.setObject("", forKey: "user_city" as NSCopying)
        userDataDics.setObject("", forKey: "user_state" as NSCopying)
        userDataDics.setObject("", forKey: "user_country" as NSCopying)
        userDataDics.setObject("", forKey: "role_id" as NSCopying)
        userDataDics.setObject("", forKey: "fb_id" as NSCopying)
        userDataDics.setObject("", forKey: "google_id" as NSCopying)
        userDataDics.setObject("", forKey: "status" as NSCopying)
        userDataDics.setObject("", forKey: "agreement" as NSCopying)
        userDataDics.setObject("", forKey: "pan_card" as NSCopying)
        userDataDics.setObject("", forKey: "id_proof" as NSCopying)
        userDataDics.setObject("", forKey: "police_verification" as NSCopying)
        userDataDics.setObject("", forKey: "address_proof" as NSCopying)
        userDataDics.setObject("", forKey: "vendor_reg_form" as NSCopying)
        userDataDics.setObject("", forKey: "pan_number" as NSCopying)
        userDataDics.setObject("", forKey: "account_holder_name" as NSCopying)
        userDataDics.setObject("", forKey: "bank_account_number" as NSCopying)
        userDataDics.setObject("", forKey: "bank_name" as NSCopying)
        userDataDics.setObject("", forKey: "bank_branch" as NSCopying)
        userDataDics.setObject("", forKey: "ifsc_code" as NSCopying)
        userDataDics.setObject("", forKey: "account_type" as NSCopying)
        userDataDics.setObject("", forKey: "sharingpercent" as NSCopying)
        userDataDics.setObject("", forKey: "due" as NSCopying)
        userDataDics.setObject("", forKey: "experiance" as NSCopying)
        userDataDics.setObject("", forKey: "serviceable_area" as NSCopying)
        userDataDics.setObject("", forKey: "device_id" as NSCopying)
        userDataDics.setObject("ios", forKey: "mobile_type" as NSCopying)
        userDataDics.setObject("", forKey: "job_status" as NSCopying)
        userDataDics.setObject("2016-06-07 12:17:41", forKey: "created_date" as NSCopying)
        userDataDics.setObject("", forKey: "modified_date" as NSCopying)
        
        mainDataDics.setObject(userDataDics, forKey: "userData" as NSCopying)
        
        //********** serviceTypeArray **********
        let serviceTypeArray = NSMutableArray()
        let serviceTypeDics = NSMutableDictionary()
        
        serviceTypeDics.setObject("168", forKey: "sub_service_id" as NSCopying)
        serviceTypeDics.setObject("Wiring", forKey: "text" as NSCopying)
        serviceTypeDics.setObject("99", forKey: "price" as NSCopying)
        serviceTypeDics.setObject("1", forKey: "checked" as NSCopying)
        
        serviceTypeArray.add(serviceTypeDics)
        
        mainDataDics.setObject(serviceTypeArray, forKey: "serviceTypeObj" as NSCopying)
        
        //********** selectTimeSlotDataDics **********
        let selectTimeSlotDataDics = NSMutableDictionary()
        
        selectTimeSlotDataDics.setObject("1", forKey: "id" as NSCopying)
        selectTimeSlotDataDics.setObject("12:00 to 14:00", forKey: "time" as NSCopying)
        selectTimeSlotDataDics.setObject("1", forKey: "checked" as NSCopying)
        
        mainDataDics.setObject(selectTimeSlotDataDics, forKey: "selectedTimeSlotObj" as NSCopying)
        
        //********** selectDateOrderDataDics **********
        let selectDateOrderDataDics = NSMutableDictionary()
        
        selectDateOrderDataDics.setObject("2017-10-13", forKey: "dateObj" as NSCopying)
        selectDateOrderDataDics.setObject("13", forKey: "day" as NSCopying)
        selectDateOrderDataDics.setObject("Oct", forKey: "monthName" as NSCopying)
        selectDateOrderDataDics.setObject("Fri", forKey: "dayName" as NSCopying)
        
        mainDataDics.setObject(selectDateOrderDataDics, forKey: "selectedDateOrderObj" as NSCopying)
        
        //********** selectedUserAddress **********
        let selectedUserAddress = NSMutableDictionary()
        
        selectedUserAddress.setObject("6837", forKey: "id" as NSCopying)
        selectedUserAddress.setObject("135", forKey: "user_id" as NSCopying)
        selectedUserAddress.setObject("Akole", forKey: "location" as NSCopying)
        selectedUserAddress.setObject("Pune", forKey: "street_area" as NSCopying)
        selectedUserAddress.setObject("Akole2", forKey: "landmark" as NSCopying)
        selectedUserAddress.setObject("Ahmedabad", forKey: "city_name" as NSCopying)
        selectedUserAddress.setObject("", forKey: "state_name" as NSCopying)
        selectedUserAddress.setObject("111122", forKey: "pincode" as NSCopying)
        selectedUserAddress.setObject("0", forKey: "isDeleted" as NSCopying)
        selectedUserAddress.setObject("2017-09-09 11:12:53", forKey: "created_date" as NSCopying)
        selectedUserAddress.setObject("", forKey: "modified_date" as NSCopying)
        selectedUserAddress.setObject("8000993047", forKey: "mobileno" as NSCopying)
        selectedUserAddress.setObject("1", forKey: "checked" as NSCopying)
        
        mainDataDics.setObject(selectedUserAddress, forKey: "selectedUserAddressObj" as NSCopying)
        
        print(mainDataDics)
        
        TNMWSMethod([mainDataDics] as AnyObject, url: "http://sms.thewebtual.com/webservice/bookService", isMethod: kPostMethod, AuthToken: "", viewController: self) { (success, response) in
            print(success)
            print(response)
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
extension HelpViewController : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as! pageCell
        cell.setDetails(dic:self.data[indexPath.row] as? NSDictionary ?? [:])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        self.pageControl.currentPage = indexPath.row
        if pageControl.currentPage >= 3
        {
            self.btnNext.setTitle("GOT IT", for: UIControl.State())
            
            
        }else{
            self.btnNext.setTitle("NEXT", for: UIControl.State())
            
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        DispatchQueue.main.async
            {
                if self.collectionView.indexPathsForVisibleItems.count > 0
                {
                    let indexpath = self.collectionView.indexPathsForVisibleItems[0]
                    
                     self.pageControl.currentPage = indexpath.row
                }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width:collectionView.frame.width
            , height: collectionView.frame.height)
        
    }
    
}
class pageCell: UICollectionViewCell
{
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var imgSplash:UIImageView!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    func setDetails(dic:NSDictionary)
    {
        
        self.imgSplash.image = UIImage(named:dic["image"] as? String ?? "")
        self.imgSplash.contentMode = .scaleAspectFill
        self.imgSplash.backgroundColor = .clear
        
        self.lblDesc.text = dic["desc"] as? String ?? ""
        self.lblTitle.text = dic["title"] as? String ?? ""
        
    }
    
    
}
