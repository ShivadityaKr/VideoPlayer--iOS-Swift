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

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
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
    @IBOutlet weak var durationStackView: UIStackView!
    @IBOutlet weak var fullScreenButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityLoader.hidesWhenStopped = true
        
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
    var playerLayer: AVPlayerLayer!
    func setPlayer() {
        DispatchQueue.main.async {
            self.activityLoader.startAnimating()
        }
        let videoURL = URL(string: self.videoURL)
        playerItem = AVPlayerItem(url: videoURL!)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.contentView.bounds
        DispatchQueue.main.async {
            self.contentView.layer.addSublayer(self.playerLayer)
            self.playButton.addTarget(self, action: #selector(self.didPlayPauseButtonTapp), for: .touchUpInside)
            self.prevButton.addTarget(self, action: #selector(self.didBackButtonTapp), for: .touchUpInside)
            self.nextButton.addTarget(self, action: #selector(self.didNextButtonTapp), for: .touchUpInside)
            self.seekBackwardButton.addTarget(self, action: #selector(self.didSeekBackTap), for: .touchUpInside)
            self.seekForwardButton.addTarget(self, action: #selector(self.didSeekForwardTap), for: .touchUpInside)
        }
//        player?.play()
        player?.playImmediately(atRate: 1.0)
        
        // playback slider
        DispatchQueue.main.async { [self] in
            self.progressBar!.minimumValue = 0
            let duration : CMTime = (self.playerItem?.asset.duration)!
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.progressBar!.maximumValue = Float(seconds)
            self.progressBar!.isContinuous = false
            self.progressBar!.tintColor = .black
            self.progressBar?.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
        }
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
                self.activityLoader.stopAnimating()
            }
        }
    }
    func setupUI() {
        self.activityLoader.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.titleLabel.text = self.videoTitle
        self.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        self.playButton.layer.cornerRadius = playButton.bounds.width / 4
        self.playButton.backgroundColor = .black
        self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        self.fullScreenButton.addTarget(self, action: #selector(didTapOnFullScreenButton), for: .touchUpInside)
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
        self.activityLoader.startAnimating()
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.playImmediately(atRate: 1)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        self.activityLoader.stopAnimating()
    }
    private func changeValueForLabel(){
        //        startTimeLabel.text = String(round(self.player?.currentTime ?? 0.0))
    }
    @objc func didSeekBackTap(){
        self.activityLoader.startAnimating()
        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
        let seconds : Int64 = Int64(round(time))
        let targetTime:CMTime = CMTimeMake(value: seconds - 10, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.playImmediately(atRate: 1)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        self.activityLoader.stopAnimating()
    }
    @objc func didSeekForwardTap(){
        self.activityLoader.startAnimating()
        let time : Float64 = CMTimeGetSeconds(self.player!.currentTime())
        let seconds : Int64 = Int64(round(time))
        let targetTime:CMTime = CMTimeMake(value: seconds + 10, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0
        {
            player?.playImmediately(atRate: 1)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        self.activityLoader.stopAnimating()
    }
    @objc func didNextButtonTapp(){
        
    }
    @objc func didBackButtonTapp(){
        
    }
    @objc func didPlayPauseButtonTapp(){
        self.activityLoader.startAnimating()
        if player?.rate != 0
        {
            player!.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player!.playImmediately(atRate: 1)
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        self.activityLoader.stopAnimating()
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
    func showAndHideViews(command: Bool) {
        self.backButton.isHidden = command
        self.titleLabel.isHidden = command
        self.durationStackView.isHidden = command
        self.progressBar.isHidden = command
        self.stackView.isHidden = command
    }
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        playerLayer.frame = self.contentView.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resize
        self.playerLayer.removeFromSuperlayer()
        self.contentView.layer.addSublayer(playerLayer)
    }
    @objc func didTapOnFullScreenButton() {
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeLeft)
        let vc = FullScreenVC.instantiate(playerLayer: playerLayer)
        self.present(vc, animated: true)
    }
    class func instantiate() -> PlayerVC {
        let vc = UIStoryboard.player.instanceOf(viewController: PlayerVC.self)!
        return vc
    }
}
