//
//  Extension.swift
//  PorpertyMgr
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import IQKeyboardManager
import UIKit
import VisualEffectView

extension UIView{
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addBlurEffect() {
        
        let blurEffect : UIBlurEffect
        if #available(iOS 13.0, *) {
             blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialLight)
        } else {
            // Fallback on earlier versions
            blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        }
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    func addSahadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.masksToBounds = false
    }
    
    func roundCornerWith(color:UIColor){
        self.layer.cornerRadius = self.frame.height * 0.5
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.purple.cgColor]
        gradient.opacity = 1.0 // change for intensity
        self.layer.insertSublayer(gradient, at: 0)
        //self.layer.addSublayer(gradient)
    }
    
    func addHazyGradient(){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [#colorLiteral(red: 0.9250000119, green: 0.00400000019, blue: 0.5450000167, alpha: 1).cgColor, #colorLiteral(red: 0.5649999976, green: 0.07500000298, blue: 0.9959999919, alpha: 1).cgColor]
        gradient.opacity = 0.3 // change for intensity
        self.layer.insertSublayer(gradient, at: 0)
        //self.layer.addSublayer(gradient)
    }
    func findSubview(withTag tag: Int) -> UIImageView? {
        for subview in self.subviews {
            if subview.tag == tag {
                return subview as? UIImageView
            }
        }
        return nil
    }
}



extension IQTextView{
    func addLayerInTxtView(){
       self.layer.cornerRadius = 10
       self.layer.borderColor = UIColor.lightGray.cgColor
       self.layer.borderWidth = 1
    }
}


extension String {
    
    subscript (i: Int) -> Character {
       // guard i < characters.count else { return "" }
        
       // guard i < self.characters.count else { return "0" }  
        return self[index(startIndex, offsetBy: i)]
    }
    
    
    
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
       
    func toDateString( inputDateFormat inputFormat  : String,  ouputDateFormat outputFormat  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date!)
    }


}


extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}


extension VisualEffectView {
    
    func tint(_ color: UIColor, blurRadius: CGFloat) {
        self.colorTint = color
        self.colorTintAlpha = 0.9
        self.blurRadius = blurRadius
        self.layer.cornerRadius = 29
    }
    
}
extension UIImageView
{
    func makeBlurImage(targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    func removeBlur(targetImageView:UIImageView?)
    {
        for view in (targetImageView?.subviews)!{
            view.removeFromSuperview()
        }
    }
    
    
}

//MARK:- TextField Extension
extension UILabel {

    func animate(newText: String, characterDelay: TimeInterval) {

        DispatchQueue.main.async {

            self.text = ""

            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }

}
//MARK:- TextField Extension

extension UITextField {
    
    @IBInspectable
    var placeHolderColor: UIColor? {
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
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        toolBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.inputAccessoryView = toolBar //9
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
    func addSpace(){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    
}
//MARK:- UIViewController toast 
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

extension UIButton {

    @IBInspectable
    var letterSpace: CGFloat {
        set {
            let attributedString: NSMutableAttributedString!
            if let currentAttrString = attributedTitle(for: .normal) {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.titleLabel?.text ?? "")
                setTitle(.none, for: .normal)
            }

            attributedString.addAttribute(NSAttributedString.Key.kern,
                                           value: newValue,
                                           range: NSRange(location: 0, length: attributedString.length))

            setAttributedTitle(attributedString, for: .normal)
        }

        get {
            if let currentLetterSpace = attributedTitle(for: .normal)?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    func setButtonTitle(Title : String){
        let str = NSAttributedString(string: Title, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            NSAttributedString.Key.strokeColor : #colorLiteral(red: 0, green: 0.462745098, blue: 0.7176470588, alpha: 1),
            NSAttributedString.Key.strokeWidth : -6,
            NSAttributedString.Key.kern : -1
            
            ])
        self.setAttributedTitle(str, for: .normal)
    }
}

 extension UIColor {

     func StringFromUIColor(color: UIColor) -> String {
        let components = color.cgColor.components
        return "[\(components![0]), \(components![1]), \(components![2]), \(components![3])]"
    }
    
     func ColorFromString(string: String) -> UIColor {
        let componentsString = string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        let components = componentsString.components(separatedBy: ", ")
        return UIColor(red: CGFloat((components[0] as NSString).floatValue),
                     green: CGFloat((components[1] as NSString).floatValue),
                      blue: CGFloat((components[2] as NSString).floatValue),
                     alpha: CGFloat((components[3] as NSString).floatValue))
    }
    
}
