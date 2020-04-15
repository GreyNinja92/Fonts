//
//  ViewController.swift
//  Fonts
//
//  Created by Saksham Ram Khatod on 04/04/20.
//  Copyright © 2020 Saksham Ram Khatod. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var fontFamiliesPopUp: NSPopUpButton!
    @IBOutlet weak var fontTypePopUp: NSPopUpButton!
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var button: NSButton!
    
    var selectedFontFamily: String?
    var fontFamilyMembers = [[Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateFontFamilies()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func setupUI() {
        fontFamiliesPopUp.removeAllItems()
        fontTypePopUp.removeAllItems()
        label.stringValue = ""
        label.alignment = .center
    }
    
    func populateFontFamilies() {
        fontFamiliesPopUp.removeAllItems()
        fontFamiliesPopUp.addItems(withTitles: NSFontManager.shared.availableFontFamilies)
        
        handleFontFamilySelection(self)
    }
    
    func updateFontTypesPopup() {
        fontTypePopUp.removeAllItems()

        for item in fontFamilyMembers {
            if let fontType = item[1] as? String {
                fontTypePopUp.addItem(withTitle: fontType)
            }
        }
        handleFontTypeSelection(self)
    }
    
    @IBAction func handleFontFamilySelection(_ sender: Any) {
        if let fontFamily = fontFamiliesPopUp.titleOfSelectedItem {
            selectedFontFamily = fontFamily
            
            if let members = NSFontManager.shared.availableMembers(ofFontFamily: fontFamily) {
                fontFamilyMembers.removeAll()
                fontFamilyMembers = members
                
                view.window?.title = fontFamily
                updateFontTypesPopup()
            }
        }
    }
    
    @IBAction func handleFontTypeSelection(_ sender: Any) {
        let selectedMember = fontFamilyMembers[fontTypePopUp.indexOfSelectedItem]
        
        if let postScriptName = selectedMember[0] as? String,
            let weight = selectedMember[2] as? Int,
        let traits = selectedMember[3] as? UInt,
            let fontFamily = selectedFontFamily {
            
            let font = NSFontManager.shared.font(withFamily: fontFamily, traits: NSFontTraitMask(rawValue: traits), weight: weight, size: 19.0)
            
            label.font = font
            label.stringValue = postScriptName
        }
        
    }
    
    @IBAction func displayAllFonts(_ sender: Any) {
        let storyBoardName = NSStoryboard.Name(stringLiteral: "Main")
        let storyBoard = NSStoryboard(name: storyBoardName, bundle: nil)

        let storyboardID = NSStoryboard.SceneIdentifier(stringLiteral: "fontsDisplayStoryboardID")
        if let fontsDisplayViewController = storyBoard.instantiateController(withIdentifier: storyboardID) as? NSWindowController {

            if let fontsDisplayVC = fontsDisplayViewController.contentViewController as? FontsDisplayViewController {
                fontsDisplayVC.fontFamily = selectedFontFamily
                fontsDisplayVC.fontFamilyMembers = fontFamilyMembers
            }

            fontsDisplayViewController.showWindow(nil)

        }

    }
    
}

