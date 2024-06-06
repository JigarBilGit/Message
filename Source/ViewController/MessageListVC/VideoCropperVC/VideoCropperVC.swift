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

final class VideoCropperVC: UIViewController {
    
    // MARK: - 
    // MARK: - IBOUTLET VARIABLE
    @IBOutlet weak var viewMainBG: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var videoPlayerView: UIView!
    
    @IBOutlet weak var frameContainerView: UIView!
    @IBOutlet weak var imageFrameView: UIView!
    
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var txtMessage: BMTextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    // MARK: - 
    // MARK: - VARIABLE
    var isFromMessage : Bool = false
    var setVideoCropHandler: ((_ message : String, _ isCancel : Bool) -> Void)?
    
    var isPlaying = true
    var isSliderEnd = true
    var playbackTimeCheckerTimer: Timer! = nil
    let playerObserver: Any? = nil
    
    let exportSession: AVAssetExportSession! = nil
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var asset: AVAsset!
    
    var url:NSURL! = nil
    var startTime: CGFloat = 0.0
    var stopTime: CGFloat  = 0.0
    var thumbTime: CMTime!
    var thumbtimeSeconds: Int!
    
    var videoPlaybackPosition: CGFloat = 0.0
    var cache:NSCache<AnyObject, AnyObject>!
    var rangSlider: RangeSlider! = nil
    
    var startTimestr = ""
    var endTimestr = ""
    
    // MARK: - 
    // MARK: - VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.viewMessage.layer.cornerRadius = 10.0
        self.viewMessage.layer.borderWidth = 1.0
        self.viewMessage.layer.borderColor = MessageTheme.Color.white.cgColor
        
        self.frameContainerView.isHidden = true
        
        self.imageFrameView.layer.cornerRadius = 5.0
        self.imageFrameView.layer.borderWidth  = 1.0
        self.imageFrameView.layer.borderColor  = UIColor.white.cgColor
        self.imageFrameView.layer.masksToBounds = true
        
        self.player = AVPlayer()
        
        //Allocating NsCahe for temp storage
        self.cache = NSCache()
        
        if let assets = asset{
            self.thumbTime = asset.duration
            self.thumbtimeSeconds = Int(CMTimeGetSeconds(self.thumbTime))
            
            if self.playerLayer != nil{
                self.playerLayer.removeFromSuperlayer()
            }
            
            self.createImageFrames()
            
            self.frameContainerView.isHidden = false
            
            self.isSliderEnd = true
            self.startTimestr = "\(0.0)"
            self.endTimestr = "\(thumbtimeSeconds!)"
            self.createrangSlider()
            
            let item:AVPlayerItem  = AVPlayerItem(asset: self.asset)
            self.player            = AVPlayer(playerItem: item)
            self.playerLayer       = AVPlayerLayer(player: self.player)
            self.playerLayer.frame = self.videoPlayerView.bounds
            
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            player.actionAtItemEnd   = AVPlayer.ActionAtItemEnd.none
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnvideoPlayerView))
            self.videoPlayerView.addGestureRecognizer(tap)
            self.tapOnvideoPlayerView(tap: tap)
            
            self.videoPlayerView.layer.addSublayer(self.playerLayer)
            self.player.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLanguageText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    // MARK: - 
    // MARK: - BUTTON ACTION METHODS
    @IBAction func btnCancelClick(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.setVideoCropHandler?("", true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnSendMessageClick(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        self.setVideoCropHandler?(self.txtMessage.text ?? "", false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cropVideo(_ sender: Any){
        let start = Float(startTimestr)
        let end   = Float(endTimestr)
        self.cropVideo(sourceURL1: url, startTime: start!, endTime: end!)
    }
    
    @objc func tapOnvideoPlayerView(tap: UITapGestureRecognizer){
        if self.isPlaying{
            self.player.play()
        }
        else{
            self.player.pause()
        }
        self.isPlaying = !self.isPlaying
    }
    
    //MARK: CreatingFrameImages
    func createImageFrames(){
        //creating assets
        let assetImgGenerate : AVAssetImageGenerator    = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter    = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore   = CMTime.zero;
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let thumbTime: CMTime = asset.duration
        let thumbtimeSeconds  = Int(CMTimeGetSeconds(thumbTime))
        let maxLength         = "\(thumbtimeSeconds)" as NSString
        
        let thumbAvg  = thumbtimeSeconds/6
        var startTime = 1
        var startXPosition:CGFloat = 0.0
        
        //loop for 6 number of frames
        for _ in 0...5{
            let imageButton = UIButton()
            let xPositionForEach = CGFloat(self.imageFrameView.frame.width)/6
            imageButton.frame = CGRect(x: CGFloat(startXPosition), y: CGFloat(0), width: xPositionForEach, height: CGFloat(self.imageFrameView.frame.height))
            do {
                let time:CMTime = CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: Int32(maxLength.length))
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: img)
                imageButton.setImage(image, for: .normal)
            }
            catch
                _ as NSError
            {
                print("Image generation failed with error (error)")
            }
            
            startXPosition = startXPosition + xPositionForEach
            startTime = startTime + thumbAvg
            imageButton.isUserInteractionEnabled = false
            imageFrameView.addSubview(imageButton)
        }
    }
    
    //Create range slider
    func createrangSlider(){
        //Remove slider if already present
        let subViews = self.frameContainerView.subviews
        for subview in subViews{
            if subview.tag == 1000 {
                subview.removeFromSuperview()
            }
        }
        
        self.rangSlider = RangeSlider(frame: self.frameContainerView.bounds)
        self.frameContainerView.addSubview(self.rangSlider)
        self.rangSlider.tag = 1000
        
        //Range slider action
        self.rangSlider.addTarget(self, action: #selector(rangSliderValueChanged(_:)), for: .valueChanged)
        
        let time = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangSlider.trackHighlightTintColor = UIColor.clear
            self.rangSlider.curvaceousness = 1.0
        }
        
    }
    
    //MARK: rangSlider Delegate
    @objc func rangSliderValueChanged(_ rangSlider: RangeSlider) {
//        self.player.pause()
        if self.isSliderEnd == true{
            rangSlider.minimumValue = 0.0
            rangSlider.maximumValue = Double(self.thumbtimeSeconds)
            
            rangSlider.upperValue = Double(self.thumbtimeSeconds)
            self.isSliderEnd = !self.isSliderEnd
        }
        
        self.startTimestr = "\(rangSlider.lowerValue)"
        self.endTimestr   = "\(rangSlider.upperValue)"
        
        print(rangSlider.lowerLayerSelected)
        if rangSlider.lowerLayerSelected{
            self.seekVideo(toPos: CGFloat(rangSlider.lowerValue))
        }
        else{
            self.seekVideo(toPos: CGFloat(rangSlider.upperValue))
        }
        print(startTime)
    }
    
    //Seek video when slide
    func seekVideo(toPos pos: CGFloat) {
        self.videoPlaybackPosition = pos
        let time: CMTime = CMTimeMakeWithSeconds(Float64(self.videoPlaybackPosition), preferredTimescale: self.player.currentTime().timescale)
        self.player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        if pos == CGFloat(thumbtimeSeconds){
            self.player.pause()
        }
    }
    
    //Trim Video Function
    func cropVideo(sourceURL1: NSURL, startTime:Float, endTime:Float){
        let manager = FileManager.default
        
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {return}
        guard let mediaType = "mp4" as? String else {
            return
        }
        guard (sourceURL1 as? NSURL) != nil else {
            return
        }
        
        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String{
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("video length: \(length) seconds")
            
            let start = startTime
            let end = endTime
            print(documentDirectory)
            var outputURL = documentDirectory.appendingPathComponent("output")
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                //let name = hostent.newName()
                outputURL = outputURL.appendingPathComponent("1.mp4")
            }catch let error {
                print(error)
            }
            
            //Remove existing file
            _ = try? manager.removeItem(at: outputURL)
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            
            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("exported at \(outputURL)")
                    self.saveToCameraRoll(URL: outputURL as NSURL?)
                case .failed:
                    print("failed \(exportSession.error!)")
                case .cancelled:
                    print("cancelled \(String(describing: exportSession.error))")
                    
                default: break
                }
            }
        }
    }
    
    //Save Video to Photos Library
    func saveToCameraRoll(URL: NSURL!) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL as URL)
        }) { saved, error in
            if saved {
                let alertController = UIAlertController(title: "Cropped video was saved successfully", message: nil, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
