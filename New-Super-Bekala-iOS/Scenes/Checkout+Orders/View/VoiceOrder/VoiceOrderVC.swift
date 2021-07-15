//
//  VoiceOrderVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

import UIKit
import AVFoundation

class VoiceOrderVC: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var recordAgainBtn: UIButton!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    @IBOutlet weak var playRecordView: UIView!
    @IBOutlet weak var voiceSlider: UISlider!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var microphone: UIImageView!
    @IBOutlet weak var addToCart: ViewCorners!
    @IBOutlet weak var actionLbl: UILabel!
    
    var recordTimer: Timer?
    var avRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    var counter = 0
    var recorderState: RecorderState = .initial
    var scheduledTimer: Timer?
    var voiceCounter = 0
    var branch: Branch?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecordSession()
        actionBtn.onTap {
            self.takeTheAction()
        }
        
        backBtn.onTap {
            self.navigationController?.popViewController(animated: true)
        }
        
        self.hideHideRecordAgainBtn()
        
        recordAgainBtn.onTap {
            
            self.playRecordRing()
            self.recorderState = .initial
            self.takeTheAction()
            self.timer.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.playRecordView.alpha = 0
                self.playRecordView.isHidden = true
                self.timer.isHidden = false
                self.timer.alpha = 1
            }
            self.hideHideRecordAgainBtn()
            self.voiceCounter = 0
        }
        
        if branch == nil{
            actionLbl.text = "Checkout"
        }
        
    }
    
    func hideHideRecordAgainBtn(){
        recordAgainBtn.isHidden = true
        recordAgainBtn.alpha = 0
        microphone.isHidden = true
        microphone.alpha = 0
    }
    
    func playRecordRing(){
        
        let startRecordingRing = URL(fileURLWithPath: Bundle.main.path(forResource: "Start_Recording_Ring", ofType: "mp3")!)
        var audioPlayer = AVAudioPlayer()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: startRecordingRing)
            audioPlayer.prepareToPlay()
            
        } catch let error{
            print("ring error",error)
        }
        audioPlayer.play()
    }
    
    func takeTheAction(){
        
        self.addToCart.alpha = 1
        
        switch recorderState {
            
        case .initial:
            
            playRecordRing()
            actionImage.image = UIImage(named: "stop_recording")
            recorderState = .recording
            recordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            timer.text = "00:00"
            counter = 0
            avRecorder.record()
            self.addToCart.alpha = 0.5
            
        case .recording:
            
            actionImage.image = UIImage(named: "play")
            recorderState = .readyToPlay
            recordTimer?.invalidate()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendVoiceOrder"), object: nil)
            avRecorder.stop()
            UIView.animate(withDuration: 0.5) {
                self.recordAgainBtn.isHidden = false
                self.recordAgainBtn.alpha = 0.5
                self.microphone.isHidden = false
                self.microphone.alpha = 1
            }
            
        case .readyToPlay:
            
            actionImage.image = UIImage(named: "pause")
            recorderState = .playing
            UIView.animate(withDuration: 0.5) {
                self.timer.alpha = 0
                self.playRecordView.isHidden = false
                self.playRecordView.alpha = 1
            }
            self.timer.isHidden = true
            audioPlayer = try? AVAudioPlayer(contentsOf: Recorder.getURL())
            audioPlayer!.prepareToPlay()
            audioPlayer!.volume = 1.0
            audioPlayer?.play()
            let audioLength = Int(audioPlayer!.duration)
            let minutes = Int(audioLength / 60)
            let seconds = audioLength - minutes * 60
            current.text = "00:00"
            length.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            voiceSlider.maximumValue = Float(audioPlayer!.duration-1.5)
            scheduledTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setSliderValue), userInfo: nil, repeats: true)
            
        case .playing:
            
            scheduledTimer?.invalidate()
            actionImage.image = UIImage(named: "play")
            recorderState = .paused
            audioPlayer?.pause()
            
        case .paused:
            
            actionImage.image = UIImage(named: "pause")
            recorderState = .playing
            audioPlayer?.play()
            current.text = "00:00"
            voiceCounter = 0
            scheduledTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setSliderValue), userInfo: nil, repeats: true)
    
        }
    }
    
    @objc func setSliderValue(){
        
        let currentPlayingTime = Float((audioPlayer?.currentTime)!)
        UIView.animate(withDuration: 1.5) {
            self.voiceSlider.setValue(currentPlayingTime, animated: true)
        }
        
        if current.text == length.text{
            scheduledTimer?.invalidate()
            recorderState = .paused
            actionImage.image = UIImage(named: "play")
            return
        }
        
        voiceCounter += 1
        let minutes = voiceCounter/60
        var seconds = voiceCounter - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        current.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    func setupRecordSession(){
        
        do{
            try Recorder.setupSession {
                (allowed) in
                if allowed{
                    
                    self.avRecorder = try? AVAudioRecorder(url: Recorder.getURL(), settings: Recorder.AVREC_SETTING)
                    self.avRecorder.delegate = self
                    self.actionBtn.isEnabled = true
                    self.counter += 1
                    
                }
            }
            
        }catch{
            showAlert(title: "", message: "Something going wrong")
        }
        
        if Recorder.instance.recordingSession.recordPermission == .granted{
            self.actionBtn.isEnabled = true
        }
        
    }

    @objc func updateTime(){
        counter += 1
        let minutes = counter/60
        var seconds = counter - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        timer.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    @IBAction func addToCart(_ sender: Any) {
        guard recorderState != .recording, recorderState != .initial else { return }
        if let _ = branch{
            do{
                let voiceData = try Data(contentsOf: Recorder.getURL())
                var product = Product()
                product.voice = voiceData
                product.branch = branch
                CartServices.shared.addToCart(product) { (completed) in
                    if completed{
                        self.navigationController?.popViewController(animated: true)
                    }
                } 
            }catch{}
        }else{
            
        }
    }
    

}

enum RecorderState{
    case initial
    case recording
    case readyToPlay
    case playing
    case paused
}
