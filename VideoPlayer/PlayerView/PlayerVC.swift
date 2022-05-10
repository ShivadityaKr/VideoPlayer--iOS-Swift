//
//  PlayerVC.swift
//  VideoPlayer
//
//  Created by Shivaditya Kumar on 09/05/22.
//

import UIKit
import AVFoundation
import AVKit
class PlayerVC: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var seekBackwardButton: UIButton!
    @IBOutlet weak var seekForwardButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var stackView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        inActiveView()
        DispatchQueue.global().async {
            self.setPlayer()
        }
    }
    var videoURL: String = ""
    var videoTitle: String = ""
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    func setPlayer() {
        let videoURL = URL(string: self.videoURL)
        playerItem = AVPlayerItem(url: videoURL!)
        player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.contentView.bounds
        self.contentView.layer.addSublayer(playerLayer)
//        player?.play()
        player?.playImmediately(atRate: 1.0)
        playButton.addTarget(self, action: #selector(didPlayPauseButtonTapp), for: .touchUpInside)
        prevButton.addTarget(self, action: #selector(didBackButtonTapp), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didNextButtonTapp), for: .touchUpInside)
        seekBackwardButton.addTarget(self, action: #selector(didSeekBackTap), for: .touchUpInside)
        seekForwardButton.addTarget(self, action: #selector(didSeekForwardTap), for: .touchUpInside)
        // playback slider
        progressBar!.minimumValue = 0
        let duration : CMTime = (playerItem?.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
        progressBar!.maximumValue = Float(seconds)
        progressBar!.isContinuous = false
        progressBar!.tintColor = .black
        progressBar?.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                let endTime : Float64 = CMTimeGetSeconds(self.player!.currentItem!.duration);
                self.progressBar!.value = Float ( time )
                let secs = Int(time)
                let endSecs = Int(endTime)
                self.startTimeLabel.text = NSString(format: "%02d:%02d", secs/60, secs%60) as String
                self.endTimeLabel.text = NSString(format: "%02d:%02d", endSecs/60, endSecs%60) as String
                self.activeView()
            }
        }
    }
    func setupUI() {
        self.titleLabel.text = self.videoTitle
        self.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        self.playButton.layer.cornerRadius = playButton.bounds.width / 4
        self.playButton.backgroundColor = .black
        self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }
    @objc func didTapBackButton() {
        if let player = player {
            player.pause()
            player.replaceCurrentItem(with: nil)
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        self.dismiss(animated: true)
    }
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    private func changeValueForLabel(){
        //        startTimeLabel.text = String(round(self.player?.currentTime ?? 0.0))
    }
    @objc func didSeekBackTap(){
        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
        let seconds : Int64 = Int64(round(time))
        let targetTime:CMTime = CMTimeMake(value: seconds - 10, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @objc func didSeekForwardTap(){
        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
        let seconds : Int64 = Int64(round(time))
        let targetTime:CMTime = CMTimeMake(value: seconds + 10, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    @objc func didNextButtonTapp(){
        
    }
    @objc func didBackButtonTapp(){
        
    }
    @objc func didPlayPauseButtonTapp(){
        if player?.rate != 0
        {
            player!.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player!.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    func activeView() {
        stackView.alpha = 1
    }
    func inActiveView() {
        stackView.alpha = 0.3
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    class func instantiate() -> PlayerVC {
        let vc = UIStoryboard.player.instanceOf(viewController: PlayerVC.self)!
        return vc
    }
}
