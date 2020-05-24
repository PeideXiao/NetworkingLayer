//
//  PDPlayerView.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/22/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PDPlayer: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fullSizeBtn: UIButton!
    @IBOutlet weak var loadProgressView: UIProgressView!
    @IBOutlet weak var toolStackView: UIStackView!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var playerItem: AVPlayerItem!
    var playTimeObserver: Any!
    var isPlaying: Bool = false
    var isPortrait: Bool = true;
    var timer: Timer?
    var superVC: UIViewController!
    
    var fileURL: URL! {
        didSet {
            self.playerItem = AVPlayerItem(url: fileURL);
            self.player.replaceCurrentItem(with: self.playerItem);
            addObserversAndNotification();
        }
    }
    var oriFrame: CGRect!
    
    
    // MARK: deinit
    
    init(frame: CGRect, superVC:UIViewController) {
        self.oriFrame = frame;
        self.superVC = superVC;
        super.init(frame: frame)
        commonInit();
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit();
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("PDPlayer", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        self.progressSlider.setThumbImage(UIImage(named: "MoviePlayer_Slider"), for: UIControl.State.normal);
        
        self.player = AVPlayer();
        playerLayer = AVPlayerLayer(player: self.player);
        playerLayer.videoGravity = .resize
        playerLayer.frame = self.bounds;
        self.playerView.layer.addSublayer(playerLayer);
        
    }
    
    func addObserversAndNotification() {
        // to background
        NotificationCenter.default.addObserver(self, selector: #selector(goBackground), name: NSNotification.Name.NSExtensionHostDidEnterBackground, object: nil);
        // to for
        NotificationCenter.default.addObserver(self, selector: #selector(backToForground), name: NSNotification.Name.NSExtensionHostWillEnterForeground, object: nil);
        
        // play completed
        
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd(noti:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil);
        
        // interruption play
        NotificationCenter.default.addObserver(self, selector: #selector(interruption), name: AVAudioSession.interruptionNotification, object: nil);
        // scren
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientation(noti:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        //KVO
        // status
        playerItem.addObserver(self, forKeyPath: "status", options: [.new], context: nil);
        
        
        // loadShuffle
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new], context: nil);
        
        self.monitoringPlayBack();
    }
    
    
    // MARK: Touch
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        toolStackView.isHidden = !toolStackView.isHidden;
        loadProgressView.isHidden = !loadProgressView.isHidden;
        self.superVC.navigationController?.navigationBar.isHidden = !(self.superVC.navigationController?.navigationBar.isHidden)!;
        self.hideToolView();
    }
    
    // MARK: XIBAction
    
    @IBAction func playOrPauseButtonDidClick(_ sender: UIButton) {
        if(isPlaying){
            self.pause()
        }
        else {
            self.play();
        }
    }
    
    @IBAction func sliderTouchUpInside(_ sender: UISlider) {
        self.play();
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        self.pause();
        let dragedCMTime = CMTimeMake(value: Int64(self.progressSlider.value), timescale: 1)
        print(Int64(self.progressSlider.value));
        self.playerItem.seek(to: dragedCMTime, completionHandler: nil);
    }
    
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        self.pause();
    }
    
    @IBAction func switchSizeButtonDidClick(_ sender: UIButton) {
        if isPortrait {
            self.landscapeRight();
        }
        else {
            self.portrait();
        }
    }
    
    @objc func handleOrientation(noti: NSNotification) {
        guard let device = noti.object as? UIDevice else {return}
        
        if device.orientation == .landscapeRight || device.orientation == .landscapeLeft {
            // full
            if (!isPortrait) {return}
            UIView.animate(withDuration: 0.1) {
            self.frame = UIScreen.main.bounds;
               self.contentView.frame = UIScreen.main.bounds;
               self.playerLayer.frame = UIScreen.main.bounds;
            }
            
            isPortrait = false;
        }
        else if (device.orientation == .portrait) {
            if (isPortrait) {return}
            UIView.animate(withDuration: 0.1) {
                self.contentView.frame = self.oriFrame;
                self.playerLayer.frame = CGRect(origin: .zero, size: self.oriFrame.size);
            }
            isPortrait = true;
        }
        else {}
    }
    
    
    // MARK: KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let item = object as? AVPlayerItem else {return}
        if (keyPath! == "status") {
            switch item.status {
            case .readyToPlay:
                print("ready to play")
                let duration = item.duration;
                let second = CMTimeGetSeconds(duration);
                self.progressSlider.maximumValue = Float(second);
                self.timeLabel.text = self.convertTime(second: second);
                self.play();
            case .failed:
                print("the player item can no longer be played because of an error. ")
            default:
                print("the status of the player item is not yet known.")
            }
        }
        else if (keyPath == "loadedTimeRanges") {
            let timeInterval = self.availableDurationRanges();
            let duration = playerItem.duration;
            let totalDuration = CMTimeGetSeconds(duration)
            self.loadProgressView.progress = Float(timeInterval/totalDuration);
        }
    }
    
    func availableDurationRanges() -> TimeInterval {
        let loadedTimeRanges = self.playerItem.loadedTimeRanges;
        let timeRange = loadedTimeRanges.first!.timeRangeValue;
        let startSecond = CMTimeGetSeconds(timeRange.start);
        let durationSecond = CMTimeGetSeconds(timeRange.duration);
        return TimeInterval(startSecond + durationSecond) // 缓冲进度
    }
    
    
    // MARK: playerTimeObersver
    
    func monitoringPlayBack() {
        playTimeObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 30), queue: DispatchQueue.main, using: { (time: CMTime) in
            
            let currentPlayTime = Float(self.playerItem.currentTime().value)/Float(self.playerItem.currentTime().timescale);
            print(currentPlayTime);
            self.progressSlider.value = currentPlayTime;
            self.currentTimeLabel.text = self.convertTime(second: TimeInterval(currentPlayTime))
        })
    }
    
    // MARK: Helper
    func convertTime(second: TimeInterval) -> String{
        let date = Date(timeIntervalSince1970: second)
        let dateFormatter = DateFormatter()
        if (second > 3600) {
            dateFormatter.dateFormat = "HH:mm:ss"
        }
        else{
            dateFormatter.dateFormat = "mm:ss"
        }
        return dateFormatter.string(from: date);
    }
    
    func removeObserver() {
        self.player.replaceCurrentItem(with: nil)
        self.playerItem.removeObserver(self, forKeyPath: "status")
        self.playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.player.removeTimeObserver(self.playTimeObserver!)
        self.playTimeObserver = nil
        self.timer?.invalidate();
        self.timer = nil;
        NotificationCenter.default.removeObserver(self)
    }
    
    func hideToolView() {
        if(!toolStackView.isHidden) {
            self.timer?.invalidate()
            self.timer = nil;
            let date = Date(timeIntervalSinceNow: 5);
            self.timer = Timer(fire: date, interval: 1, repeats: false, block: { (timer) in
                self.toolStackView.isHidden = true
                self.loadProgressView.isHidden = true;
                self.superVC.navigationController?.navigationBar.isHidden = true;
            })
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common);
        }
    }
    
    func landscapeRight() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation");
//        UIView.animate(withDuration: 0.1) {
//            self.frame = UIScreen.main.bounds;
//            self.contentView.frame = UIScreen.main.bounds;
//            self.playerLayer.frame = UIScreen.main.bounds;
//        }
//        isPortrait = false;
    }
    
    func portrait() {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation");
//        UIView.animate(withDuration: 0.1) {
//            self.contentView.frame = self.oriFrame
//            self.playerLayer.frame = CGRect(origin: .zero, size: self.oriFrame.size)
//        }
//
//        isPortrait = true;
    }
}


extension PDPlayer {
    
    @objc func goBackground() {
        print("goToBackground")
        self.pause();
    }
    
    @objc  func backToForground() {
        print("backToForground")
        self.play();
    }
    
    @objc func playToEnd(noti: Notification) {
        guard let item = noti.object as? AVPlayerItem else {return}
        print("finish playing")
        item.seek(to: .zero, completionHandler: nil);
        self.player.pause();
    }
    
    @objc func interruption(){
        print("interuption")
    }
    
    func play(){
        self.player.play();
        self.playBtn.setImage(UIImage(named: "MoviePlayer_Play"), for: .normal);
        isPlaying = true
        self.hideToolView();
    }
    
    func pause(){
        self.player.pause();
        self.playBtn.setImage(UIImage(named: "MoviePlayer_Stop"), for: .normal);
        isPlaying = false;
    }
}
