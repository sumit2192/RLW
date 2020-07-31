//
//  recognizingVC.swift
//  Real Life Words
//
//  Created by Mac on 05/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import CoreData

class recognizingVC: UIViewController {
    //MARK:- Variables and Outlets
    //MARK:-
    @IBOutlet weak var headerVw: UIView!
    @IBOutlet weak var baseVw: UIView!
    
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var colVw: UICollectionView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAddSelected: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var doneVw: UIView!
    var arrSelectedIndex = [IndexPath]()
    var refUser: childModel!
//    var refTable: String!
    var refword : wordModel!
    var wordsArr: [wordModel] = []
    var gameArr: [gameModel] = []
    var cdManager = CDManager()
    var wordStr = ""
    var gameExist : Bool = false
    var game_id : Int?
    
    var asChild : Bool = false
    @IBOutlet weak var topConstrint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddSelected.setButtonTitle(Title: "Add Selected")
        headerVw.isHidden = asChild
        if asChild{
            lblInfo.isHidden = true
            topConstrint.constant = -(self.view.frame.height/10)
            self.view.layoutIfNeeded()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        wordsArr.removeAll()
        fetchWords()
        if !asChild{
           checkExistence()
        }
    }
    //MARK:- Implement Custom Methods
    //MARK:-
    
    func fetchWords(){
        // let Predicate = NSPredicate(format: "")
        wordsArr = persistenceStrategy.getWord(Entity: Constant().Table.WORDS, predicate: nil)
        switch game_id {
        case 3:
            if !DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS){
                wordsArr = wordsArr.filter({$0.same_word_id != 0 && $0.type == 1})
            }else{
                wordsArr = wordsArr.filter({$0.same_word_id != 0})
            }
            
        case 4:
            
            if !DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS){
                wordsArr = wordsArr.filter({$0.opp_word_id != 0 && $0.type == 1})
            }else{
                wordsArr = wordsArr.filter({$0.opp_word_id != 0})
            }
            
        default:
            if !DEFAULTS.bool(forKey: Constant().UD_SUBSCRIPTION_STATUS){
                wordsArr = wordsArr.filter({$0.type == 1})
            }
        }
        for wd in wordsArr{
            print(wd.name!)
            
        }
        //.filter { $0.cat == "garden"}
        if wordsArr.count > 0{
            self.lblTotal.text = String(format: "Total Words: %@", String(wordsArr.count))
            colVw.reloadData()
        }else{
            Utility.showAlertMessage(title: Constant().TITLE, message: "No words Found", view: self)
        }
    }
    
    func checkExistence(){
        let Predicate = NSPredicate(format: "user_id == %d AND game_id == %d", refUser.child_id!, game_id!)
        gameArr = persistenceStrategy.getGame(Entity: Constant().Table.GAMES, predicate: Predicate)
        if gameArr.count > 0{
            gameExist = true
            let preSelectedWords = (gameArr[0].words?.components(separatedBy: ","))!
            for wordId in preSelectedWords{
                let id = Int(wordId)!
                let index = wordsArr.firstIndex{$0.word_id == id}
                let path = IndexPath(row: index!, section: 0)
                arrSelectedIndex.append(path)
            }
            colVw.reloadData()
            self.hideandShow(status: false)
        }
    }
    func gameSetUp(data: NSMutableDictionary){
        if gameExist{
            let Predicate = NSPredicate(format: "user_id == %@ AND game_id == %@", String(refUser.child_id!), String(game_id!))
            persistenceStrategy.editItem(Entity: Constant().Table.GAMES, predicate: Predicate, newData: data.value(forKey: "words")!, dataType: Constant().DataType.STRING, dataKey: "words") {
                print("Sucess")
            }
        }
        self.blurVw.isHidden = true
        self.doneVw.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.OPTION_VC) as! optionVC
        vc.refDict = data
        vc.gameArr = gameArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func createArrayStringusing(arr: [IndexPath]) -> String{
        var indexArr = [Int]()
        let selectedArrofWordsid = NSMutableArray()
        var stringOfid = ""
        for index in arr{
            indexArr.append(index.row)
        }
        
        for i in 0...indexArr.count-1{
            let referIndex = indexArr[i]
            selectedArrofWordsid.add(wordsArr[referIndex].word_id!)
        }
        
        stringOfid = selectedArrofWordsid.componentsJoined(by: ",")
        print(stringOfid)
        return stringOfid
    }
    
    func hideandShow(status: Bool){
        //self.baseVw.isHidden = status
        if status{
            
            UIView.animate(withDuration: 0.3) {
                let transition = CATransition()
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromBottom
                self.baseVw.layer.add(transition, forKey: nil)
                self.baseVw.isHidden = true
            }
        }else{
            if self.baseVw.isHidden{
                self.baseVw.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    let transition = CATransition()
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromTop
                    self.baseVw.layer.add(transition, forKey: nil)
                    
                }
            }
        }
        
    }
    
    //MARK:- Implement Button Methods
    //MARK:-
    @IBAction func cmdBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func cmdAddSelected(_ sender: UIButton) {
        blurVw.isHidden = false
        doneVw.isHidden = false
        UIView.animate(withDuration: 0.1, animations: {
            self.doneVw.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { (Completed) in
            UIView.animate(withDuration: 0.1, animations: {
                self.doneVw.transform = CGAffineTransform.identity
            }) { (Completed) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.doneVw.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }) { (Completed) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.doneVw.transform = CGAffineTransform.identity
                    }) { (Completed) in
                        let words =  self.createArrayStringusing(arr: self.arrSelectedIndex)
                        let dict = NSMutableDictionary()
                        dict.setValue(self.refUser.child_id, forKey: "user_id")
                        dict.setValue(self.game_id, forKey: "game_id")
                        dict.setValue(words, forKey: "words")
                        self.gameSetUp(data: dict)
                        
                    }
                }
            }
        }
    }
    @IBAction func cmdCancel(_ sender: UIButton) {
        baseVw.isHidden = true
    }
    
    @IBAction func cmdAdd(_ sender: UIButton) {
        baseVw.isHidden = true
        //
        let totalWords = persistenceStrategy.getWord(Entity: Constant().Table.WORDS, predicate: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: Constant.ADD_WORD_SIGN_VC) as! AddWordAndSignVC
        vc.refUser = self.refUser
        vc.Last_Generated_wordId = totalWords.count
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- Implement Collection View Methods
//MARK:-
extension recognizingVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3.5, height: collectionView.frame.size.width * 1/3)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordsArr.count
        // return 70
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recognizingWordCell", for: indexPath) as! recognizingWordCell
        cell.addSahadow()
        cell.tag = indexPath.row
        let request = wordsArr[indexPath.row]
        cell.itemImg.image = UIImage(data: request.sign!)
        cell.itemName.text = request.name
        var color = UIColor()
        color = color.ColorFromString(string: request.font_color!)
        cell.itemName.textColor = color
        if arrSelectedIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
            //cell.vw.backgroundColor = UIColor.red
            cell.blurVw.isHidden = false
            cell.selctedVw.isHidden = false
        }
        else {
            cell.blurVw.isHidden = true
            cell.selctedVw.isHidden = true
        }
        
        //cell.cellImg.image = imageArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !asChild{
            if arrSelectedIndex.contains(indexPath) {
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
            }else {
                arrSelectedIndex.append(indexPath)
            }
            var idarr : [Int] = []
            for indexpateh in arrSelectedIndex{
                let word_id = wordsArr[indexpateh.row].word_id
                idarr.append(word_id!)
            }
            
            lblTotal.text = String(format: "Total Words: %@", String(arrSelectedIndex.count))
            arrSelectedIndex.count == 0 ? self.hideandShow(status: true) : self.hideandShow(status: false)
            collectionView.reloadData()
        }
    }
    
}

//MARK:- Cell Custom Class
//MARK:-
class recognizingWordCell:UICollectionViewCell{
    
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var blurVw: UIView!
    @IBOutlet weak var selctedVw: UIView!
}

