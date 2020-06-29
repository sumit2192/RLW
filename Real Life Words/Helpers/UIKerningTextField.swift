//
//  UIKerningTextField.swift
//  Rumble
//
//  Created by apple on 17/02/20.
//  Copyright © 2020 Invito Software Solutions LLP. All rights reserved.
//

import UIKit

   /* @IBDesignable*/ class UIKerningTextField : UITextField {
        
        var indexPath : IndexPath!
        var Tagg : Int!
        var name:String!
                
    @IBInspectable
    var placeHolderColor1: UIColor? {
        get {
            return .black
        }
        set {
            if let color = newValue {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: color])
                
            } else {
                layer.shadowColor = nil
            }
        }
    }

        
        @IBInspectable var kerningValue : CGFloat = 3.0 {
            didSet {
                self.configureAttributedText()
            }
        }
        
        override init(frame: CGRect) {
            
            super.init(frame: frame)
            didLoad()
        }
        
        required init?(coder aDecoder: NSCoder) {
            
            super.init(coder: aDecoder)
            didLoad()
        }
        
        override public var text: String? {
            didSet {
                self.configureAttributedText()
            }
        }
        
        func didLoad() {
            self.addTarget(self, action: #selector(UIKerningTextField.configureAttributedText as (UIKerningTextField) -> () -> ()), for: .editingChanged)
            
            self.addTarget(self, action: #selector(UIKerningTextField.configureAttributedText as (UIKerningTextField) -> () -> ()), for: .valueChanged)
        }
        
        @objc func configureAttributedText () {
            let text: String = self.attributedText?.string ?? self.text ?? ""
//            let fontSize = self.font?.pointSize ?? 13.0
//            let fontName = self.font?.fontName ?? UIFont.systemFont(ofSize: fontSize).fontName
//            let fontColor = self.textColor ?? UIColor.black
//            
//            let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            
            let attributedText =  NSAttributedString(string: text, attributes: [NSAttributedString.Key.kern:self.kerningValue])
            
            self.attributedText = attributedText
        }
        
        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
        }
    }



