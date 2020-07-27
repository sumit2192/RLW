//
//  statisticsVC.swift
//  Real Life Words
//
//  Created by Mac on 22/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class statisticsVC: UIViewController {

    @IBOutlet weak var btnChooseGame: UIButton!
    @IBOutlet weak var centerVw: UIView!
    @IBOutlet weak var successLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAttemptCount: UILabel!
    @IBOutlet weak var lblRightCount: UILabel!
    @IBOutlet weak var lblWrongCount: UILabel!
    
    var user : childModel!
    var summary : summaryModel!
    var summaryArr : [summaryModel] = []
    var fromStatistics : Bool = false
    let progressLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()
    var timer = Timer()
    var count : Int = 0
    var percrntVal : Double = 40
    var displayId : Int = 1
    var centerPoint = CGPoint()
    var line_Width = UIDevice.current.orientation.isPortrait ? 40.0 : 30.0
    @IBOutlet weak var widthConst: NSLayoutConstraint!
    var baseForCircleVW : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successLbl.isHidden = true
        percentLbl.isHidden = true
        imgUser.image = UIImage(data: user.image!)
        lblName.text = user.name
        
        if !fromStatistics{
            percrntVal = (Double(summary.right_ans!) / Double(summary.attempts!)) * 100
            lblAttemptCount.text = String(summary.attempts!)
            lblRightCount.text = String(summary.right_ans!)
            lblWrongCount.text = String(summary.wrong_ans!)
            btnChooseGame.isUserInteractionEnabled = false
            switch summary.game_id! {
            case 1:
                self.btnChooseGame.setTitle("Recognizing words & Signs", for: .normal)
            case 2:
                self.btnChooseGame.setTitle("Say It", for: .normal)
            case 3:
                self.btnChooseGame.setTitle("Find the Same", for: .normal)
            default:
                self.btnChooseGame.setTitle("Find the Opposite", for: .normal)
            }
        }else{
            fetchSummary(gameid: 1)
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        if UIDevice.current.orientation.isPortrait{
            self.centerPoint = CGPoint(x: 512.0, y: 633.0)
            let newConstraint = self.widthConst.constraintWithMultiplier(1/4)
            self.view.removeConstraint(self.widthConst)
            self.view.addConstraint(newConstraint)
            self.view.layoutIfNeeded()
            self.widthConst = newConstraint
            self.line_Width = 40.0
        }else{
            self.centerPoint = CGPoint(x: 683.0, y: 512.0)
            let newConstraint = self.widthConst.constraintWithMultiplier(1/6)
            self.view.removeConstraint(self.widthConst)
            self.view.addConstraint(newConstraint)
            self.view.layoutIfNeeded()
            self.widthConst = newConstraint
            self.line_Width = 30.0
        }
        createPercentageVw()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        trackLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        progressLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        trackLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        progressLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in

            let orient = UIDevice.current.orientation

            switch orient {

            case .portrait:

                print("Portrait")
                self.centerPoint = CGPoint(x: 512.0, y: 633.0)
                let newConstraint = self.widthConst.constraintWithMultiplier(1/4)
                self.view.removeConstraint(self.widthConst)
                self.view.addConstraint(newConstraint)
                self.view.layoutIfNeeded()
                self.widthConst = newConstraint
                self.line_Width = 40.0

            case .landscapeLeft,.landscapeRight :

                print("Landscape")
                self.centerPoint = CGPoint(x: 683.0, y: 512.0)
                let newConstraint = self.widthConst.constraintWithMultiplier(1/6)
                self.view.removeConstraint(self.widthConst)
                self.view.addConstraint(newConstraint)
                self.view.layoutIfNeeded()
                self.widthConst = newConstraint
                self.line_Width = 30.0

            default:

                print("Anything But Portrait")
            }

            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                //refresh view once rotation is completed not in will transition as it returns incorrect frame size.Refresh here
                print(self.view.center)
                if UIDevice.current.orientation.isPortrait{
                    self.baseForCircleVW = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/4, height: self.view.frame.width/4))
                }else{
                    self.baseForCircleVW = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/6, height: self.view.frame.width/6))
                }
                self.baseForCircleVW.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                self.baseForCircleVW.center = self.view.center
                self.createPercentageVw()

        })
        super.viewWillTransition(to: size, with: coordinator)

    }
    
    func fetchSummary(gameid: Int){
        
        let Predicate = NSPredicate(format: "child_id == %@ AND game_id == %@", String(user.child_id!),String(gameid))
         summaryArr = persistenceStrategy.getSummary(Entity: Constant().Table.SUMMARY, predicate: Predicate)
        if summaryArr.count == 0{
            self.percrntVal = 0
            self.count = 0
            self.successLbl.isHidden = true
            self.percentLbl.isHidden = true
            self.percentLbl.text = "0%"
            self.lblAttemptCount.text = "0"
            self.lblRightCount.text = "0"
            self.lblWrongCount.text = "0"
        }else{
            let sum = summaryArr[0]
            percrntVal = (Double(sum.right_ans!) / Double(sum.attempts!)) * 100
            lblAttemptCount.text = String(sum.attempts!)
            lblRightCount.text = String(sum.right_ans!)
            lblWrongCount.text = String(sum.wrong_ans!)
        }
    }
    func createPercentageVw(){
        let center = view.center
        // if you want to draw and animate track anti clockwise
        let circularPath = UIBezierPath(arcCenter: center, radius: centerVw.frame.height/2, startAngle: -CGFloat.pi/2 , endAngle: -2.5 * CGFloat.pi, clockwise: false)
        
        // if you want to draw and animate track clockwise
        //let circularPath = UIBezierPath(arcCenter: center, radius: centerVw.frame.height/2, startAngle: -CGFloat.pi/2 , endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        //create a track layer for animation
        //let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) //red - 255 51 51
        trackLayer.lineWidth = CGFloat(line_Width)
        trackLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        trackLayer.lineCap = .butt
        view.layer.addSublayer(trackLayer)
        
        //create progress layer
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) //green - 0 227 50
        progressLayer.lineWidth = CGFloat(line_Width)
        progressLayer.strokeEnd = 0
        progressLayer.fillColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        progressLayer.lineCap = .butt
        view.layer.addSublayer(progressLayer)
        self.perform(#selector(startTracking), with: nil, afterDelay: 0.5)
    }
    @objc func startTracking(){
        UIView.animate(withDuration: 1.0) {
            self.trackLayer.strokeColor = #colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1)
            self.progressLayer.strokeColor = #colorLiteral(red: 0, green: 0.8901960784, blue: 0.1960784314, alpha: 1)
            self.successLbl.isHidden = false
            self.percentLbl.isHidden = false
        }
        let refVal: Double = percrntVal/100
        let InterVal: Double = 1/percrntVal
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue =
        basicAnimation.toValue = refVal
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "Animate")
        timer = Timer.scheduledTimer(timeInterval: InterVal, target: self, selector: #selector(countup), userInfo: nil, repeats: true)
    }
    
    @objc private func countup(){
        count += 1
        percentLbl.text = String(count)+"%"
        successLbl.isHidden = false
        if count == Int(percrntVal) {
            timer.invalidate()
            count = 0
        }
        
    }
    
    //MARK:- Implemet button actions
    @IBAction func cmdBack(_ sender: UIButton) {
        if fromStatistics{
            self.navigationController?.popViewController(animated: true)
        }else{
            for vc in self.navigationController!.viewControllers{
                if vc.isKind(of: childHomeViewController.self){
                    self.navigationController?.popToViewController(vc, animated: true)
                }
            }
        }
        
    }
    @IBAction func cmdChooseGameType(_ sender: UIButton) {
        
        let actionpopup: UIAlertController = UIAlertController(title: "Game Type", message: nil, preferredStyle: .actionSheet)
        
        let titleattributes = [NSAttributedString.Key.font: UIFont(name: "BalooPaaji-Regular", size: 30)!]
        let titleAttrString = NSMutableAttributedString(string: "Game Type", attributes: titleattributes)
        actionpopup.setValue(titleAttrString, forKey: "attributedTitle")
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionpopup.addAction(cancelActionButton)
        
        //MARK:- action sheet button 1
        let firstGame = UIAlertAction(title: "Recognizing words & Signs", style: .default)
        { _ in
            self.btnChooseGame.setTitle("Recognizing words & Signs", for: .normal)
            self.displayId = 1
            self.percrntVal = 0
            self.count = 0
            self.successLbl.isHidden = true
            self.percentLbl.isHidden = true
            self.fetchSummary(gameid: 1)
            self.createPercentageVw()
        }
        actionpopup.addAction(firstGame)
        
        //MARK:- action sheet button 2
        let seondGame = UIAlertAction(title: "Say it", style: .default)
        { _ in
            self.btnChooseGame.setTitle("Say it", for: .normal)
            self.displayId = 2
            self.percrntVal = 0
            self.count = 0
            self.successLbl.isHidden = true
            self.percentLbl.isHidden = true
            self.fetchSummary(gameid: 2)
            self.createPercentageVw()
        }
        actionpopup.addAction(seondGame)
        
        //MARK:- action sheet button 3
        let thirdGame = UIAlertAction(title: "Find The Same", style: .default)
        { _ in
            self.btnChooseGame.setTitle("Find The Same", for: .normal)
            self.displayId = 3
            self.percrntVal = 0
            self.count = 0
            self.successLbl.isHidden = true
            self.percentLbl.isHidden = true
            self.fetchSummary(gameid: 3)
            self.createPercentageVw()
        }
        actionpopup.addAction(thirdGame)
        
        //MARK:- action sheet button 4
        let fourthGame = UIAlertAction(title: "Find The Opposite", style: .default)
        { _ in
            self.btnChooseGame.setTitle("Find The Opposite", for: .normal)
            self.displayId = 4
            self.percrntVal = 0
            self.count = 0
            self.successLbl.isHidden = true
            self.percentLbl.isHidden = true
            self.fetchSummary(gameid: 4)
            self.createPercentageVw()
        }
        actionpopup.addAction(fourthGame)
        
        switch displayId {
        case 1:
            firstGame.setValue(#colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
            firstGame.setValue(true, forKey: "checked")
        case 2:
            seondGame.setValue(#colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
            seondGame.setValue(true, forKey: "checked")
        case 3:
            thirdGame.setValue(#colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
            thirdGame.setValue(true, forKey: "checked")
        default:
            fourthGame.setValue(#colorLiteral(red: 1, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
            fourthGame.setValue(true, forKey: "checked")
        }
        
        actionpopup.view.tintColor = #colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
        
        if let popoverPresentationController = actionpopup.popoverPresentationController {
            popoverPresentationController.sourceView = btnChooseGame
            popoverPresentationController.sourceRect = sender.bounds
        }
        self.present(actionpopup, animated: true, completion: nil)
    }
    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
