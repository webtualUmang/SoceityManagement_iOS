//
//  ImageSliderView.swift
//  BeUtopian
//
//  Created by TNM3 on 12/21/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class ImageSliderView: KIImagePager, KIImagePagerDelegate, KIImagePagerDataSource {

    // @IBOutlet var imagePager: KIImagePager!
    var imageUrls : NSArray?{
        didSet{
             
            self.reloadData()
        }
    }
    
    class func instanceFromNib() -> ImageSliderView {
        return UINib(nibName: "ImageSliderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ImageSliderView
    }
    
    override func awakeFromNib() {
        //self.imagePager = KIImagePager(frame: self.bounds)
        //        self.imagePager.dataSource = self
        
        self.slideshowTimeInterval = 5
        self.imageCounterDisabled = true
        self.dataSource = self
        //imagePager.delegate = self
        
        self.delegate = self
        
    }
    
    func contentMode(forImage image: UInt, in pager: KIImagePager!) -> UIView.ContentMode {
        return .scaleToFill
    }
    
    //    func contentModeForImage(image: Int, inPager pager: KIImagePager) -> UIViewContentMode
    //    {
    //        return .ScaleAspectFill
    //    }
    //    func contentModeForPlaceHolder(pager: KIImagePager!) -> UIViewContentMode {
    //
    //    }
    
    //    - (UIImage *) placeHolderImageForImagePager:(KIImagePager*)pager;
    //    - (NSString *) captionForImageAtIndex:(NSUInteger)index  inPager:(KIImagePager*)pager;
    //    - (UIViewContentMode) contentModeForPlaceHolder:(KIImagePager*)pager;
    
    //    func placeHolderImageForImagePager(pager: KIImagePager!) -> UIImage! {
    //
    //    }
    //    func captionForImageAtIndex(index: UInt, inPager pager: KIImagePager!) -> String! {
    //
    //    }
    func placeHolderImage(for pager: KIImagePager!) -> UIImage! {
        return UIImage(named: "navigate_background")
    }
//    func array(withImages pager: KIImagePager!) -> [AnyObject]! {
////        print(imageUrls)
//        if let tempArray = imageUrls as [AnyObject]? {
//            return tempArray
//        }
//        return ["https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png" as AnyObject]
//    }
    func array(withImages pager: KIImagePager!) -> [Any]! {
        if let tempArray = imageUrls as [AnyObject]? {
            return tempArray
        }
        return ["https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png" as AnyObject]
    }
    //    func arrayWithImages(pager: KIImagePager) -> NSArray
    //    {
    ////        if(ArrayOfImages?.count > 0)
    ////        {
    ////            return ArrayOfImages!
    ////        }
    //        return ["https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png","https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png"]
    //    }
    func imagePager(_ imagePager: KIImagePager!, didScrollTo index: UInt)
    {
        //        print("\(__PRETTY_FUNCTION__) \(UInt(index))")
    }
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAt index: UInt)
    {
        //        print("\(__PRETTY_FUNCTION__) \(UInt(index))")
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
