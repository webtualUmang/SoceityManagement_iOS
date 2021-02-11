//
//  DeskBoardHeaderView.swift
//  BeUtopian
//
//  Created by Jeevan on 20/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class DeskBoardHeaderView: UICollectionReusableView {

    @IBOutlet var imagePager: KIImagePager!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.imagePager = KIImagePager(frame: self.bounds)
////        self.imagePager.dataSource = self
//        
//        imagePager.slideshowTimeInterval = 5
//        imagePager.imageCounterDisabled = true
////        imagePager.dataSource = self
//        imagePager.delegate = self
//        let slider = ImageSliderView.instanceFromNib()
//        slider.frame = self.frame
//        self.addSubview(slider)
        
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

    func arrayWithImages(_ pager: KIImagePager!) -> [AnyObject]! {
        return ["https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png" as AnyObject,"https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png" as AnyObject]
    }
//    func arrayWithImages(pager: KIImagePager) -> NSArray
//    {
////        if(ArrayOfImages?.count > 0)
////        {
////            return ArrayOfImages!
////        }
//        return ["https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png","https://raw.github.com/kimar/tapebooth/master/Screenshots/Screen2.png"]
//    }
    func imagePager(_ imagePager: KIImagePager!, didScrollToIndex index: UInt)
    {
        //        print("\(__PRETTY_FUNCTION__) \(UInt(index))")
    }
    func imagePager(_ imagePager: KIImagePager!, didSelectImageAtIndex index: UInt)
    {
        //        print("\(__PRETTY_FUNCTION__) \(UInt(index))")
        
    }
    
}
