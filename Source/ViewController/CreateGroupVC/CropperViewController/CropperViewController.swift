//
//  CropperViewController.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import AKImageCropperView

final class CropperViewController: UIViewController {
    
    // MARK: - 
    // MARK: - IBOUTLET VARIABLE
    @IBOutlet weak var cropViewStoryboard: AKImageCropperView!
    @IBOutlet weak var overlayActionView: UIView!
    @IBOutlet weak var btnRotate: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnOverlay: UIButton!
    
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var txtMessage: BHTextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    private var cropView: AKImageCropperView {
        return cropViewStoryboard
    }
    
    // MARK: - 
    // MARK: - VARIABLE
    var isFromMessage : Bool = false
    var image: UIImage!
    var angle: Double = 0.0
    var setImageCropHandler: ((_ croppedImage : UIImage, _ message : String, _ isCancel : Bool) -> Void)?
    
    var strMessage : String = ""
    
    // MARK: - 
    // MARK: - VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.cropView.delegate = self
        self.cropView.image = image
        
        self.viewMessage.layer.cornerRadius = 10.0
        self.viewMessage.layer.borderWidth = 1.0
        self.viewMessage.layer.borderColor = MessageTheme.Color.white.cgColor
        
        self.txtMessage.text = strMessage
        
        self.viewMessageBG.isHidden = true
        self.btnCancel.isHidden = true
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
        self.btnReset.setTitle("btnReset".localize, for: .normal)
        self.btnBack.setTitle("btnBack".localize, for: .normal)
        self.btnDone.setTitle("btnDone".localize, for: .normal)
    }
    
    // MARK: - 
    // MARK: - BUTTON ACTION METHODS
    @IBAction func btnBackClick(_ sender: AnyObject) {
        self.setImageCropHandler?(#imageLiteral(resourceName: "logoWhite"), "", true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnDoneClick(_ sender: AnyObject) {
        if !self.isFromMessage{
            guard let image = cropView.croppedImage else {
                return
            }
            self.setImageCropHandler?(image, "", false)
            self.dismiss(animated: false, completion: nil)
        }
        else{
            guard let image = cropView.croppedImage else {
                return
            }
            self.cropViewStoryboard.image = image
            self.cropView.hideOverlayView(animationDuration: 0.3)
            
            self.overlayActionView.isHidden = true
            self.navigationView.isHidden = true
            self.viewMessageBG.isHidden = false
            self.btnCancel.isHidden = false
        }
    }
    
    @IBAction func btnOverlayClick(_ sender: AnyObject) {
//        if cropView.isoverlayViewActive {
//            cropView.hideOverlayView(animationDuration: 0.3)
//            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
//                self.overlayActionView.alpha = 0
//            }, completion: nil)
//        }
//        else {
            cropView.showOverlayView(animationDuration: 0.3)
            UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                self.overlayActionView.alpha = 1
                
            }, completion: nil)
//        }
    }
    
    @IBAction func btnRotateClick(_ sender: AnyObject) {
        angle += .pi/2
        cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            if self.angle == 2 * .pi {
                self.angle = 0.0
            }
        })
    }
    
    @IBAction func btnResetClick(_ sender: AnyObject) {
        cropView.reset(animationDuration: 0.3)
        angle = 0.0
    }
    
    @IBAction func btnSendMessageClick(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        guard let image = self.cropViewStoryboard.image else {
            return
        }
        self.setImageCropHandler?(image, self.txtMessage.text ?? "", false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCancelClick(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.setImageCropHandler?(#imageLiteral(resourceName: "logoWhite"), "", true)
        self.dismiss(animated: false, completion: nil)
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
// MARK: - AKImageCropperViewDelegate

extension CropperViewController: AKImageCropperViewDelegate {
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
//        Log.console("New crop rectangle: \(rect)")
    }
}
