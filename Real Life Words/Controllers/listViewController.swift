//
//  listViewController.swift
//  Real Life Words
//
//  Created by Mac on 20/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class listViewController: UIViewController {

    //MARK:- Variables and Outlets
    
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var animatingVw: UIView!
    @IBOutlet weak var buttonVw: UIView!
    @IBOutlet weak var btnWords: UIButton!
    @IBOutlet weak var btnRewards: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet var premiumVw: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var wordTapped: Bool = false
    var wordsVC : recognizingVC{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.RECOGNIZING_VC) as! recognizingVC
        vc.asChild = true
        self.addViewControllerAsChildViewController(childViewController : vc)
        return vc
    }
    
    var rewardVC : rewardsVC{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.REWARDS_VC) as! rewardsVC
        vc.asChild = true
        self.addViewControllerAsChildViewController(childViewController : vc)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordsVC.view.isHidden = false
        self.rewardVC.view.isHidden = true
        // Do any additional setup after loading the view.
        btnUnlock.setButtonTitle(Title: "Unlock")
        btnUnlock.addSahadow()
        btnUnlock.layer.shadowColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        
        btnCancel.setButtonTitle(Title: "Cancel")
        btnCancel.addSahadow()
        btnCancel.layer.shadowColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        
        lblInfo.attributedText = setAttributedString()
        premiumVw.frame = CGRect(x: 0, y: self.view.frame.maxY - premiumVw.frame.height, width: self.view.frame.width, height: premiumVw.frame.height)
        self.view.addSubview(premiumVw)
    }
    
    //MARK:- Custom Methods
    
    func setAttributedString() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "Get Premium version to access custom features like adding Words and Signs, customizing Cues and Rewards", attributes: [
          .font: UIFont(name: "HelveticaNeue-Medium", size: 30.0)!,
          .foregroundColor: UIColor(white: 34.0 / 255.0, alpha: 1.0)
        ])
       // attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 4, length: 7))
        return attributedString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != premiumVw {
            premiumVw.isHidden = true
        }
    }
    
    private func addViewControllerAsChildViewController(childViewController : UIViewController){
        addChild(childViewController)
        childViewController.view.frame = CGRect(x: 0, y: (self.headerVw.frame.height + self.buttonVw.frame.height + 20), width: self.view.frame.width, height: self.view.frame.height-20-(self.headerVw.frame.height+self.buttonVw.frame.height))
        UIView.transition(with: view, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.view.addSubview(childViewController.view)
        }) { (done) in
            childViewController.didMove(toParent: self)
            self.view.bringSubviewToFront(self.btnAdd)
        }
    }
    
    //MARK:- Button Actions

    @IBAction func cmdAdd(_ sender: UIButton) {
        self.view.bringSubviewToFront(self.premiumVw)
        self.premiumVw.isHidden = false
        
    }
    
    @IBAction func cmdCancel(_ sender: UIButton){
        self.premiumVw.isHidden = true
    }
    
    @IBAction func cmdUnlock(_ sender: UIButton) {
         self.premiumVw.isHidden = true
    }
    
    @IBAction func cmdAnimate(_ sender: UIButton) {
        if sender.tag == 0{
            self.btnWords.setTitleColor(#colorLiteral(red: 0.9179999828, green: 0.8820000291, blue: 0.04699999839, alpha: 1), for: .normal)
            self.btnRewards.setTitleColor(#colorLiteral(red: 0.451000005, green: 0.8080000281, blue: 1, alpha: 1), for: .normal)
            self.wordsVC.view.isHidden = false
            self.rewardVC.view.isHidden = true
        }else{
            self.btnRewards.setTitleColor(#colorLiteral(red: 0.9179999828, green: 0.8820000291, blue: 0.04699999839, alpha: 1), for: .normal)
            self.btnWords.setTitleColor(#colorLiteral(red: 0.451000005, green: 0.8080000281, blue: 1, alpha: 1), for: .normal)
            self.rewardVC.view.isHidden = false
            self.wordsVC.view.isHidden = true
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.animatingVw.frame = CGRect(x: sender.frame.origin.x, y: self.animatingVw.frame.origin.y, width: sender.frame.width, height: self.animatingVw.frame.height)
        }) { (completed) in
            self.wordTapped = sender.tag == 0 ? true : false
        }
    }

    
}
