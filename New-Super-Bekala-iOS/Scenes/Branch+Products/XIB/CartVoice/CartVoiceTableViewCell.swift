//
//  CartVoiceTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import AVFoundation

class CartVoiceTableViewCell: UITableViewCell {
    
    static let identifier = "CartVoiceTableViewCell"

    @IBOutlet weak var voiceSlider: UISlider!
    @IBOutlet weak var currentDuration: UILabel!
    @IBOutlet weak var voiceLength: UILabel!
    @IBOutlet weak var pause_resume_btn: UIButton!
    
    var player : AVAudioPlayer?
    var timer : Timer?
    var currentPlayingTime : Float?
    var minutes : Int?
    var seconds : Int?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        player = nil
        timer = nil
        voiceSlider.value = 0
        currentDuration.text = "00:00"
        voiceLength.text = "00:00"
    }
    
    func loadFrom(data: Data){
        do{
            
            player = try AVAudioPlayer(data: data)
            self.initPlayer()
            self.pause_resume_btn.onTap {
                self.play_pause()
            }
            
        }catch let err{
            print(err)
        }
    }
    
    func initPlayer(){
        
        guard player != nil else { return }
        player!.prepareToPlay()
        player!.volume = 1.0
        let audioLength = Int(player!.duration)
        minutes = Int(audioLength / 60)
        seconds = audioLength - minutes! * 60
        self.voiceLength.text = "\(minutes ?? 00):\(seconds ?? 00)"
        voiceSlider.maximumValue = Float(player!.duration)
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(setSliderValue), userInfo: nil, repeats: true)
        
    }
    
    @objc func setSliderValue(){
        
        guard player != nil else { return }
        
        if player?.isPlaying == false {
            
            pause_resume_btn.setImage(UIImage(named: "play-icon"), for: .normal)
            
        }else{
            
            pause_resume_btn.setImage(UIImage(named: "pause-1"), for: .normal)
            currentPlayingTime = Float((player?.currentTime)!)
            UIView.animate(withDuration: 0.05, animations: {
                self.voiceSlider.setValue(self.currentPlayingTime!, animated: true)
            }) { (_) in
                
            }
            updateTime()
            
        }
    }
    
    func updateTime(){
        
        guard player != nil else{ return }
        let currentTime = Int(player!.currentTime)
        let minutes = currentTime/60
        var seconds = currentTime - minutes / 60
        if minutes > 0 {
            seconds = seconds - 60 * minutes
        }
        
        currentDuration.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        
    }
    
    func play_pause(){
        
        if player?.isPlaying == false{
            
            pause_resume_btn.setImage(UIImage(named: "pause-1"), for: .normal)
            player?.play()
            
        }else{
            
            pause_resume_btn.setImage(UIImage(named: "play-icon"), for: .normal)
            player?.pause()
            
        }
        
    }
    
}
