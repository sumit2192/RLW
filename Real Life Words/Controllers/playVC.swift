//
//  playVC.swift
//  Real Life Words
//
//  Created by Mac on 24/06/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import AVFoundation
class playVC: UIViewController {

    //MARK:- Variables and outlets
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblQuestionCount: UILabel!
    
    @IBOutlet weak var speakerVw: UIView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var lblQuestion: UILabel!
    
    @IBOutlet weak var lblWord: UILabel!
    @IBOutlet weak var imgSign: UIImageView!
    
    
    
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var answerCollection: UICollectionView!
    
    private let spacing:CGFloat = 20.0
    
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance =  AVSpeechUtterance()
    var samanthaVoice : AVSpeechSynthesisVoice?
    
    var gameId : Int?
    var user : childModel!
    var game : gameModel!
    var refWord : wordModel!
    var refReward : rewardModel!
    var selectedwordArr : [wordModel] = []
    var totalWordsArr : [wordModel] = []
    var totalQues: Int = 0
    var currentQues: Int = 1
    var vis_id : Int?
    var viw_id : Int?
    var option_id : Int?
    var reward_id : Int?
    var collectionCount : Int?
    var answerCollectionArr: [wordModel] = []
    var MainArr : [[wordModel]] = []
    var speechString = ""
    var tagArr : [Int] = []
    var indexarr : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            if voice.name == "Samantha"{
                samanthaVoice = voice
            }
        }
        btnPrev.setButtonTitle(Title: "Previous")
        btnPrev.addSahadow()
        
        btnNext.setButtonTitle(Title: "Next")
        btnNext.addSahadow()
        
        // Set Layout for collection
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        answerCollection.collectionViewLayout = layout
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        game = getGame()
        viw_id = game.viw_id!
        vis_id = game.vis_id!
        option_id = game.option_id!
        reward_id = game.reward_id!
        collectionCount = option_id! + 1  //This will vary for Say it
        let wordArr = game.words!.components(separatedBy: ",")
        for id in wordArr{
            GetWords(wordId: Int(id)!)
        }
        totalQues = wordArr.count * 2
        GetWords(wordId: nil)
        getReward()
        setUpAnswers()
        setupQuestion()
    }
    
    
        // MARK:- Custom Methods
        //MARK:-
    
    // MARK:- Typing animation on lable
    
    // MARK:- Setting up Answers collection data
    func setUpAnswers(){
        for index in 0...totalQues-1{
            
            if index >= totalQues/2{
                answerCollectionArr.append(selectedwordArr[index-(totalQues/2)])
            }else{
                answerCollectionArr.append(selectedwordArr[index])
            }
            
            for _ in 0...collectionCount!-2{
                self.addRandomWordtoArr()
            }
            
            answerCollectionArr = answerCollectionArr.sorted(by: { $0.name! .localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            for item in answerCollectionArr{
                print(item.name!)
            }
            print("*********************************")
            MainArr.append(answerCollectionArr)
            answerCollectionArr.removeAll()
        }
        
        
    }
    
    // MARK:- Choose random words for options for the particular question
    func addRandomWordtoArr(){
        let randomInt = Int.random(in: 0..<totalWordsArr.count)
        let word : wordModel = totalWordsArr[randomInt]
        var status : Bool = false
        if gameId == 1{
            for _ in answerCollectionArr{
                if answerCollectionArr.first(where: { $0.word_id! == word.word_id!}) != nil{
                    status = true
                    break
                }else{
                    status = false
                }
            }
        }

        if !status{
            answerCollectionArr.append(word)
        }else{
            addRandomWordtoArr()
        }
        
    }
    
     // MARK:- Setting up questions
    func setupQuestion(){
        // 1. Count of question
        lblQuestionCount.text = String(format: "%d/%d",currentQues ,totalQues)
        
        //2. Find word for half and Find Sign for half
        if currentQues > totalQues/2{
            var verbalString = ""
            switch vis_id {
            case Constant().Verbal.FIND:
                if gameId == 1{
                    verbalString = "Find the sign"
                }else if gameId == 2{
                    verbalString = "Say it"
                }else if gameId == 3{
                    verbalString = "Find the same for"
                }else{
                    verbalString = "Find the opposite for"
                }
                
            case Constant().Verbal.TOUCH:
                verbalString = "Touch the sign"
                if gameId == 1{
                    verbalString = "Touch the sign"
                }else if gameId == 2{
                    verbalString = "Say it"
                }else if gameId == 3{
                    verbalString = "Touch the same for"
                }else{
                    verbalString = "Touch the opposite for"
                }
            default:
                verbalString = "Select the sign"
                if gameId == 1{
                    verbalString = "Select the sign"
                }else if gameId == 2{
                    verbalString = "Say it"
                }else if gameId == 3{
                    verbalString = "Select the same for"
                }else{
                    verbalString = "Select the opposite for"
                }
            }
            lblQuestion.text = verbalString
            
        }else{
            var verbalString = ""
            switch viw_id {
            case Constant().Verbal.FIND:
                if gameId == 1{
                    verbalString = "Find the word"
                }else if gameId == 2{
                    verbalString = "Say it"
                }else if gameId == 3{
                    verbalString = "Find the same for"
                }else{
                    verbalString = "Find the opposite for"
                }
            case Constant().Verbal.TOUCH:
                if gameId == 1{
                    verbalString = "Touch the word"
                }else if gameId == 2{
                    verbalString = "Say it"
                }else if gameId == 3{
                    verbalString = "Touch the same for"
                }else{
                    verbalString = "Touch the opposite for"
                }
            default:
                if gameId == 1{
                    verbalString = "Select the word"
                }else if gameId == 2{
                    verbalString = "Say it"
                }else if gameId == 3{
                    verbalString = "Select the same for"
                }else{
                    verbalString = "Select the opposite for"
                }
            }
            lblQuestion.text = verbalString
            
        }
        
        //3. word name
        if currentQues > totalQues/2{
            lblWord.isHidden = true
            imgSign.isHidden = false
            refWord = selectedwordArr[currentQues-(totalQues/2)-1]
        }else{
            imgSign.isHidden = true
            lblWord.isHidden = false
            refWord = selectedwordArr[currentQues-1]
            
        }
        
        lblWord.animate(newText: "'"+refWord.name!+"'", characterDelay: 0.1)
        imgSign.image = UIImage(data: refWord.sign!)
        
        speechString = lblQuestion.text!+refWord.name!
        /*if gameId == 3{
            indexarr.removeAll()
            let wordArr : [wordModel] = self.MainArr[answerCollection.tag]
            var arr : [Int] = []
            for item in wordArr{
                arr.append(item.word_id!)
            }
            indexarr  = arr.indexes(of: refWord.word_id!)
            print(indexarr)
        }*/
        if gameId == 2{
            imgSign.isHidden = true
            lblWord.isHidden = true
        }
        answerCollection.reloadData()
        //4.
        //5. Word image along with 3 more
    }
    
    
    func getGame() -> gameModel? {
        let Predicate = NSPredicate(format: "user_id == %@ AND game_id == %@", String(user.child_id!),String(gameId!))
        let GameArr: [gameModel] = persistenceStrategy.getGame(Entity: Constant().Table.GAMES , predicate: Predicate)
        if GameArr.count > 0{
            return GameArr[0]
        }
        return nil
    }
    
    func GetWords(wordId: Int?) {
        if wordId != nil {
            let Predicate = NSPredicate(format: "word_id == %d", wordId!)
            let Arr : [wordModel] = persistenceStrategy.getWord(Entity: Constant().Table.WORDS, predicate: Predicate)
            selectedwordArr.append(Arr[0])
        }else{
            totalWordsArr = persistenceStrategy.getWord(Entity: Constant().Table.WORDS, predicate: nil)
        }
    }
    
    func getReward(){
        let Predicate = NSPredicate(format: "reward_id == %d", reward_id!)
        let rewardArr = persistenceStrategy.getRewards(Entity: Constant().Table.REWARD, predicate: Predicate)
        if rewardArr.count > 0{
            refReward = rewardArr[0]
        }
    }
    func playSoundWith(SpeechString: String){
        
        speechUtterance = AVSpeechUtterance(string: SpeechString)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate - 0.1
        speechUtterance.voice = samanthaVoice//Daniel Lekha Rishi
        //        speechUtterance.pitchMultiplier = 0.5
        speechSynthesizer.speak(speechUtterance)
    }
    
    @objc func displayNextQuestion(){
        if currentQues < totalQues{
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.answerCollection.layer.add(transition, forKey: nil)
            answerCollection.tag += 1
            self.answerCollection.reloadData()
            currentQues += 1
            setupQuestion()
        }
    }
    
     //MARK:- Button Actions
    
    @IBAction func cmdCancel(_ sender: UIButton) {
        Utility.showksAlertMessageWithOkAndCancelAction(title: "Exit", message: "Are you Sure", view: self) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cmdPrevious(_ sender: UIButton) {
        if currentQues > 1{
            let transition = CATransition()
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            self.answerCollection.layer.add(transition, forKey: nil)
            answerCollection.tag -= 1
            self.answerCollection.reloadData()
            currentQues -= 1
            setupQuestion()
        }

    }
    
    @IBAction func cmdNext(_ sender: UIButton) {
        displayNextQuestion()
    }
    @IBAction func cmdPlaySound(_ sender: UIButton) {
        self.playSoundWith(SpeechString: speechString)
    }
    
}

//MARK:- Implement Collection View Methods
//MARK:-
extension playVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 20
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collection = self.answerCollection{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            let height = (collection.bounds.height - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: height)
        }else{
            return CGSize(width: 0, height: 0)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameId == 2{
            return 1
        }
        return collectionCount ?? 0
        // return 70
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "answerCell", for: indexPath) as! answerCell
        cell.addSahadow()
        let wordArr : [wordModel] = self.MainArr[collectionView.tag]
        let word : wordModel = wordArr[indexPath.row]
        if collectionCount == 3 && indexPath.row == 2{
            cell.frame = CGRect(x: cell.frame.origin.x + (cell.frame.width/2), y: cell.frame.origin.y, width: cell.frame.width , height: cell.frame.height)
        }
        cell.imgSign.image = UIImage(data: word.sign!)
        cell.lblWord.text = word.name!
        
        if self.gameId == 1{
            if collectionView.tag >= totalQues/2{
                cell.lblWord.isHidden = true
                cell.imgSign.isHidden = false
            }else{
                cell.imgSign.isHidden = true
                cell.lblWord.isHidden = false
            }
        }else if self.gameId == 2{
            cell.frame = CGRect(x: (collectionView.frame.width/2) - (cell.frame.width/2), y: cell.frame.origin.y, width: cell.frame.width , height: cell.frame.height)
            cell.imgSign.image = UIImage(data: refWord.sign!)
            cell.lblWord.text = refWord.name!
            if collectionView.tag >= totalQues/2{
                cell.lblWord.isHidden = true
                cell.imgSign.isHidden = false
            }else{
                cell.imgSign.isHidden = true
                cell.lblWord.isHidden = false
            }
        }else{
            if collectionView.tag%2 == 0{
                if indexPath.row%3 == 0{
                    cell.imgSign.isHidden = true
                    cell.lblWord.isHidden = false
                }else{
                    cell.lblWord.isHidden = true
                    cell.imgSign.isHidden = false
                }
            }else{
                if indexPath.row%3 == 0{
                    cell.lblWord.isHidden = true
                    cell.imgSign.isHidden = false
                }else{
                    cell.imgSign.isHidden = true
                    cell.lblWord.isHidden = false
                }
            }
            
        }
        cell.layer.borderWidth = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.2 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wordArr : [wordModel] = self.MainArr[collectionView.tag]
        let word : wordModel = wordArr[indexPath.row]
        //if self.gameId == 1{
            if tagArr.contains(collectionView.tag){
                Utility.showAlertMessage(title: Constant().TITLE, message: "You have already answered to this question", view: self)
            }else{
                if word.word_id == refWord.word_id{
                    if refReward.reward_Type == Constant().RewardType.AUDIO{
                        self.playSoundWith(SpeechString: refReward.reward_Text!)
                    }
                }else{
                    var iPath = IndexPath()
                    if let ind = wordArr.firstIndex(where: { $0.word_id == refWord.word_id }){
                        iPath = IndexPath(row: ind, section: 0)
                    }
                    let cell = collectionView.cellForItem(at: iPath) as! answerCell
                    cell.layer.borderWidth = 5.0
                    cell.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.8823529412, blue: 0.04705882353, alpha: 1)
                    self.playSoundWith(SpeechString: "Wrong Answer")
                    
                }
            }
            
            self.tagArr.append(collectionView.tag)
            self.perform(#selector(displayNextQuestion), with: nil, afterDelay: 1.0)
   //     }
    /*else if self.gameId == 3{
            
            if tagArr.contains(collectionView.tag){
                Utility.showAlertMessage(title: Constant().TITLE, message: "You have already answered to this question", view: self)
            }else{
                if word.word_id == refWord.word_id{
                    if indexarr.count > 0{
                        if let ind = indexarr.firstIndex(where:{ $0 == indexPath.row }){
                            indexarr.remove(at: ind)
                        }
                    }
                    if indexarr.count == 0{
                        self.playSoundWith(SpeechString: refReward.reward_Text!)
                        self.tagArr.append(collectionView.tag)
                        self.perform(#selector(displayNextQuestion), with: nil, afterDelay: 1.0)
                    }
                }else{
                    for item in indexarr{
                        let iPath = IndexPath(row: item, section: 0)
                        let cell = collectionView.cellForItem(at: iPath) as! answerCell
                        cell.layer.borderWidth = 5.0
                        cell.layer.borderColor = #colorLiteral(red: 0.9176470588, green: 0.8823529412, blue: 0.04705882353, alpha: 1)
                    }
                    self.playSoundWith(SpeechString: "Wrong Answer")
                    self.tagArr.append(collectionView.tag)
                    self.perform(#selector(displayNextQuestion), with: nil, afterDelay: 1.0)
                }
            }
           
        }*/

    }
    
}

//MARK:- Cell Custom Class
//MARK:-
class answerCell:UICollectionViewCell{
    @IBOutlet weak var lblWord: UILabel!
    
    @IBOutlet weak var imgSign: UIImageView!
}

extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}