//
//  FontsDisplayViewController.swift
//  Fonts
//
//  Created by Saksham Ram Khatod on 04/04/20.
//  Copyright © 2020 Saksham Ram Khatod. All rights reserved.
//

import Cocoa

class FontsDisplayViewController: NSViewController {
    
    @IBOutlet var fontsTextView: NSTextView!
    
    var fontFamily: String?
    var fontFamilyMembers = [[Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
    }
    
    override func viewDidAppear() {
        showFonts()
    }
    
    func setupTextView() {
        fontsTextView.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        fontsTextView.enclosingScrollView?.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        fontsTextView.isEditable = false
        fontsTextView.enclosingScrollView?.autohidesScrollers = true
    }
    
    func showFonts() {
        guard let fontFamily = fontFamily else { return }
        var fontPostScriptNames = ""
        var lengths = [Int]()
        
        for member in fontFamilyMembers {
            if let postScript = member[1] as? String {
                fontPostScriptNames += "\(postScript)\n"
                lengths.append(postScript.count)
            }
        }
        
        let attributedString = NSMutableAttributedString(string: fontPostScriptNames)
        
        for (index, member) in fontFamilyMembers.enumerated() {
            if let weight = member[2] as? Int, let traits = member[3] as? UInt {
                if let font = NSFontManager.shared.font(withFamily: fontFamily, traits: NSFontTraitMask(rawValue: traits), weight: weight, size: 19.0) {
                    
                    var location = 0
                    if index > 0 {
                        for i in 0..<index {
                            location += lengths[i] + 1
                        }
                    }
                    
                    let range = NSMakeRange(location, lengths[index])
                    
                    attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
                    
                }
            }
        }
        
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: NSColor.white, range: NSMakeRange(0, attributedString.string.count))
        
        fontsTextView.textStorage?.setAttributedString(attributedString)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        view.window?.close()
    }
    
}
