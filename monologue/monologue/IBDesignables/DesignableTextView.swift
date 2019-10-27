
//
//  APTextView.swift
//  TextViewPlaceholder
//
//  Created by Ziyuan Xiao on 22/10/19.
//  Copyright © 2019 Ziyuan Xiao. All rights reserved.
//
//  This file would create a reusable text view for the UI part.
//  This text view would have the place holder text paramater and custom place holder text color.

import Foundation
import UIKit

@objc protocol APTextViewDelegate {
    @objc optional func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    @objc optional func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    @objc optional func textViewDidBeginEditing(_ textView: UITextView)
    @objc optional func textViewDidEndEditing(_ textView: UITextView)
    @objc optional func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    @objc optional func textViewDidChange(_ textView: UITextView)
    @objc optional func textViewDidChangeSelection(_ textView: UITextView)
    @objc optional func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    @objc optional func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

@IBDesignable
class APTextView : UITextView, UITextViewDelegate {
    
    var defaultPlaceholderText = ""
    var defaultPlaceholderColor = UIColor.red.withAlphaComponent(0.5)
    var defaultTextColor = UIColor.darkText
    var customTextViewDelegate : APTextViewDelegate?
    
    @IBInspectable var PlaceholderText : String {
        get{
            return self.defaultPlaceholderText
        }
        set{
            self.defaultPlaceholderText = newValue
        }
    }
// set color of place holder text
    @IBInspectable var PlaceholderColor : UIColor {
        get{
            return self.defaultPlaceholderColor
        }
        set{
            self.defaultPlaceholderColor = newValue
        }
    }
    
    @IBInspectable var TextViewTextColor : UIColor {
        get{
            return self.defaultTextColor
        }
        set{
            self.defaultTextColor = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.managePlaceholder()
        }
    }
    
    
    func managePlaceholder() {
        
        self.delegate = self
        if self.text.isEmpty {
            self.text = self.defaultPlaceholderText
            self.textColor = self.defaultPlaceholderColor
        }
        else {
            self.textColor = self.defaultTextColor
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    //MARK: - Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.defaultPlaceholderText {
            textView.text = ""
            textView.textColor = self.defaultTextColor
        }
        
        self.customTextViewDelegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.defaultPlaceholderText
            textView.textColor = self.defaultPlaceholderColor
        }
        
        self.customTextViewDelegate?.textViewDidEndEditing?(textView)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return self.customTextViewDelegate?.textViewShouldBeginEditing?(textView) ?? true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return self.customTextViewDelegate?.textViewShouldEndEditing?(textView) ?? true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return self.customTextViewDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.customTextViewDelegate?.textViewDidChange?(textView)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        self.customTextViewDelegate?.textViewDidChangeSelection?(textView)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.customTextViewDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.customTextViewDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? false
    }
}
