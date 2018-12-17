//
//  AnimalSlideViewController.swift
//  Ecopedia_MVP
//
//  Created by Anatoliy Anatolyev on 10.12.2018.
//  Copyright © 2018 Valeriy. All rights reserved.
//

import UIKit
import AVFoundation

class AnimalSlideViewController: UIViewController {
    
    
    
    //IB Outlets
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!

    /////
    private var audioplayer = AVAudioPlayer()
    private var currenAnimalModel = ItemModel()
    
    private var timer = Timer()
    
    private var audioPlayerIsAvailable = false
    private var defaulAudioButtonsY: CGFloat = 0
 
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initializeWith(tag:Int) {
        currenAnimalModel = DataBase.shared.getItemModelBy(tag: tag)
        
        nameLabel.text = currenAnimalModel.name
        if currenAnimalModel.imageForListName != nil, let image = UIImage(named: currenAnimalModel.imageForListName!) {
                animalImageView.image = image
            }
        
        progressBar.setValue(0, animated: false)
        timeLabel.text = "No Audio"
        progressBar.isEnabled = false
        playBtn.isEnabled = false
        stopBtn.isEnabled = false
        
        playBtn.alpha = 1
        stopBtn.alpha = 0
        
        defaulAudioButtonsY = playBtn.frame.origin.y
        
        initAudioPlayer()
        
        let descriptoins = DescripTionForAnimals()
        if let description = descriptoins.descriptions[currenAnimalModel.tag] {
            if !description.isEmpty {
                    descriptionTextView.text = description
            }
        }
    }
    
    func initAudioPlayer() {
        if let fileName = currenAnimalModel.audioSlideResourceName, !fileName.isEmpty {

            do {
                audioplayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: Consts.defaultSlideAudioFormat)!))
                audioplayer.prepareToPlay()
                audioplayer.delegate = self
                initAudioControls()
                audioPlayerIsAvailable = true
            } catch
            {
                proceedNoAudioAlert()
                audioPlayerIsAvailable = false
            }
            
        } else { proceedNoAudioAlert(noId: true); audioPlayerIsAvailable = false }
        
    }
    
    func initAudioControls(){
        timeLabel.text = "00m:00s"
        progressBar.isEnabled = true
        playBtn.isEnabled = true
        stopBtn.isEnabled = true
    }
    
    func proceedNoAudioAlert (noId: Bool = false) {
        
        var errortxt = ""
        if noId {
            errortxt = "Извините, но для этого аудиофайла отсутствует ссылка в конфиге))). Отметить животное как посещенное?"
        }else {
            errortxt = "Извините, но аудиофайл для этого животного пока недоступен. Отметить животное как посещенное?"
        }
        
        let noAudioAlert = UIAlertController(title: "ERROR", message: errortxt, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel)
        noAudioAlert.addAction(noAction)
        
        let okAction = UIAlertAction(title: "Да", style: .default)
        { (alrt) in
            self.setAnimalAsVisited()
        }
            noAudioAlert.addAction(okAction)
        present(noAudioAlert, animated: true, completion: nil)
    }
    
    private func proceedWrongUrlAlert() {
        let noUrlAlert = UIAlertController(title: "ERROR", message: "Извините, но веб страничка для этого животного пока недоступна", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        noUrlAlert.addAction(okAction)
        present(noUrlAlert, animated: true, completion: nil)
    }
    
    func playSlideAudio(withButtonAnimation: Bool = true) {
        if audioPlayerIsAvailable {
            audioplayer.play()
            setAnimalAsVisited()
            if !timer.isValid {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
            }
            
            if withButtonAnimation {
                
                let topY = defaulAudioButtonsY - 20
                let bottomY = defaulAudioButtonsY + 20
                stopBtn.frame.origin.y = topY
                UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                    self.playBtn.alpha = 0
                    self.stopBtn.alpha = 1
                    self.playBtn.frame.origin.y = bottomY
                    self.stopBtn.frame.origin.y = self.defaulAudioButtonsY
                }
                
            }
        }
    }
    
    func  stopAudioSlide(withButtonAnimation: Bool = true){
        if audioPlayerIsAvailable {
            audioplayer.stop()
            
            if withButtonAnimation {
                let topY = defaulAudioButtonsY - 20
                let bottomY = defaulAudioButtonsY + 20
                playBtn.frame.origin.y = topY
                UIView.animate(withDuration: Consts.serviceViewAnimationsDuration) {
                    self.playBtn.alpha = 1
                    self.stopBtn.alpha = 0
                    self.playBtn.frame.origin.y = self.defaulAudioButtonsY
                    self.stopBtn.frame.origin.y = bottomY
                }
            }
        }
        if timer.isValid {
            timer.invalidate()
        }
    }
    
    func setAudioslideToStart(andPlay: Bool = false)  {
        if audioPlayerIsAvailable {
            audioplayer.currentTime = 0
            updateTimeLabel()
            updateProgressBar()
            if andPlay {
                playSlideAudio()
            }
        }
    }
    
    private func setAnimalAsVisited(){
        
      DataBase.shared.setVizitedItemBy(tag: currenAnimalModel.tag)
        
        
        
    }
    
    @objc func timerTick() {
        updateTimeLabel()
        updateProgressBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if audioPlayerIsAvailable {
            stopAudioSlide()
        }
    }
    
    private func updateProgressBar(){
        if audioPlayerIsAvailable {
            let progress = Float((audioplayer.currentTime) /  (audioplayer.duration))
            progressBar.setValue(progress, animated: false)
        }
    }
    
    private func updateTimeLabel(){
        if audioPlayerIsAvailable {
            let seconds = Int((audioplayer.currentTime))
            var pref = "0"
            
            if seconds < 10 {
                pref = "0"
            }else{
                pref = ""
            }
            timeLabel.text = "00m:" + pref + "\(seconds)s"
        }
    }
    
    @IBAction func playBtnDidTap(_ sender: Any) {
        playSlideAudio()
    }
    @IBAction func stopBtnDidTap(_ sender: Any) {
       stopAudioSlide()
    }

    
    @IBAction func progressBarAction(_ sender: Any) {
        if audioPlayerIsAvailable {
            audioplayer.currentTime = audioplayer.duration * Double(progressBar.value)
//            if audioplayer.isPlaying {
//                playSlideAudio(withButtonAnimation: false)
//            }
            updateTimeLabel()
        }
        let bar = sender as! UISlider
        bar.addTarget(self, action: #selector(sliderDidTouchUp), for: .touchUpInside)
        
    }
    
    @objc func sliderDidTouchUp(){
        if audioPlayerIsAvailable {
            if audioplayer.isPlaying {
                playSlideAudio(withButtonAnimation: false)
            }
        }
    }
    
    @IBAction func showWebPageBtnDidTap(_ sender: Any) {
        if let stringUrl = currenAnimalModel.animalURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: stringUrl)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            proceedWrongUrlAlert()
        }
    }

}

extension AnimalSlideViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudioSlide()
        setAudioslideToStart()
        setAnimalAsVisited()
    }
}



