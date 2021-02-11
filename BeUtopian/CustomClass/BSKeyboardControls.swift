//
//  BSKeyboardControls.swift
//  bskeyboardcontrols
//
//  Created by Ivan Milles on 09/02/15.
//  Copyright (c) 2015 Mr Green. All rights reserved.
//

import UIKit
import Foundation


enum BSKeyboardControl: UInt8 {
	case allZeros = 0b00
	case previousNext = 0b01
	case done = 0b10
	case allButtons = 0b11		// Needed for pretty weak Swift NSOption support
}

enum BSKeyboardControlsDirection: Int {
	case previous = 0
	case next = 1
}

protocol BSKeyboardControlsDelegate : NSObjectProtocol {
    func keyboardControls(_ keyboardControls: BSKeyboardControls, selectedField field: UIView, inDirection direction: BSKeyboardControlsDirection)
    func keyboardControlsDonePressed(_ keyboardControls: BSKeyboardControls)
}

class BSKeyboardControls: UIView {
	var toolbar: UIToolbar!
	var doneButton: UIBarButtonItem!
	var previousButton: UIBarButtonItem!
	var nextButton: UIBarButtonItem!
	
	var delegate: BSKeyboardControlsDelegate?
	var visibleControls: BSKeyboardControl = .allZeros {
		didSet {
			updateToolbar()
		}
	}
	var fields: [UITextField] = [] {		// TODO: Support for UITextView too
		didSet {
			installOnFields()
		}
	}
	
	var activeField: UITextField? {
		didSet {
			activeField?.becomeFirstResponder()
			updatePreviousNextEnabledStates()
		}
	}
	
	var barStyle: UIBarStyle {
		get {return toolbar.barStyle}
		set {toolbar.barStyle = newValue}
	}
	var barTintColor: UIColor? {
		get {return toolbar.barTintColor}
		set {toolbar.barTintColor = newValue}
	}
	var doneTintColor: UIColor? {
		get {return doneButton.tintColor}
		set {doneButton.tintColor = newValue}
	}
	var doneTitle: String? {
		get {return doneButton.title}
		set {doneButton.title = newValue}
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init(fields: [])
	}
	
	override convenience init(frame: CGRect) {
		self.init(fields: [])
	}
	
	init(fields: [UITextField]) {
		super.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 44.0))
		toolbar = UIToolbar(frame: self.frame)
		barStyle = .default
		toolbar.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
		addSubview(toolbar)
        
//        previousButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "selectPreviousField")
//        nextButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Rewind, target: self, action: "selectNextField")
        
//		previousButton = UIBarButtonItem(image: UIImage(named: "btnPrevious"), style: .Plain, target: self, action: "selectPreviousField")
        previousButton = UIBarButtonItem(title: "", style: .plain, target: self,action: #selector(self.selectPreviousField))
//		nextButton = UIBarButtonItem(image: UIImage(named: "btnNext"), style: .Plain, target: self, action: "selectNextField")
        nextButton = UIBarButtonItem(title: "", style: .plain, target: self, action:#selector(self.selectNextField))
//		doneButton = UIBarButtonItem(image: UIImage(named: "btnDone"), style: .Plain, target: self, action: "doneButtonPressed")
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:#selector(self.doneButtonPressed))
		visibleControls = BSKeyboardControl(rawValue: BSKeyboardControl.previousNext.rawValue | BSKeyboardControl.done.rawValue)!

		self.fields = fields

		// didSet observers not called from init()
		installOnFields()
		updateToolbar()
	}
    
	func installOnFields() {
		for field in fields {
			field.inputAccessoryView = self
		}
	}
	
	func updateToolbar() {
		toolbar.items = toolbarItems() as? [UIBarButtonItem]
	}
	
	func toolbarItems() -> [AnyObject] {
		var outItems = [AnyObject]()

		if visibleControls.rawValue & BSKeyboardControl.previousNext.rawValue > 0 {
			outItems.append(previousButton)
			outItems.append(nextButton)
		}
		
		if visibleControls.rawValue & BSKeyboardControl.done.rawValue > 0 {
			outItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
			outItems.append(doneButton)
		}
        

		return outItems
	}
	
	func updatePreviousNextEnabledStates()
    {
		if let index = fields.index(of: activeField!)
        {
			previousButton.isEnabled = (index > 0)
			nextButton.isEnabled = (index < fields.count - 1)
		}
        
	}
	
    @objc func selectPreviousField()
    {
		if let index = fields.index(of: activeField!)
        {
			if index > 0
            {
				activeField = fields[index - 1]
				delegate?.keyboardControls(self, selectedField: activeField!, inDirection: .previous)
			}
		}
	}

    @objc func selectNextField() {
        print(fields)
		if let index = fields.index(of: activeField!) {
			if index < fields.count - 1 {
				activeField = fields[index + 1]
				delegate?.keyboardControls(self, selectedField: activeField!, inDirection: .next)
			}
		}
	}
	
    @objc func doneButtonPressed() {
		delegate?.keyboardControlsDonePressed(self)
	}
}
