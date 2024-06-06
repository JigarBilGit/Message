//
//  VideoCropperVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos

final class VideoCropperVC2: UIViewController {
    
    // MARK: - 
    // MARK: - IBOUTLET VARIABLE
    @IBOutlet weak var viewMainBG: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var videoTimelineViewBG: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var txtMessage: BMTextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    // MARK: - 
    // MARK: - VARIABLE
    var conversationId : String = ""
    var isFromMessage : Bool = false
    var setVideoCropHandler: ((_ strUploadedFileName : String, _ message : String, _ isCancel : Bool) -> Void)?
    
    var videoTimelineView: VideoTimelineView!
    var playerLayer: AVPlayerLayer!
    var responseURL: URL! = nil
    var asset: AVAsset!
    var playButtonStatus: Bool = false
    
    var startTimestr = ""
    var endTimestr = ""
    
    var startTime: CGFloat = 0.0
    var endTime: CGFloat = 0.0
    var stopTime: CGFloat  = 0.0
    var thumbTime: CMTime!
    var thumbtimeSeconds: Int!
    
    var viewSpinner:UIView?
    
    var strMessage : String = ""
    
    // MARK: - 
    // MARK: - VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.viewMessage.layer.cornerRadius = 10.0
        self.viewMessage.layer.borderWidth = 1.0
        self.viewMessage.layer.borderColor = MessageTheme.Color.white.cgColor

        self.txtMessage.text = strMessage
        
        self.videoTimelineView = VideoTimelineView()
        self.videoTimelineView.frame = CGRectMake(0, 0, self.videoTimelineViewBG.width, self.videoTimelineViewBG.height)
        self.videoTimelineView.new(asset: asset)
        self.videoTimelineView.playStatusReceiver = self
        self.videoTimelineView.currentTime = 0
        
        self.thumbTime = asset.duration
        self.thumbtimeSeconds = Int(CMTimeGetSeconds(self.thumbTime))
        
        self.startTimestr = "\(0.0)"
        self.endTimestr = "\(self.thumbtimeSeconds!)"
        
        let track = AVURLAsset(url: self.responseURL).tracks(withMediaType: AVMediaType.video).first
        if track != nil{
            let size = track!.naturalSize.applying(track!.preferredTransform)
            self.playerViewHeight.constant = size.height
        }
        
        self.videoTimelineView.repeatOn = true
        self.videoTimelineView.setTrimIsEnabled(true)
        self.videoTimelineView.setTrimmerIsHidden(false)
        self.videoTimelineViewBG.addSubview(self.videoTimelineView)
        
        self.videoTimelineView.moveTo(0, animate:false)
        self.videoTimelineView.setTrim(start: 0, end: Float64(CMTimeGetSeconds(self.thumbTime)), seek: nil, animate: false)
        
        let player = self.videoTimelineView.player!
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.frame = CGRectMake(0, 0, self.playerView.width, self.playerView.height)
        self.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        self.playerView.layer.addSublayer(self.playerLayer)

        self.playButton.addTarget(self,action:#selector(self.playButtonAction), for:.touchUpInside)
        self.setPlayButtonImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLanguageText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.videoTimelineView.frame = CGRectMake(0, 0, self.videoTimelineViewBG.width, self.videoTimelineViewBG.height)
        self.videoTimelineView.frame.size = self.videoTimelineViewBG.frame.size
        
        self.playerLayer.frame = CGRectMake(0, 0, self.playerView.width, self.playerView.height)
        self.playerLayer.frame.size = self.playerView.frame.size
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func dismissVC(){
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        
    }
    
    func setPlayButtonImage() {
        if self.playButtonStatus {
            self.playButton.setImage(#imageLiteral(resourceName: "btnPause"), for: .normal)
        } else {
            self.playButton.setImage(#imageLiteral(resourceName: "btnPlay"), for: .normal)
        }
    }
    
    // MARK: 
    // MARK: SHOW HIDE Loader METHODS
    fileprivate func hideLoader() {
        DispatchQueue.main.async {
            if self.viewSpinner != nil {
                IPLoader.hideRemoveLoaderFromView(removableView: self.viewSpinner!, mainView: self.view)
            }
        }
    }
    
    fileprivate func showLoader() {
        // Client Signature Upload Logic
        DispatchQueue.main.async {
            self.viewSpinner = IPLoader.showLoaderWithBG(viewObj: self.view, boolShow: true, enableInteraction: false)!
        }
    }
    
    // MARK: - 
    // MARK: - BUTTON ACTION METHODS
    @IBAction func btnCancelClick(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.setVideoCropHandler?("", "", true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnSendMessageClick(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {return}
        guard let mediaType = "mp4" as? String else {
            return
        }
        
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String{
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            let start = Float(startTimestr)!
            let end = Float(endTimestr)!
            
            let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "mp4")
            var outputURL = documentDirectory.appendingPathComponent("\(DirectoryFolder.ChatAttachment.rawValue)/\(self.conversationId)")
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                outputURL = outputURL.appendingPathComponent(strUploadedFileName)
            }catch let error {
                print(error)
            }
            
            self.showLoader()
            
            _ = try? manager.removeItem(at: outputURL)
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            
            let startTime = CMTime(seconds: Double(start), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("exported at \(outputURL)")
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.setVideoCropHandler?(strUploadedFileName, self.txtMessage.text ?? "", false)
                        self.dismiss(animated: false, completion: nil)
                    }
                case .failed:
                    DispatchQueue.main.async {
                        self.hideLoader()
                    }
                    print("failed \(exportSession.error!)")
                case .cancelled:
                    DispatchQueue.main.async {
                        self.hideLoader()
                    }
                    print("cancelled \(String(describing: exportSession.error))")
                    
                default: break
                }
            }
        }
    }
    
    @objc func playButtonAction() {
        self.playButtonStatus = !self.playButtonStatus
        if self.playButtonStatus {
            self.videoTimelineView.play()
        } else {
            self.videoTimelineView.stop()
        }
        self.setPlayButtonImage()
    }
    
    // MARK: - 
    // MARK: - VIEW CYCYLE END
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 
// MARK: - TIME LINE PLAY STATUS RECEIVER METHODS
extension VideoCropperVC2: TimelinePlayStatusReceiver{
    func videoTimelineStopped() {
        self.playButtonStatus = false
        self.setPlayButtonImage()
    }
    
    func videoTimelineMoved() {
        let time = self.videoTimelineView.currentTime
//        print("time: \(time)")
    }
    
    func videoTimelineTrimChanged() {
        let trim = self.videoTimelineView.currentTrim()
        self.startTimestr = "\(trim.start)"
        self.endTimestr = "\(trim.end)"
//        print("start time: \(trim.start)")
//        print("end time: \(trim.end)")
    }
}
