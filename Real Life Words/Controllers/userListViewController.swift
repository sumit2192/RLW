//
//  userListViewController.swift
//  Real Life Words
//
//  Created by Mac on 03/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
class userListViewController: UIViewController {

    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance =  AVSpeechUtterance()
    var samanthaVoice : AVSpeechSynthesisVoice?
    
    @IBOutlet weak var tblUser: UITableView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var passVw: UIView!
    @IBOutlet weak var tctPass: UITextField!
    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    
    
    @IBOutlet var premiumVw: UIView!
    @IBOutlet weak var lblpremiumInfo: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var refChild : childModel!
    var childArr: [childModel] = []
    var cdManager = CDManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCreate.setButtonTitle(Title: "Create User")
        btnGo.setButtonTitle(Title: "Go")
        tctPass.addSahadow()
        tctPass.addSpace()
        infoLbl.isHidden = true
        
        btnUnlock.setButtonTitle(Title: "Unlock")
        btnUnlock.addSahadow()
        btnUnlock.layer.shadowColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        
        btnCancel.setButtonTitle(Title: "Cancel")
        btnCancel.addSahadow()
        btnCancel.layer.shadowColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        // Do any additional setup after loading the view.
        
        lblpremiumInfo.attributedText = setAttributedString()
        premiumVw.frame = CGRect(x: 0, y: self.view.frame.maxY - premiumVw.frame.height, width: self.view.frame.width, height: premiumVw.frame.height)
        self.view.addSubview(premiumVw)
        
        cdManager.fetchDataFrom(table: Constant().Table.CHILDREN, predicateFormat: "") { (status) in
            if status == 1{
                self.premiumVw.isHidden = false
            }
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        childArr.removeAll()
        fetchChild()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == blurVw{
            blurVw.isHidden = true
            passVw.isHidden = true
        }
    }
    
    func setAttributedString() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "Get Premium version to access custom features like adding Words and Signs, customizing Cues and Rewards", attributes: [
          .font: UIFont(name: "HelveticaNeue-Medium", size: 30.0)!,
          .foregroundColor: UIColor(white: 34.0 / 255.0, alpha: 1.0)
        ])
        //attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 4, length: 7))
        return attributedString
    }
    
    func fetchChild(){
        let Predicate = NSPredicate(format: "parent_email == [c] %@", DEFAULTS.string(forKey: Constant().UD_SUPER_USER_EMAIL)!)
        childArr = persistenceStrategy.getChild(Entity:Constant().Table.CHILDREN , predicate: Predicate)
        if childArr.count == 0{
            tblUser.isHidden = true
            infoLbl.isHidden = false
        }else{
            tblUser.isHidden = false
            infoLbl.isHidden = true
            tblUser.reloadData()
        }
    }

    @IBAction func cmdCreate(_ sender: UIButton) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.CREATE_CHILD_VC) as! createChildVC
        vc.Last_Generated_id = childArr.count
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cmdGo(_ sender: UIButton) {
        if Utility.isTxtFldEmpty(tctPass){
            Utility.showAlertMessage(title: Constant().TITLE, message: Constant.PASS_REQUIRED, view: self)
            return
        }else{
            if tctPass.text != refChild.password{
                Utility.showKSAlertMessageWithOkAction(title: Constant().TITLE, message: "Password doest not match. Please try again", view: self) {
                    
                }
            }else{
                self.view.endEditing(true)
                blurVw.isHidden = true
                passVw.isHidden = true
                tctPass.text = ""
                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.CHILD_HOME_VC) as! childHomeViewController
                vc.user = refChild
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    @IBAction func cmdCancel(_ sender: UIButton){
        premiumVw.isHidden = true
    }
    @IBAction func cmdUnlock(_ sender: UIButton) {
        premiumVw.isHidden = true
    }
}
//MARK:- Implement TableView delegate methods
//MARK:-
extension userListViewController: UITableViewDelegate,UITableViewDataSource,TicketCellDelegate{
    func callUser(index: Int) {
    
    }
    
    func processRequest(index: Int, setStatus: String) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblUser.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        let request = childArr[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.index = indexPath.row
        cell.imgChild.image = UIImage(data: request.image!)
        cell.lblName.text = request.name
        let Predicate = NSPredicate(format: "user_id == %@", String(request.child_id!))
        let GameArr: [gameModel] = persistenceStrategy.getGame(Entity: Constant().Table.GAMES , predicate: Predicate)
        let left = 4 - GameArr.count
        if left == 0{
            cell.lblGmeLeft.text = ""
        }else if left == 4{
            cell.lblGmeLeft.text = "No games found"
        }else{
            cell.lblGmeLeft.text = String(format: "%d games left", left)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        blurVw.isHidden = false
        passVw.isHidden = false
        refChild = childArr[indexPath.row]

    }
    
}

//MARK:- Cell Custom Protocol
//MARK:-
protocol TicketCellDelegate : class {

    func callUser(index:Int)
    func processRequest(index:Int,setStatus:String)
  
}
//MARK:- Cell Custom Class
//MARK:-
class UserCell:UITableViewCell{
    
    var delegate: TicketCellDelegate?
    var index: Int?
    @IBOutlet weak var imgChild: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGmeLeft: UILabel!
    //  var isRequestTypeCell: Bool?
}
