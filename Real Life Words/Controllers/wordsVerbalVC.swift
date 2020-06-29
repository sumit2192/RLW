//
//  wordsVerbalVC.swift
//  Real Life Words
//
//  Created by Mac on 11/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import AVFoundation

class wordsVerbalVC: UIViewController {

    //MARK:- Variables and outlets
    
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnFindWord: UIButton!
    @IBOutlet weak var btnSelectWord: UIButton!
    @IBOutlet weak var btnTouchWord: UIButton!
    
    @IBOutlet weak var btnFindSound: UIButton!
    @IBOutlet weak var btnSelectSound: UIButton!
    @IBOutlet weak var btnTouchSound: UIButton!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet var blurVw: UIView!
    
    var isSign : Bool = false
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance =  AVSpeechUtterance()
    var samanthaVoice : AVSpeechSynthesisVoice?
    var refDict = NSMutableDictionary()
    var gameArr: [gameModel] = []
    var gameExist : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelect.setButtonTitle(Title: "Select")
        self.view.addSubview(blurVw)
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            if voice.name == "Samantha"{
                samanthaVoice = voice
            }
        }
        if isSign{
            btnFindWord.setTitle("Find the sign \"Fire\"", for: .normal)
            btnSelectWord.setTitle("Select the sign \"Fire\"", for: .normal)
            btnTouchWord.setTitle("Touch the sign \"Fire\"", for: .normal)
            lblHeader.text = "Verbal Instruction For Signs"
            infoLbl.text = "Select the verbal instructions related to the \"Signs\" in \"Recognizing Words & Signs\" game"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if gameArr.count > 0 {
            gameExist = true
            let id = isSign ? gameArr[0].vis_id : gameArr[0].viw_id
            let key = isSign ? "vis_id" : "viw_id"
            refDict.setValue(id, forKey: key)
            switch id {
            case Constant().Verbal.FIND:
                self.changeBlurFrameWithRespectTo(view: btnFindWord)
            case Constant().Verbal.SELECT:
                self.changeBlurFrameWithRespectTo(view: btnSelectWord)
            case Constant().Verbal.TOUCH:
                self.changeBlurFrameWithRespectTo(view: btnTouchWord)
            default:
               return
            }
        }
    }
    //MARK:- implement custom methods
    
    func playSoundWith(SpeechString: String){
        
        speechUtterance = AVSpeechUtterance(string: SpeechString)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate - 0.1
        speechUtterance.voice = samanthaVoice//Daniel Lekha Rishi
        //        speechUtterance.pitchMultiplier = 0.5
        speechSynthesizer.speak(speechUtterance)
    }
    
    
    func changeBlurFrameWithRespectTo(view: UIButton)  {
        blurVw.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height)
        blurVw.isHidden = false
        btnSelect.isHidden = false
    }
    
    func updateOption(optionid: Int, Key: String){
            let user_id = gameArr[0].user_id
            let game_id = gameArr[0].game_id
            let Predicate = NSPredicate(format: "user_id == %d AND game_id == %d", user_id!, game_id!)
            persistenceStrategy.editItem(Entity: Constant().Table.GAMES, predicate: Predicate, newData: optionid, dataType: Constant().DataType.INT, dataKey: Key) {
                print("Sucess")
            }
    }
    
    //MARK:- implement Button Actions
    @IBAction func cmdOpt(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.changeBlurFrameWithRespectTo(view: btnFindWord)
            if isSign{
                refDict.setValue(Constant().Verbal.FIND, forKey: "vis_id")
            }else{
                refDict.setValue(Constant().Verbal.FIND, forKey: "viw_id")
            }
        case 2:
            self.changeBlurFrameWithRespectTo(view: btnSelectWord)
            if isSign{
                refDict.setValue(Constant().Verbal.SELECT, forKey: "vis_id")
            }else{
                refDict.setValue(Constant().Verbal.SELECT, forKey: "viw_id")
            }
        case 3:
            self.changeBlurFrameWithRespectTo(view: btnTouchWord)
            if isSign{
                refDict.setValue(Constant().Verbal.TOUCH, forKey: "vis_id")
            }else{
                refDict.setValue(Constant().Verbal.TOUCH, forKey: "viw_id")
            }
        default:
            //MARK:- Select Button Action
            if gameExist{
                let key = isSign ? "vis_id" : "viw_id"
                updateOption(optionid: refDict.value(forKey: key) as! Int, Key: key)
            }
            
            if isSign{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.REWARDS_VC) as! rewardsVC
                vc.refDict = refDict
                vc.gameArr = gameArr
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.WORD_VERBAL_VC) as! wordsVerbalVC
                vc.refDict = refDict
                vc.isSign = true
                vc.gameArr = gameArr
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    @IBAction func cmdPlaySound(_ sender: UIButton){
        switch sender.tag {
        case 1:
            self.playSoundWith(SpeechString: btnFindWord.titleLabel!.text!)
        case 2:
            self.playSoundWith(SpeechString: btnSelectWord.titleLabel!.text!)
        case 3:
            self.playSoundWith(SpeechString: btnTouchWord.titleLabel!.text!)
        default:
            print("No Sound")
        }
    }
    @IBAction func cmdBack(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }



}
