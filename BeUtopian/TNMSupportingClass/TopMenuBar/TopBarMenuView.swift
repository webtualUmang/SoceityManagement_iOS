//
//  TopBarMenuView.swift
//  StretfordEnd
//
//  Created by TNM3 on 6/2/16.
//  Copyright © 2016 shoebpersonal. All rights reserved.
//

import UIKit

protocol TopBarMenuViewDelegate {
    func TopBarMenuSelectedIndex(_ index : Int)
}
class TopBarMenuView: UIView {
    
    var delegate : TopBarMenuViewDelegate?
    
    let leftRightSpace : Int = 10
    var MenuSubView = NSMutableArray()
    
    var selectedIndex : Int = 0
    
    var MenuList : NSArray!{
        didSet{
            SetMenu()
        }
    }
    func SetMenu(){
        
        
        let screenWidth = self.frame.width
        let menuWidth = screenWidth / CGFloat(MenuList.count)
        let menuHeight : CGFloat = self.frame.height - 1
        var xPos : CGFloat = 0

        var index : Int = 0
        for menu in MenuList {
            if let menuStr = menu as? String {
                let topMenuBox = TopMenuBox.instanceFromNib()
                topMenuBox.menuButton.tag = index
                topMenuBox.frame = CGRect(x: xPos, y: 0, width: menuWidth, height: menuHeight)
                xPos = xPos + menuWidth
                
                self.addSubview(topMenuBox)
                topMenuBox.menuButton.setTitle(menuStr, for: UIControl.State())
                topMenuBox.menuButton.addTarget(self, action: #selector(TopBarMenuView.menuButtonClick(_:)), for: .touchUpInside)
                if index == 0 {
                   topMenuBox.menuButton.isSelected = true
                    topMenuBox.menuLine.isHidden = false
                }else{
                    topMenuBox.menuButton.isSelected = false
                    topMenuBox.menuLine.isHidden = true
                }
                
                MenuSubView.add(topMenuBox)
                index += 1
            }
        }
        
    }
    @IBAction func menuButtonClick(_ sender : UIButton){
        if selectedIndex == sender.tag{
            return
        }
        
        for menuView in MenuSubView {
            if let subView = menuView as? TopMenuBox {
                if subView.menuButton.tag == sender.tag {
                    subView.menuButton.isSelected = true
                    subView.menuLine.isHidden = false
                }else{
                    subView.menuButton.isSelected = false
                    subView.menuLine.isHidden = true
                }
            }
        }
        selectedIndex = sender.tag
        
        if delegate != nil {
            delegate?.TopBarMenuSelectedIndex(selectedIndex)
        }
    }
    
    class func instanceFromNib() -> TopBarMenuView {
        return UINib(nibName: "TopBarMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TopBarMenuView
    }
    
    override func awakeFromNib() {
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
