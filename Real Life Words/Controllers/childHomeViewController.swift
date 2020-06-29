//
//  childHomeViewController.swift
//  Real Life Words
//
//  Created by Mac on 04/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CoreData

class childHomeViewController: UIViewController {
    //MARK:- VAriables and Outlets
    //MARK:
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnRecognizing: UIButton!
    @IBOutlet weak var btnSayit: UIButton!
    @IBOutlet weak var btnFindSame: UIButton!
    @IBOutlet weak var btnFindOpposite: UIButton!
    @IBOutlet var recognizingVw: UIView!
    @IBOutlet var sayitVw: UIView!
    @IBOutlet var findSameVw: UIView!
    @IBOutlet var findOppVw: UIView!
    @IBOutlet var alphaVw: UIView!
    @IBOutlet var gameVw: UIView!
    @IBOutlet weak var btnReady: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    var GameArr: [gameModel] = []
    var user : childModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEdit.setButtonTitle(Title: "Edit Games")
        btnEdit.addSahadow()
        btnDelete.setButtonTitle(Title: "Delete")
        btnReady.setButtonTitle(Title: "I Am Ready")
        imgUser.image = UIImage(data: user.image!)
        lblName.text = user.name
        getGames()
        // Do any additional setup after loading the view.
    }
    //MARK:- Implement Custom Method
    //MARK:-
    
    func getGames(){
        
        let Predicate = NSPredicate(format: "user_id == %@", String(user.child_id!))
        GameArr = persistenceStrategy.getGame(Entity: Constant().Table.GAMES , predicate: Predicate)
    }
    func deleteUser(){
        
        let usrPredicate = NSPredicate(format: "child_id == %d",user.child_id!)
        persistenceStrategy.deleteItem(Entity: Constant().Table.CHILDREN, predicate: usrPredicate) {
            print("User Deleted")
            let gamePredicate = NSPredicate(format: "user_id == %d", self.user.child_id!)
            persistenceStrategy.deleteItem(Entity: Constant().Table.GAMES, predicate: gamePredicate) {
                print("Games for User Deleted")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func hideAlphaVw(){
        self.alphaVw.isHidden = true
        self.gameVw.isHidden = true
        self.btnCancel.isHidden = true
        self.btnReady.isHidden = true
        self.btnRecognizing.alpha = 1.0
        self.btnSayit.alpha = 1.0
        self.btnFindSame.alpha = 1.0
        self.btnFindOpposite.alpha = 1.0
    }
    
    func setbuttonAlpha(senderButton: UIButton){
        self.btnRecognizing.alpha = 1.0
        self.btnSayit.alpha = 1.0
        self.btnFindSame.alpha = 1.0
        self.btnFindOpposite.alpha = 1.0
        senderButton.alpha = 0.5
    }
    //MARK:- Implement Button Actions
    //MARK:-
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cmdCancel(_ sender: UIButton) {
        hideAlphaVw()
    }
    @IBAction func cmdReady(_ sender: UIButton) {
        hideAlphaVw()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.PLAY_VC) as! playVC
        vc.user = self.user
        vc.gameId = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func cmdSelectGame(_ sender: UIButton) {
        //  sender tag = 1 for Recognizing, 2 for Say it, 3 for Find the same, 4 for Find the opposite
        var gameId = Int()
        switch sender.tag {
        case 1:
            gameId = 1
            print("Recognizing")
        case 2:
            gameId = 2
            print("Say It")
        case 3:
            gameId = 3
            print("Find Same")
        case 4:
            gameId = 4
            print("Find Opposite")
        default:
            print("Default")
        }
        if GameArr.first(where: { $0.game_id! == gameId}) != nil{
            self.setbuttonAlpha(senderButton: sender)
            btnReady.tag = gameId
            self.btnReady.isHidden = false
        }else{
            Utility.showAlertMessage(title: Constant().TITLE, message: String(format: "You have not set up this game for %@", user.name!), view: self)
        }
        
    }
    
    @IBAction func cmdGetStatistics(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.STATISTIC_VC) as! statisticsVC
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cmdPlay(_ sender: UIButton) {
        self.alphaVw.isHidden = false
        self.gameVw.isHidden = false
        self.btnCancel.isHidden = false
        
    }
    
    
    @IBAction func cmdDelete(_ sender: UIButton) {
        
        Utility.showksAlertMessageWithOkAndCancelAction(title: String(format: "Delete %@",user.name!), message: "Are you sure ?", view: self) {
            self.deleteUser()
        }
        
    }
    
    @IBAction func cmdEditGames(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.SETUP_GAME_VC) as! setUpGameVC
        vc.refuser = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}

