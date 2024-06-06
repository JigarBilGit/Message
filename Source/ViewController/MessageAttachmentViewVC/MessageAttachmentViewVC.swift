//
//  MessageAttachmentViewVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation
import AVKit

class MessageAttachmentViewVC: UIViewController {
    // MARK: 
    // MARK: IBOUTLET VARIABLE
    @IBOutlet weak var viewTopHeader: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: BMLabel!
    
    @IBOutlet weak var viewDocumentBG: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var viewImageBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAttachment: UIImageView!
    @IBOutlet weak var viewAttachmentText: UIView!
    @IBOutlet weak var lblAttachmentText: BMLabel!
    
    @IBOutlet weak var viewVideoPlayerBG: UIView!
    @IBOutlet weak var viewVideoPlayer: UIView!
    
    @IBOutlet weak var viewVideoControl: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var btnPlayPauseVideo: UIButton!
    @IBOutlet weak var btnVolume: UIButton!
    @IBOutlet weak var btnRewind: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var viewVideoControlHeight: NSLayoutConstraint!
    @IBOutlet weak var loaderView: LoaderView!
    
    // MARK: 
    // MARK: VARIABLE
    var isPDFAttachment : Bool = false
    var isDocumentAttachment : Bool = false
    var isVideoAttachment : Bool = false
    var attachmentData = Data()
    
    var viewSpinner:UIView?
    
    var strDocumentAttachmentTitle : String = ""
    
    var documentURL : URL?
    
    var strFilePath : String = ""
    
    var strAttachmentText : String = ""
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVQueuePlayer?
    private var playerItems: [AVPlayerItem]?
    private enum Constants {
        static let rewindForwardDuration: Float64 = 10 //in seconds
    }
    
    // MARK: 
    // MARK: Internal Properties
    public var isMuted = true {
        didSet {
            self.player?.isMuted = self.isMuted
            self.btnVolume.isSelected = self.isMuted
        }
    }
    
    public var isToShowPlaybackControls = true {
        didSet {
            if !isToShowPlaybackControls {
                self.viewVideoControlHeight.constant = 0.0
            }
        }
    }
    
    // MARK: 
    // MARK: VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isPDFAttachment{
            self.viewDocumentBG.isHidden = false
            self.viewImageBG.isHidden = true
            self.viewVideoPlayerBG.isHidden = true
            self.webView.load(attachmentData, mimeType: "application/pdf", characterEncodingName: "", baseURL: NSURL() as URL)
        }
        else if self.isDocumentAttachment{
            self.viewDocumentBG.isHidden = false
            self.viewImageBG.isHidden = true
            self.viewVideoPlayerBG.isHidden = true
            self.webView.loadFileURL(documentURL!, allowingReadAccessTo: documentURL!)
        }
        else if self.isVideoAttachment{
            self.viewDocumentBG.isHidden = true
            self.viewImageBG.isHidden = true
            self.viewVideoPlayerBG.isHidden = false
        
            self.loaderView.isHidden = true
            
            guard let player = self.player(with: URL(fileURLWithPath: strFilePath)) else {
                print("🚫 AVPlayer not created.")
                return
            }
            
            self.player = player
            let playerLayer = self.playerLayer(with: player)
            self.viewVideoPlayer.layer.insertSublayer(playerLayer, at: 0)
        }
        else{
            self.viewDocumentBG.isHidden = true
            self.viewImageBG.isHidden = false
            self.viewVideoPlayerBG.isHidden = true
            
            self.imgAttachment.image = UIImage(data: attachmentData)
            self.imgAttachment.contentMode = .scaleAspectFit
            
            self.scrollView.delegate = self
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 10.0
            
            self.lblAttachmentText.text = self.strAttachmentText
            self.viewAttachmentText.isHidden = self.strAttachmentText != "" ? false : true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    
        self.viewTopHeader.backgroundColor = MessageTheme.Color.primaryTheme
        self.viewTopHeader.setNavigationViewCorner()
        
        if self.isVideoAttachment{
            self.btnPlayPauseVideo.isSelected = false
        }
        
        self.setLanguageText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        self.viewTopHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        
        if self.isVideoAttachment{
            self.playerLayer?.frame = self.viewVideoPlayer.bounds
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        if self.strDocumentAttachmentTitle != ""{
            self.lblTitle.text = self.strDocumentAttachmentTitle
        }
        else{
            self.lblTitle.text = "KeylblDocument".localize
        }
    }
    
    // MARK: 
    // MARK: BUTTON ACTION METHODS
    @IBAction func btnBackClick(_ sender: Any) {
       self.view.endEditing(true)
       if self.isVideoAttachment{
           self.navigationController?.popWithAnimation()
       }
       else{
           self.dismiss(animated: false, completion: nil)
       }
   }
    
    // MARK: 
    // MARK: SHOW HIDE LOADER METHODS
    fileprivate func hideLoader() {
        DispatchQueue.main.async {
            if self.viewSpinner != nil {
                IPLoader.hideRemoveLoaderFromView(removableView: self.viewSpinner!, mainView: self.view)
            }
        }
    }
    
    fileprivate func showLoader() {
        DispatchQueue.main.async {
            self.viewSpinner = IPLoader.showLoaderWithBG(viewObj: self.view, boolShow: true, enableInteraction: false)!
        }
    }
    
    // MARK: 
    // MARK: VIEW CYCYLE END
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isVideoAttachment{
            self.player?.pause()
            NotificationCenter.default.post(name: Notification.Name("avPlayerDidDismiss"), object: nil, userInfo: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MessageAttachmentViewVC {
    func player(with url: URL) -> AVQueuePlayer? {
        var playerItems = [AVPlayerItem]()
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        playerItems.append(playerItem)
        
        guard !playerItems.isEmpty else {
            return nil
        }
        
        let player = AVQueuePlayer(items: playerItems)
        self.playerItems = playerItems
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
            if let duration = player.currentItem?.duration {
                
                let durationSeconds = CMTimeGetSeconds(duration)
                let seconds = CMTimeGetSeconds(progressTime)
                let progress = Float(seconds/durationSeconds)

                DispatchQueue.main.async {
                    self?.progressBar.progress = progress
                    if progress >= 1.0 {
                        self?.progressBar.progress = 0.0
                    }
                }
            }
        }
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndedPlaying), name: Notification.Name("AVPlayerItemDidPlayToEndTimeNotification"), object: nil)
        
        return player
    }
    
    func playerLayer(with player: AVQueuePlayer) -> AVPlayerLayer {
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.viewVideoPlayer.bounds
        playerLayer.videoGravity = .resizeAspect
        playerLayer.contentsGravity = .resizeAspect
        self.playerLayer = playerLayer
        return playerLayer
    }
    
    @objc func avPlayerDidDismiss(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {[weak self] in
            self?.isMuted = true
            self?.playVideo()
            NotificationCenter.default.removeObserver(self as Any, name: Notification.Name("avPlayerDidDismiss"), object: nil)
        }
    }
    
    @objc func playerEndedPlaying(_ notification: Notification) {
        DispatchQueue.main.async {[weak self] in
            if let playerItem = notification.object as? AVPlayerItem {
                self?.player?.remove(playerItem)
                playerItem.seek(to: .zero, completionHandler: nil)
                self?.player?.insert(playerItem, after: nil)
                if playerItem == self?.playerItems?.last {
                    self?.pauseVideo()
                }
            }
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    if newStatus == .playing || newStatus == .paused {
                        self?.loaderView.isHidden = true
                    } else {
                        self?.loaderView.isHidden = false
                    }
                }
            }
        }
    }
    
    public func playVideo() {
        self.player?.play()
        self.btnPlayPauseVideo.isSelected = true
    }
    
    public func pauseVideo() {
        self.player?.pause()
        self.btnPlayPauseVideo.isSelected = false
    }
    
    // MARK: 
    // MARK: BUTTON ACTION METHODS
    @IBAction private func btnVolumeClick(_ sender: UIButton) {
        self.isMuted = !sender.isSelected
    }
    
    @IBAction private func btnRewindClick(_ sender: UIButton) {
        if let currentTime = self.player?.currentTime() {
            var newTime = CMTimeGetSeconds(currentTime) - Constants.rewindForwardDuration
            if newTime <= 0 {
                newTime = 0
            }
            self.player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @IBAction private func btnPlayPauseVideoClick(_ sender: UIButton) {
        if sender.isSelected {
            self.pauseVideo()
        } else {
            self.playVideo()
        }
    }
    
    @IBAction private func btnForwardClick(_ sender: UIButton) {
        if let currentTime = self.player?.currentTime(), let duration = self.player?.currentItem?.duration {
            var newTime = CMTimeGetSeconds(currentTime) + Constants.rewindForwardDuration
            if newTime >= CMTimeGetSeconds(duration) {
                newTime = CMTimeGetSeconds(duration)
            }
            self.player?.seek(to: CMTime(value: CMTimeValue(newTime * 1000), timescale: 1000))
        }
    }
    
    @IBAction private func btnExpandClick(_ sender: UIButton) {
        self.pauseVideo()
        let controller = AVPlayerViewController()
        controller.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidDismiss), name: Notification.Name("avPlayerDidDismiss"), object: nil)
        self.parent?.present(controller, animated: true) {[weak self] in
            DispatchQueue.main.async {
                self?.isMuted = false
                self?.playVideo()
            }
        }
    }
}

extension MessageAttachmentViewVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        print("Finished loading")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}

extension MessageAttachmentViewVC: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgAttachment
    }
}

