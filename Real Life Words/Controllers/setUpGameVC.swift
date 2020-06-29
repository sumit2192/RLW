//
//  setUpGameVC.swift
//  Real Life Words
//
//  Created by Mac on 05/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class setUpGameVC: UIViewController {
    //MARK:- Variables and Outlets
    //MARK:-
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnRecognizing: UIButton!
    @IBOutlet weak var btnSayit: UIButton!
    @IBOutlet weak var btnFindSame: UIButton!
    @IBOutlet weak var btnFindOpposite: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet var recognizingVw: UIView!
    @IBOutlet var sayitVw: UIView!
    @IBOutlet var findSameVw: UIView!
    @IBOutlet var findOppVw: UIView!
    @IBOutlet var tick1: UIView!
    @IBOutlet var tick2: UIView!
    @IBOutlet var tick3: UIView!
    @IBOutlet var tick4: UIView!
    var cdManager = CDManager()
    var refuser : childModel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initalSetup()
    }
    func initalSetup(){
        
        let Predicate = NSPredicate(format: "user_id == %@", String(refuser.child_id!))
        let GameArr: [gameModel] = persistenceStrategy.getGame(Entity: Constant().Table.GAMES , predicate: Predicate)
        if  GameArr.count > 0{
            for game in GameArr{
                switch game.game_id {
                case 1:
                    btnRecognizing.alpha = 0.5
                    tick1.isHidden = false
                case 2:
                    btnSayit.alpha = 0.5
                    tick2.isHidden = false
                case 3:
                    btnFindSame.alpha = 0.5
                    tick3.isHidden = false
                case 4:
                    btnFindOpposite.alpha = 0.5
                    tick4.isHidden = false
                default:
                    print("No games found for %@",refuser.name!)
                }
            }
            if GameArr.count != 4{
                lblInfo.text = String(format: "%d games left to be set up for %@", 4-GameArr.count,refuser.name!)
            }else{
                lblInfo.text = ""
            }
            
        }
    }
    
    @IBAction func cmdSetUp(_ sender: UIButton) {
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.RECOGNIZING_VC) as! recognizingVC
        vc.refUser = self.refuser
        vc.game_id = gameId
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func cmdBack(_ sender: UIButton) {
       // self.navigationController?.popViewController(animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
}
