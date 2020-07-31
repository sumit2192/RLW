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
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance =  AVSpeechUtterance()
    var samanthaVoice : AVSpeechSynthesisVoice?
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
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
    var refAudioText: String?
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
        if let str = refAudioText{
            let image = UIImage(named: "Baloon.png")
            let imagedata : Data? = image?.pngData()
            let Data: [String: Any] = [
                "reward_id": self.Last_Reward_id + 1,
                "reward_Type": "Audio",
                "reward_Text": str,
                "reward_Image": imagedata!,
                "reward_URL": refUrl!
            ]
            print(Data)
            if (persistenceStrategy.addReward(Entity: Constant().Table.REWARD, data: Data)) != nil{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Fetch_Rewards"), object: nil )
                self.dismiss(animated: true) {
                    
                }
            }
        }else{
            Utility.showKSAlertMessageWithOkAction(title: Constant().TITLE, message: "Unable to detect the speech. Please try again", view: self) {
                self.dismiss(animated: true, completion: nil)
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
    
        func startDetecting() {
            
            if recognitionTask != nil {
                recognitionTask?.cancel()
                recognitionTask = nil
            }

            // Create instance of audio session to record voice
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
            }

            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

            let inputNode = audioEngine.inputNode

            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
            }

            recognitionRequest.shouldReportPartialResults = true

            self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

                var isFinal = false
                var speechStr : String?
                if result != nil {

                   // self.lblText.text = result?.bestTranscription.formattedString
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                    speechStr = result?.bestTranscription.formattedString
                    self.refAudioText = speechStr
                    isFinal = (result?.isFinal)!
                }

                if error != nil || isFinal {

                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)

                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            })
            
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                self.recognitionRequest?.append(buffer)
            }

            self.audioEngine.prepare()

            do {
                try self.audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }

           // self.lblText.text = "Say something, I'm listening!"
        }
    func startRecording() {
        startDetecting()
        let audioFilename = getFileURL()
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
        refUrl = str
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
