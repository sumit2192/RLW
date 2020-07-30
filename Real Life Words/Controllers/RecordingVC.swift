//
//  RecordingVC.swift
//  Real Life Words
//
//  Created by Mac on 30/07/20.
//  Copyright © 2020 Invito Softwares. All rights reserved.
//

import UIKit
import Speech
import AVKit
import AVFoundation

class RecordingVC: UIViewController {

    
    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Outlets
    //------------------------------------------------------------------------------
    
    @IBOutlet weak var cancelRecord             : UIButton!
    @IBOutlet weak var btnAdd             : UIButton!
    @IBOutlet weak var btnStart             : UIButton!
    @IBOutlet weak var lblText              : UILabel!
    @IBOutlet weak var lblCount              : UILabel!
    @IBOutlet weak var imgVw                : UIImageView!

//    @IBOutlet var recordButton: UIButton!
//    @IBOutlet var playButton: UIButton!
    
    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Variables
    //------------------------------------------------------------------------------

    var samanthaVoice : AVSpeechSynthesisVoice?
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!

    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0

    var timerIsPaused : Bool = false
    var timer : Timer!
    var Last_Reward_id : Int = 0
    var refUrl: String?
    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- View Life Cycle Methods
    //------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        btnAdd.setButtonTitle(Title: "Add")
        let rewardsArr:[rewardModel] = persistenceStrategy.getRewards(Entity:  Constant().Table.REWARD, predicate: nil)
        if rewardsArr.count > 0{
            self.Last_Reward_id = rewardsArr.count
        }
        self.setupView()
    }

    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Action Methods
    //------------------------------------------------------------------------------

    @IBAction func camdStartStopPlay(_ sender: UIButton){
        switch sender.tag {
        case 0:
            self.imgVw.image = UIImage(named: "Record2")
            self.startTimer()
            let systemSoundID: SystemSoundID = 1113
            AudioServicesPlaySystemSound (systemSoundID)
            self.startRecording()
        case 1:
            self.finishRecording(success: true)
            self.imgVw.image = UIImage(named: "Record3")
            self.stopTimer()
            self.btnAdd.isHidden = false
            self.cancelRecord.isHidden = false
        default:
            self.startTimer()
            preparePlayer()
            audioPlayer.play()
        }
        if sender.tag < 2{
            sender.tag += 1
        }else{
           // sender.tag = 0
        }
        
    }
    
    @IBAction func cmdAdd(_ sender: UIButton) {
        
        let image = UIImage(named: "Baloon.png")
        let imagedata : Data? = image?.pngData()
        
        let Data: [String: Any] = [
            "reward_id": self.Last_Reward_id + 1,
            "reward_Type": "Audio",
            "reward_Text": "",
            "reward_Image": imagedata!,
            "reward_URL": refUrl!
        ]
        print(Data)
        if let reward = persistenceStrategy.addReward(Entity: Constant().Table.REWARD, data: Data){
            print(reward.reward_id!)
            self.dismiss(animated: true) {
                
            }
        }

    }
    
    @IBAction func cmdCancelRecord(_ sender: UIButton) {

        self.btnAdd.isHidden = false
        self.cancelRecord.isHidden = true
        self.btnStart.tag = 0
        self.imgVw.image = UIImage(named: "Record1")

    }
    
    @IBAction func cmdDismiss(_ sender: UIButton) {
        // Add to Database
        self.dismiss(animated: true) {
            
        }

    }

    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Custom Methods
    //------------------------------------------------------------------------------
    
    func setupView() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                       // self.loadRecordingUI()
                        print("Audio Allowed")
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    func startTimer(){
        timerIsPaused = false
        // 1. Make a new timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ tempTimer in
            // 2. Check time to add to H:M:S
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours = self.hours + 1
                } else {
                    self.minutes = self.minutes + 1
                }
            } else {
                self.seconds = self.seconds + 1
            }
            let secText = self.seconds < 10 ? String(format: "0%d", self.seconds) : String(format: "%d", self.seconds)
            let minText = self.minutes < 10 ? String(format: "0%d", self.minutes) : String(format: "%d", self.minutes)
            self.lblCount.text = String(format: "%@:%@", minText,secText)
        }
    }
    
    func stopTimer(){
        timerIsPaused = true
        timer.invalidate()
        timer = nil
        hours = 0
        seconds = 0
        minutes = 0
        self.lblCount.text = "00:00"
    }
    
    func startRecording() {

        let audioFilename = getFileURL()
        refUrl = audioFilename.absoluteString
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    @objc func recordAudioButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func preparePlayer() {
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL() as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 10.0
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getFileURL() -> URL {
        let str = String(format: "recording_%d.m4a", Last_Reward_id+1)
        let path = getDocumentsDirectory().appendingPathComponent(str)
       // guard let data = try? Data(contentsOf:path) else { return }
        return path as URL
    }
    


}

extension RecordingVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopTimer()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
}
