//
//  EditGroupInfoPopupVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit

class EditGroupInfoPopupVC: UIViewController {
    // MARK: 
    // MARK: IBOUTLET VARIABLE
    @IBOutlet weak var viewMainBG: UIView!
    
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var lblEditProfile: BMLabel!
    
    @IBOutlet weak var imgGroupProfilePic: UIImageView!
    @IBOutlet weak var btnEditGroupProfilePic: UIButton!
    
    @IBOutlet weak var viewGroupName: UIView!
    @IBOutlet weak var txtGroupName: BMTextField!
    
    @IBOutlet weak var btnCancel: BMButton!
    @IBOutlet weak var btnOk: BMButton!
    
    @IBOutlet weak var viewCenterBGWidth: NSLayoutConstraint!
    
    // MARK: 
    // MARK: VARIABLE
    var employeeConversationId : Int64 = 0
    var strGroupName : String = ""
    var strGroupImageName : String = ""
    var strOldGroupImageName : String = ""
    
    var isImageEdited : Bool = false
    
    var setGroupInfoConfirmHandler: ((_ strGroupName:String, _ strGroupImage:String, _ isConfirm:Bool) -> Void)?
    
    var viewSpinner:UIView?
    
    // MARK: 
    // MARK: VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0.0
        self.viewEditProfile.alpha = 0.0
    
        self.viewCenterBGWidth.constant = MessageConstant.is_Device._iPhone ? self.view.frame.width * 0.85 : self.view.frame.width * 0.65
        
        self.txtGroupName.text = self.strGroupName
        
        if self.strGroupImageName != ""{
            self.strOldGroupImageName = self.strGroupImageName
            if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strGroupImageName){
                if let imgEmployeePic = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strGroupImageName){
                    self.imgGroupProfilePic.image = imgEmployeePic
                    self.imgGroupProfilePic.layer.cornerRadius = 15.0
                    self.imgGroupProfilePic.layer.masksToBounds = true
                    self.imgGroupProfilePic.contentMode = .scaleAspectFill
                }
                else{
                    self.imgGroupProfilePic.image =  #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
                    self.imgGroupProfilePic.layer.cornerRadius = 15.0
                }
            }
            else{
                BMAzure.loadDataFromAzure(clientSignature: self.strGroupImageName) { success, error, data in
                    if success && data != nil {
                        MessageManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strGroupImageName, fileData: data!)
                        DispatchQueue.main.async {
                            self.imgGroupProfilePic.image = UIImage(data: data!)
                            self.imgGroupProfilePic.layer.cornerRadius = 15.0
                            self.imgGroupProfilePic.layer.masksToBounds = true
                            self.imgGroupProfilePic.contentMode = .scaleAspectFill
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            self.imgGroupProfilePic.image =  #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
                            self.imgGroupProfilePic.layer.cornerRadius = 15.0
                        }
                    }
                }
            }
        }
        else{
            self.imgGroupProfilePic.image =  #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
            self.imgGroupProfilePic.layer.cornerRadius = 15.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        UIView.animate(withDuration: 0.25, delay: 0.05, options: .curveEaseIn, animations: { () -> Void in
            self.view.alpha = 1.0
            self.viewEditProfile.alpha = 1.0
        }) { (completed) -> Void in
            
        }
        
        self.setLanguageText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewEditProfile.layer.cornerRadius  = 10.0
        self.viewEditProfile.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.60, x: 0, y: 2, blur: 10, spread: 0)
        
        self.btnEditGroupProfilePic.layer.cornerRadius  = 15.0
        self.btnEditGroupProfilePic.layer.masksToBounds = true
        
        self.setViewShadow(objView: self.viewGroupName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        
    }
    
    func setViewShadow(objView : UIView){
        objView.backgroundColor = MessageTheme.Color.white
        objView.layer.cornerRadius = 10.0
        objView.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.30, x: 0, y: 2, blur: 10, spread: 0)
    }
    
    // MARK: 
    // MARK: BUTTON ACTION METHODS
    @IBAction func btnEditGroupProfilePicClick(_ sender: UIButton) {
        self.view.endEditing(true)
        PhotosUtility.shared.openCameraInControllerWithGallery(self, position: sender.frame) { (image) in
            guard let image = image else { return }
                
            let cropperViewController = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "CropperViewController") as! CropperViewController
            cropperViewController.image = image
            cropperViewController.isFromMessage = false
            cropperViewController.strMessage = ""
            if #available(iOS 13.0, *) {
                cropperViewController.modalPresentationStyle = .fullScreen
            }
            cropperViewController.setImageCropHandler = {(croppedImage, message, isCancel) in
                if !isCancel{
                    self.isImageEdited = true
                    DispatchQueue.main.async {
                        self.imgGroupProfilePic.image = croppedImage
                        self.imgGroupProfilePic.layer.cornerRadius = 15.0
                        self.imgGroupProfilePic.layer.masksToBounds = true
                        self.imgGroupProfilePic.contentMode = .scaleAspectFill
                    }
                }
                else{
                    self.imgGroupProfilePic.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur") 
                    self.imgGroupProfilePic.layer.cornerRadius = 15.0
                    self.imgGroupProfilePic.layer.masksToBounds = true
                    self.imgGroupProfilePic.contentMode = .scaleAspectFill
                }
            }
            MessageManager().delay(delay: 0.5, closure: {
                self.present(cropperViewController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        self.view.endEditing(true)
        let strGroupName = self.txtGroupName.text!.trimmingCharacters(in: .whitespaces)
        
        guard strGroupName.count > 0 else {
            MessageManager.shared.openCustomValidationAlertView(alertMessage: "lblGroupNameValidation".localize)
            return
        }
        
        if self.isImageEdited{
            self.uploadGroupImage(groupName: strGroupName)
        }
        else{
            self.updateConvesationAPICall(groupName: strGroupName)
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: 
    // MARK: EMPLOYEE SIGNATURE METHODS
    func uploadGroupImage(groupName : String) {
        // Conversation Image Upload Logic
        self.showLoader()
        
        let strGroupImageName = MessageManager.shared.generateImageName(strTag: "Conversation", strExtention: "jpg")
        BMAzure.uploadImageToAzure(strImageName: strGroupImageName, imgSignature: self.imgGroupProfilePic.image!, completion: { success, error in
            self.hideLoader()
            if success {
                if self.strOldGroupImageName != ""{
                    if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strOldGroupImageName){
                        MessageManager.shared.deleteFileFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strOldGroupImageName)
                    }
                }
                
                self.strGroupImageName = strGroupImageName
                DispatchQueue.main.async {
                    if !MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strGroupImageName){
                        if let data = self.imgGroupProfilePic.image?.pngData(){
                            MessageManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.strGroupImageName, fileData: data)
                        }
                    }
                    
                    self.updateConvesationAPICall(groupName: groupName)
                }
            }
        })
    }
        
    func updateConvesationAPICall(groupName : String){
        MessageManager.shared.call_UpdateConvesationAPI(employeeConversationId: self.employeeConversationId, groupName: groupName, groupImage: self.strGroupImageName, showLoader: true) { (isSuccess)  in
            if isSuccess{
                let arrConversationData = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' AND employeeConversationId = '\(self.employeeConversationId)'")
                if arrConversationData.count > 0{
                    _ = tblConversationList().setGroupInfoUpdate(conversationName: self.txtGroupName.text ?? "", conversationImageName: self.strGroupImageName, employeeConversationId: self.employeeConversationId)
                }
                
                self.setGroupInfoConfirmHandler?(groupName, self.strGroupImageName, true)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // MARK: 
    // MARK: API CALLER METHODS
    
    
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

// MARK: 
// MARK: TEXTFIELD DELEGATE METHODS
extension EditGroupInfoPopupVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
