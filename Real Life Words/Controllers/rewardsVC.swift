//
//  signVerbalVC.swift
//  Real Life Words
//
//  Created by Mac on 11/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import AVFoundation
class rewardsVC: UIViewController {

    //MARK:- Variables and Outlets
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var lblselectInfo: UILabel!
    @IBOutlet weak var baseScroll: UIScrollView!
    @IBOutlet weak var visualCollection: UICollectionView!
    @IBOutlet weak var audioCollection: UICollectionView!
    @IBOutlet weak var visualAudioCollection: UICollectionView!
    @IBOutlet weak var btnSelect: UIButton!
    
    
    @IBOutlet var premiumVw: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    
    var arrSelectedvideoIndex = [IndexPath]()
    var arrSelectedAudioIndex = [IndexPath]()
    //var audioArr : [String] = []
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance =  AVSpeechUtterance()
    var samanthaVoice : AVSpeechSynthesisVoice?
    
    var visualArr: [rewardModel] = []
    var audioArr: [rewardModel] = []
    var avArr: [rewardModel] = []
    
    var refDict = NSMutableDictionary()
    var gameArr: [gameModel] = []
    var gameExist : Bool = false
    var ref_reward_id : Int = 0
    
    @IBOutlet weak var btnAdd: UIButton!
    var asChild : Bool = false
    @IBOutlet weak var topCnstrnt: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if asChild{
            topCnstrnt.constant = -150
            headerVw.isHidden = asChild
            lblselectInfo.isHidden = asChild
            btnAdd.isHidden = asChild
            
        }
        btnSelect.setButtonTitle(Title: "Select")
        btnUnlock.setButtonTitle(Title: "Unlock")
        btnUnlock.addSahadow()
        btnUnlock.layer.shadowColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            if voice.name == "Samantha"{
                samanthaVoice = voice
            }
        }
        lblInfo.attributedText = setAttributedString()
        premiumVw.frame = CGRect(x: 0, y: self.view.frame.maxY - premiumVw.frame.height, width: self.view.frame.width, height: premiumVw.frame.height)
        self.view.addSubview(premiumVw)
        
        if gameArr.count > 0 {
            gameExist = true
            ref_reward_id = gameArr[0].reward_id!
            refDict.setValue(ref_reward_id, forKey: "reward_id")
            btnSelect.isHidden = false
        }
        fetchRewards()
        // Do any additional setup after loading the view.
    }
    

    func fetchRewards(){
        //let rewardsArr:[rewardModel] = persistenceStrategy.getRewards(Entity: Constant().Table.REWARD)
        let rewardsArr:[rewardModel] = persistenceStrategy.getRewards(Entity:  Constant().Table.REWARD, predicate: nil)
        if rewardsArr.count > 0{
            for item in rewardsArr{
                switch item.reward_Type {
                case Constant().RewardType.VISUAL:
                    visualArr.append(item)
                case Constant().RewardType.AUDIO:
                    audioArr.append(item)
                default:
                    avArr.append(item)
                }
            }
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != premiumVw {
            premiumVw.isHidden = true
            self.baseScroll.isUserInteractionEnabled = true
        }
    }
     //MARK:- Implement Button Actions
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cmdAdd(_ sender: UIButton) {
        self.premiumVw.isHidden = false
        self.baseScroll.isUserInteractionEnabled = false
    }
    
    @IBAction func cmdSelect(_ sender: UIButton) {
        if gameExist{
            let user_id = gameArr[0].user_id
            let game_id = gameArr[0].game_id
            let Predicate = NSPredicate(format: "user_id == %d AND game_id == %d", user_id!, game_id!)
            persistenceStrategy.editItem(Entity: Constant().Table.GAMES, predicate: Predicate, newData: ref_reward_id, dataType: Constant().DataType.INT, dataKey: "reward_id") {
                print("Sucess")
            }
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.CUES_VC) as! cuesVC
        vc.refDict = refDict
        vc.gameArr = gameArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

    //MARK:- Implement Collection View Methods

extension rewardsVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,AudioCellDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return visualArr.count
        }else if collectionView.tag == 2{
            return audioArr.count
        }else{
            return avArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visualCell", for: indexPath) as! visualCell
            let item = visualArr[indexPath.row]
            cell.imgVisual.image = UIImage(data: item.reward_Image!)
            if item.reward_id == ref_reward_id{
                cell.blurVw.isHidden = false
            }else{
                cell.blurVw.isHidden = true
            }
            cell.tag = item.reward_id!
            return cell
        }else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "audioCell", for: indexPath) as! audioCell
            let item = audioArr[indexPath.row]
            cell.lblAudio.text = item.reward_Text
            cell.index = indexPath.row
            cell.delegate = self
            if item.reward_id == ref_reward_id{
                cell.blurVw.isHidden = false
            }else{
                cell.blurVw.isHidden = true
            }
            cell.tag = item.reward_id!
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AVCell", for: indexPath) as! AVCell
            let item = avArr[indexPath.row]
            cell.imgVisual.image = UIImage(data: item.reward_Image!)
            cell.lblAudio.text = item.reward_Text
            cell.tag = item.reward_id!
            return cell
        }
       
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 220)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !asChild{
           
            if collectionView.tag == 1{
                btnSelect.isHidden = false
                let item = visualArr[indexPath.row]
                refDict.setValue(item.reward_id, forKey: "reward_id")
                ref_reward_id = item.reward_id!
                visualCollection.reloadData()
                audioCollection.reloadData()
                visualAudioCollection.reloadData()
            }else if collectionView.tag == 2{
                btnSelect.isHidden = false
                let item = audioArr[indexPath.row]
                refDict.setValue(item.reward_id, forKey: "reward_id")
                ref_reward_id = item.reward_id!
                visualCollection.reloadData()
                audioCollection.reloadData()
                visualAudioCollection.reloadData()
            }else{
                self.premiumVw.isHidden = false
                self.baseScroll.isUserInteractionEnabled = false
            }
        }
    }
    
    func playSoundAt(index: Int) {
        let reward = audioArr[index]
        let SpeechString = reward.reward_Text!
        speechUtterance = AVSpeechUtterance(string: SpeechString)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate - 0.1
        speechUtterance.voice = samanthaVoice//Daniel Lekha Rishi
        //        speechUtterance.pitchMultiplier = 0.5
        speechSynthesizer.speak(speechUtterance)
    }
    
}

//MARK:- Audio Cell Custom Protocol
//MARK:-
protocol AudioCellDelegate : class {
    func playSoundAt(index:Int)
}
//MARK:- Audio Cell Custom Class
class audioCell:UICollectionViewCell{
    var delegate: AudioCellDelegate?
    var index: Int?
    @IBOutlet weak var backVw: UIView!
    @IBOutlet weak var lblAudio: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var blurVw: UIView!
    
    
    @IBAction func cmdPlay(_ sender: UIButton) {
        delegate?.playSoundAt(index: index!)
    }
}

//MARK:- Visual Cell Custom Class

class visualCell:UICollectionViewCell{
    @IBOutlet weak var imgVisual: UIImageView!
    @IBOutlet weak var blurVw: UIView!
    
}

//MARK:- AudioVisual Cell Custom Class

class AVCell:UICollectionViewCell{

    @IBOutlet weak var imgVisual: UIImageView!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var backVw: UIView!
    @IBOutlet weak var lblAudio: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
}
