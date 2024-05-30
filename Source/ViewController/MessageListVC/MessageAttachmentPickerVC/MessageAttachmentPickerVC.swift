//
//  MessageAttachmentPickerVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit

class MessageAttachmentPickerVC: UIViewController {
    // MARK: 
    // MARK: IBOUTLET VARIABLE
    @IBOutlet weak var viewMainBG: UIView!
    
    @IBOutlet weak var viewCenterBG: UIView!
    @IBOutlet weak var viewTopHeader: UIView!
    @IBOutlet weak var lblTitle: BMLabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var viewPhotos: UIView!
    @IBOutlet weak var viewPhotosBG: UIView!
    @IBOutlet weak var imgPhotos: UIImageView!
    @IBOutlet weak var lblPhotos: BMLabel!
    @IBOutlet weak var btnPhotos: UIButton!
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var viewCameraBG: UIView!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var lblCamera: BMLabel!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var viewDocument: UIView!
    @IBOutlet weak var viewDocumentBG: UIView!
    @IBOutlet weak var imgDocument: UIImageView!
    @IBOutlet weak var lblDocument: BMLabel!
    @IBOutlet weak var btnDocument: UIButton!
    
    @IBOutlet weak var viewCenterBGWidth: NSLayoutConstraint!
    
    // MARK: 
    // MARK: VARIABLE
    var strTitle : String = ""
    var setAttachmentHandler: ((_ index:Int, _ isCancel:Bool) -> Void)?
    
    // MARK: 
    // MARK: VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.alpha = 0.0
        self.viewCenterBG.alpha = 0.0
        
        self.btnClose.isHidden = true
        self.viewCenterBGWidth.constant = MessageConstant.is_Device._iPhone ? self.view.frame.width * 0.85 : self.view.frame.width * 0.6
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.navigationController?.navigationBar.isHidden = true
    
        UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 1.0
            self.viewCenterBG.alpha = 1.0
        }) { (completed) -> Void in
            
            self.viewPhotosBG.layer.cornerRadius = self.viewPhotosBG.height / 2.0
            self.viewCameraBG.layer.cornerRadius = self.viewCameraBG.height / 2.0
            self.viewDocumentBG.layer.cornerRadius = self.viewDocumentBG.height / 2.0
        }

        self.setLanguageText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewTopHeader.backgroundColor = MessageTheme.Color.primaryTheme
        self.viewTopHeader.setNavigationViewCorner()
        
        self.viewTopHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        
        self.viewCenterBG.layer.cornerRadius  = 10.0
        self.viewCenterBG.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        self.lblTitle.text = self.strTitle
    }
    
    // MARK: 
    // MARK: BUTTON ACTION METHODS
    @IBAction func btnCloseClick(_ sender: Any) {
        self.view.endEditing(true)
        self.setAttachmentHandler?(-1, true)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnPhotosClick(_ sender: Any) {
        self.view.endEditing(true)
        self.setAttachmentHandler?(1, false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnCameraClick(_ sender: Any) {
        self.view.endEditing(true)
        self.setAttachmentHandler?(2, false)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnDocumentClick(_ sender: Any) {
        self.view.endEditing(true)
        self.setAttachmentHandler?(3, false)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: 
    // MARK: VIEW CYCYLE END
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
