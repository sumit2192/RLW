//
//  optionVC.swift
//  Real Life Words
//
//  Created by Mac on 10/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class optionVC: UIViewController {

    @IBOutlet weak var twoOptVw: UIView!
    @IBOutlet weak var btnOpt1: UIButton!
    @IBOutlet weak var threeOptVw: UIView!
    @IBOutlet weak var btnOpt2: UIButton!
    @IBOutlet weak var fourOptVw: UIView!
    @IBOutlet weak var btnOpt3: UIButton!
    @IBOutlet var doneVw: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    
    var blurVw = UIView()
    var refDict = NSMutableDictionary()
    var gameArr: [gameModel] = []
    var gameExist : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelect.setButtonTitle(Title: "Select")
        blurVw.backgroundColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        blurVw.alpha = 0.8
        self.view.addSubview(blurVw)
        blurVw.isHidden = true
        self.view.addSubview(doneVw)
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidAppear(_ animated: Bool) {
        if gameArr.count > 0 {
            gameExist = true
            let optionId = gameArr[0].option_id
            refDict.setValue(optionId, forKey: "option_id")
            switch optionId {
            case Constant().Option.FIRSTOPTION:
                self.changeBlurFrameWithRespectTo(view: twoOptVw)
            case Constant().Option.SECONDOPTION:
                self.changeBlurFrameWithRespectTo(view: threeOptVw)
            case Constant().Option.THIRDOPTION:
                self.changeBlurFrameWithRespectTo(view: fourOptVw)
            default:
                return
            }
        }
    }
    
  //MARK:- implement custom methods
    
    func changeBlurFrameWithRespectTo(view: UIView)  {
        blurVw.frame = CGRect(x: 0, y: view.frame.origin.y, width: self.view.frame.width, height: view.frame.height)
        doneVw.center = CGPoint(x: blurVw.center.x, y: blurVw.center.y)
        blurVw.isHidden = false
        doneVw.isHidden = false
        btnSelect.isHidden = false
    }
    
    func updateOption(optionid: Int){
            let user_id = gameArr[0].user_id
            let game_id = gameArr[0].game_id
            let Predicate = NSPredicate(format: "user_id == %d AND game_id == %d", user_id!, game_id!)
            persistenceStrategy.editItem(Entity: Constant().Table.GAMES, predicate: Predicate, newData: optionid, dataType: Constant().DataType.INT, dataKey: "option_id") {
                print("Sucess")
            }
    }
    
 //MARK:- implement buton actions
    @IBAction func cmdOpt(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            refDict.setValue(Constant().Option.FIRSTOPTION, forKey: "option_id")
            self.changeBlurFrameWithRespectTo(view: twoOptVw)
        case 2:
            refDict.setValue(Constant().Option.SECONDOPTION, forKey: "option_id")
            self.changeBlurFrameWithRespectTo(view: threeOptVw)
        case 3:
            refDict.setValue(Constant().Option.THIRDOPTION, forKey: "option_id")
            self.changeBlurFrameWithRespectTo(view: fourOptVw)
        default:
            //MARK:- Select Button Action
            if gameExist{
                updateOption(optionid: refDict.value(forKey: "option_id") as! Int)
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.WORD_VERBAL_VC) as! wordsVerbalVC
            vc.refDict = refDict
            vc.isSign = false
            vc.gameArr = gameArr
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cmdBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }


}
