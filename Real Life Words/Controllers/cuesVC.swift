//
//  cuesVC.swift
//  Real Life Words
//
//  Created by Mac on 12/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit

class cuesVC: UIViewController {
    // MARK: - Variables & Outlets
    @IBOutlet weak var cueCollection: UICollectionView!
    @IBOutlet weak var btnSelect: UIButton!
    
    
    @IBOutlet var premiumVw: UIView!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    
    var arrSelectedIndex = [IndexPath]()
    var refDict = NSMutableDictionary()
    
    var gameArr: [gameModel] = []
    var gameExist : Bool = false
    var ref_cue_id : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelect.setButtonTitle(Title: "Select")
        btnUnlock.setButtonTitle(Title: "Unlock")
        btnUnlock.addSahadow()
        btnUnlock.layer.shadowColor = #colorLiteral(red: 0.02400000021, green: 0.5799999833, blue: 0.8820000291, alpha: 1)
        
        lblInfo.attributedText = setAttributedString()
        premiumVw.frame = CGRect(x: 0, y: self.view.frame.maxY - premiumVw.frame.height, width: self.view.frame.width, height: premiumVw.frame.height)
        self.view.addSubview(premiumVw)
        
        if gameArr.count > 0{
            gameExist = true
            ref_cue_id = gameArr[0].cue_id!
            refDict.setValue(ref_cue_id, forKey: "cue_id")
            let path = IndexPath(row: ref_cue_id - 1, section: 0)
            arrSelectedIndex.append(path)
            btnSelect.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view != premiumVw {
            premiumVw.isHidden = true
            self.cueCollection.isUserInteractionEnabled = true
        }
    }
    // MARK: - Custom Methods
    
    func setAttributedString() -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "Get Premium version to access custom features like adding Words and Signs, customizing Cues and Rewards", attributes: [
          .font: UIFont(name: "HelveticaNeue-Medium", size: 30.0)!,
          .foregroundColor: UIColor(white: 34.0 / 255.0, alpha: 1.0)
        ])
        //attributedString.addAttribute(.foregroundColor, value: UIColor.yellow, range: NSRange(location: 4, length: 7))
        return attributedString
    }
    // MARK: - Button Actions
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cmdSelect(_ sender: UIButton) {
        if gameExist{
            let user_id = gameArr[0].user_id
            let game_id = gameArr[0].game_id
            let Predicate = NSPredicate(format: "user_id == %d AND game_id == %d", user_id!, game_id!)
            persistenceStrategy.editItem(Entity: Constant().Table.GAMES, predicate: Predicate, newData: ref_cue_id, dataType: Constant().DataType.INT, dataKey: "cue_id") {
                for vc in self.navigationController!.viewControllers{
                    if vc.isKind(of: setUpGameVC.self){
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
            
        }else{
            
            let gameData: [String: Any] = ["cue_id":refDict.value(forKey: "cue_id")!,
                                           "game_id":refDict.value(forKey: "game_id")!,
                                           "option_id":refDict.value(forKey: "option_id")!,
                                           "reward_id":refDict.value(forKey: "reward_id")!,
                                           "user_id":refDict.value(forKey: "user_id")!,
                                           "vis_id":refDict.value(forKey: "vis_id")!,
                                           "viw_id":refDict.value(forKey: "viw_id")!,
                                           "words":refDict.value(forKey: "words")!]
            if let game : gameModel = persistenceStrategy.addGame(Entity: Constant().Table.GAMES, data: gameData){
                print(game.words!)
                for vc in self.navigationController!.viewControllers{
                    if vc.isKind(of: setUpGameVC.self){
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
        }
        
    }
    
    @IBAction func cmdAdd(_ sender: UIButton) {
        if !DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS) {
            self.premiumVw.isHidden = false
            self.cueCollection.isUserInteractionEnabled = false
        }
    }
    
}

    //MARK:- Implement Collection View Methods
    //MARK:-
extension cuesVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: 437)
       
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return wordsArr.count
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cueCell", for: indexPath) as! cueCell
//        cell.addSahadow()
        cell.tag = indexPath.row
        if arrSelectedIndex.contains(indexPath) {
            cell.blurVw.isHidden = false
            cell.doneVw.isHidden = false
        }
        else {
             cell.blurVw.isHidden = true
             cell.doneVw.isHidden = true
        }
        if indexPath.row == 0{
            cell.imgPremium.isHidden = true
            cell.itemImg.image = UIImage(named: "Cue1.png")
            cell.itemName.text = "Highlighting the correct choice"
        }else if indexPath.row == 1 {

            cell.imgPremium.isHidden = DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS)
            cell.itemImg.image = UIImage(named: "Cue2.png")
            cell.itemName.text = "Arrow pointing the correct choice"
        }else{
            cell.imgPremium.isHidden = DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS)
            cell.itemImg.image = UIImage(named: "Cue3.png")
            cell.itemName.text = "Fading out the incorrect choice"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            arrSelectedIndex.removeAll()
            arrSelectedIndex.append(indexPath)
            collectionView.reloadData()
            btnSelect.isHidden = false
            refDict.setValue(indexPath.row + 1, forKey: "cue_id")
        }else{
            if !DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS) {
                self.premiumVw.isHidden = false
                self.cueCollection.isUserInteractionEnabled = false
            }else{
                arrSelectedIndex.removeAll()
                arrSelectedIndex.append(indexPath)
                collectionView.reloadData()
                btnSelect.isHidden = false
                refDict.setValue(indexPath.row + 1, forKey: "cue_id")
            }
        }
        
    }
    
  

    
}

    //MARK:- Cell Custom Class
    //MARK:-
class cueCell:UICollectionViewCell{
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var doneVw: UIView!
    @IBOutlet weak var imgPremium: UIImageView!
}
