//
//  FullScreenVC.swift
//  VideoPlayer
//
//  Created by Shivaditya Kumar on 09/05/22.
//

import UIKit
import AVFoundation

class FullScreenVC: UIViewController {
    var playerLayer: AVPlayerLayer?
    var backButton =  UIButton()
    var hideBackButton = true {
        didSet {
            if hideBackButton {
                self.backButton.isHidden = hideBackButton
            } else {
                self.backButton.isHidden = hideBackButton
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        playerLayer!.frame = self.view.layer.bounds
        playerLayer!.videoGravity = AVLayerVideoGravity.resize
        self.playerLayer!.removeFromSuperlayer()
        self.view.layer.addSublayer(playerLayer!)
        self.backButton.setTitle("Exit", for: .normal)
        self.backButton.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        self.backButton.addTarget(self, action: #selector(didBackButtonTap), for: .touchUpInside)
        self.view.addSubview(backButton)
        self.backButton.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        hideBackButton = !hideBackButton
    }
    @objc func didBackButtonTap() {
        self.dismiss(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
    }
    class func instantiate(playerLayer: AVPlayerLayer) -> FullScreenVC {
        let vc = UIStoryboard.fullScreen.instanceOf(viewController: FullScreenVC.self)!
        vc.playerLayer = playerLayer
        return vc
    }
    
}
