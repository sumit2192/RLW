//
//  TermsVC.swift
//  Real Life Words
//
//  Created by Mac on 02/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CoreData
class TermsVC: UIViewController,UITextViewDelegate {
    //MARK:-  Variables and Outlets
    //MARK:-
    @IBOutlet weak var txtVw: UITextView!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var selected : Bool = false
    var userData : [String:String] = [:]
    var user : parentModel!
    var count : Int = 0
    var StartPoint : Int = 0
    var EndPoint : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAgree.setButtonTitle(Title: "I Agree")
        user = parentModel(userData)
        // Do any additional setup after loading the view.
        txtVw.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap_Policy)))
        var wholeText: NSMutableAttributedString
        wholeText = txtVw.attributedText.mutableCopy() as! NSMutableAttributedString
        let wholeRange = NSRange(wholeText.string.startIndex..., in: wholeText.string)
        wholeText.enumerateAttribute(.underlineStyle, in: wholeRange, options: []) { (value, range, pointee) in
            if value != nil {
                print(range.location)
                print(range.length)
                StartPoint = range.location
                EndPoint = range.location + range.length
                wholeText.addAttribute(NSAttributedString.Key.link, value: value!, range: range)
                txtVw.attributedText = wholeText
            }
        }
    }
    
    @objc func tap_Policy(sender:UITapGestureRecognizer)
    {
       // Location of the tap in text-container coordinates
        let textView = sender.view as! UITextView
       let layoutManager = txtVw?.layoutManager
        var location = sender.location(in: txtVw)
        location.x -= txtVw?.textContainerInset.left ?? 0.0
        location.y -= txtVw?.textContainerInset.top ?? 0.0
        
        // Find the character that's been tapped on

        var characterIndex: Int
        let textContainer = textView.textContainer
        characterIndex = layoutManager?.characterIndex(for: location , in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil) ?? 0
        
        print(characterIndex)
        if characterIndex >= StartPoint && characterIndex < EndPoint{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.POLICY_VC) as! PolicyVC
            self.present(vc, animated: true)
        }

    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

         // **Perform sign in action here**
        print("Sucess")

         return false
     }
    //MARK:- Implement Custom methods
    //MARK:-
    func processParent(){
        var userFound: Bool = false
        if let parent : [parentModel] = persistenceStrategy.getParent(Entity: Constant().Table.PARENT){
            if parent.count > 0{
                for usr in parent{
                    if usr.email!.caseInsensitiveCompare(user.email!) == ComparisonResult.orderedSame
                    {
                        Utility.showksAlertMessageWithTwoAction(title: Constant().TITLE, message: "This email alreay exist. Try logging in", view: self) { (action) in
                            if action == 1{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.LOGIN_VC) as! loginViewController
                                vc.user = self.user
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        userFound = true
                        break
                    }
                }
                if !userFound{
                    saveParent()
                }
            }else{
                saveParent()
            }
        }
    }
    
    func saveParent(){
        if let saveParent = persistenceStrategy.addParent(Entity: Constant().Table.PARENT, data: userData){
            print("parent saved as %@", saveParent.name!)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.LOGIN_VC) as! loginViewController
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Utility.showAlertMessage(title: Constant().TITLE, message: "Something went wrong. Please try again", view: self)
        }
    }
    //MARK:- Implement Button Actions
    //MARK:-
    
    @IBAction func cmdAgree(_ sender: UIButton) {
        if selected{
            processParent()
        }
    }
    @IBAction func cmdTick(_ sender: UIButton) {
        if selected{
            sender.setImage(UIImage(named: ""), for: .normal)
            selected = false
        }else{
            sender.setImage(#imageLiteral(resourceName: "Tick"), for: .normal)
            selected = true
        }
    }
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
