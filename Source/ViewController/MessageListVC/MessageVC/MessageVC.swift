//
//  MessageVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import AVFoundation
import MobileCoreServices
import BSImagePicker
import IQKeyboardManagerSwift
import Photos
import SwiftSignalRClient
import AVFoundation
import AVKit
import PDFKit

class MessageVC: UIViewController {

    // MARK: - 
    // MARK: IBOUTLET VARIABLE
    @IBOutlet weak var viewTopHeader: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgConversationPic: UIImageView!
    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var viewMessageBG: UIView!
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var lblRecordSound: BMLabel!
    @IBOutlet weak var imgNoRecords: UIImageView!
    
    @IBOutlet weak var viewAudioPlayBG: UIView!
    @IBOutlet weak var btnPlayAudio: BMCustomButton!
    @IBOutlet weak var btnPauseAudio: BMCustomButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var btnSendAudio: UIButton!
    @IBOutlet weak var btnCancelAudio: UIButton!
    @IBOutlet weak var viewAudioPlayBGHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewMessageTypeBG: UIView!
    @IBOutlet weak var txtMessage: BHTextField!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnAudioRecord: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewMessageTypeBGHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewMessageBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewOptionPopupBG: UIView!
    @IBOutlet weak var btnDismissOptionPopup: UIButton!
    @IBOutlet weak var viewTopOptionPopup: UIView!
    @IBOutlet weak var lblPopupTitle: BMLabel!
    @IBOutlet weak var btnDismissOptionPopup2: UIButton!
    @IBOutlet weak var viewOptionPopup: UIView!
    @IBOutlet weak var tblOptionPopup: UITableView!
    @IBOutlet weak var tblOptionPopupHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBottomOptionPopup: UIView!
    @IBOutlet weak var viewOptionPopupTop: NSLayoutConstraint!
    
    // MARK: - 
    // MARK: VARIABLE
    var arrMessages : [tblMessages] = []
    var arrFinalMessages : [ShareMessage] = []
    var isMoreRecord : Bool = false
    
    var employeeId : Int = 0
    var lastMessageId : Int = 0
        
    var timerAudio : Timer?
    var timerAudioPlayer : Timer?
    var player : AVAudioPlayer?
    var selectedIndexPath : IndexPath?
    
    var recorder : AVAudioRecorder?
    var isRecording : Bool = false
    
    var intTimimg = 0
    var intSeconds = 0
    var intMinutes = 0
    var intHours = 0
    
    var viewSpinner:UIView?
    
    var strImageName : String = ""
    
    private let refreshControl = UIRefreshControl()
    
    let text = "Fetching chat data ..."
    
    var objConversation = tblConversationList()
    
    var uniqueId = UUID()
    
    var strRecordedAudioFileName : String = ""
    var recordedAudioFilePath : URL!
    var recordedAudioUrl : URL!
    
    var arrOptionSection : [ShareOptions] = []
    
    var selectedMessageData = tblMessages()
    
    var selectedSyncSection : Int = -1
    var selectedSyncRow : Int = -1
    
    // MARK: - 
    // MARK: VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.disabledToolbarClasses = [MessageVC.self]
        
        self.tblOptionPopup.register(UINib(nibName: "OptionListCell", bundle: nil), forCellReuseIdentifier: "OptionListCell")
        self.tblOptionPopup.estimatedRowHeight = 60.0
        self.tblOptionPopup.rowHeight = UITableView.automaticDimension
        self.tblOptionPopup.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.tblOptionPopup.layer.cornerRadius = 10.0
        self.tblOptionPopup.layer.masksToBounds = true
        
        self.tblMessage.estimatedRowHeight = 100.0
        self.tblMessage.rowHeight = UITableView.automaticDimension
        
        self.tblMessage.register(UINib(nibName: "MessageHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "MessageHeaderCell")
        self.tblMessage.register(UINib(nibName: "SenderTextCell", bundle: nil), forCellReuseIdentifier: "SenderTextCell")
        self.tblMessage.register(UINib(nibName: "ReceiverTextCell", bundle: nil), forCellReuseIdentifier: "ReceiverTextCell")
        self.tblMessage.register(UINib(nibName: "SenderAudioCell", bundle: nil), forCellReuseIdentifier: "SenderAudioCell")
        self.tblMessage.register(UINib(nibName: "ReceiverAudioCell", bundle: nil), forCellReuseIdentifier: "ReceiverAudioCell")
        self.tblMessage.register(UINib(nibName: "SenderImageCell", bundle: nil), forCellReuseIdentifier: "SenderImageCell")
        self.tblMessage.register(UINib(nibName: "ReceiverImageCell", bundle: nil), forCellReuseIdentifier: "ReceiverImageCell")
        self.tblMessage.register(UINib(nibName: "SenderVideoCell", bundle: nil), forCellReuseIdentifier: "SenderVideoCell")
        self.tblMessage.register(UINib(nibName: "ReceiverVideoCell", bundle: nil), forCellReuseIdentifier: "ReceiverVideoCell")
        self.tblMessage.register(UINib(nibName: "SenderDocCell", bundle: nil), forCellReuseIdentifier: "SenderDocCell")
        self.tblMessage.register(UINib(nibName: "ReceiverDocCell", bundle: nil), forCellReuseIdentifier: "ReceiverDocCell")
        self.tblMessage.register(UINib(nibName: "SystemGeneratedCell", bundle: nil), forCellReuseIdentifier: "SystemGeneratedCell")
         
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.tblMessage.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.tblMessage.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
        
        if #available(iOS 10.0, *) {
            self.tblMessage.refreshControl = self.refreshControl
        } else {
            self.tblMessage.addSubview(self.refreshControl)
        }
        
        self.refreshControl.tintColor = MessageTheme.Color.primaryTheme
        
        let attriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: text)
        attriString.addAttribute(NSAttributedString.Key.foregroundColor, value: MessageTheme.Color.primaryTheme, range: range1)
        self.refreshControl.attributedTitle = attriString
        
        self.refreshControl.addTarget(self, action: #selector(refreshPostData(_:)), for: .valueChanged)
        self.refreshControl.endRefreshing()
        
        self.setMessageData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        self.viewTopHeader.backgroundColor = MessageTheme.Color.primaryTheme
        self.viewTopHeader.setNavigationViewCorner()
        
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setLanguageText()
        
        self.viewMessageBottom.constant = UIDevice.hasNotch ? 0.0 : 10.0
        
        MessageManager.shared.createDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)")
        
        self.viewOptionPopupBG.isHidden = true
        self.viewOptionPopup.isHidden = true
        
        //===== Submit Read Message ======
        //================================
        self.readMessageOperation()
        //================================
        _ = tblConversationList().setUnreadCount(unreadCount: 0, conversationId: self.objConversation.conversationId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.viewTopHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
        
        self.viewMessageTypeBG.layer.cornerRadius = 10.0
        self.viewMessageTypeBG.layer.masksToBounds = true
        
        self.viewAudioPlayBG.layer.cornerRadius = 10.0
        self.viewAudioPlayBG.layer.masksToBounds = true
        
        self.viewTopOptionPopup.roundCorners([.topLeft, .topRight], radius: 30.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewTopOptionPopup.roundCorners([.topLeft, .topRight], radius: 30.0)
    }
    
    // MARK: - 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        self.lblTitle.text = self.objConversation.conversationName
    }

    @objc private func refreshPostData(_ sender: Any) {
        if self.isMoreRecord{
            let arrOldMessages = tblMessages.rowsFor(sql: "SELECT * FROM tblMessages WHERE employeeConversationId = '\(self.objConversation.employeeConversationId)' ORDER By messageDateTime")
            
            MessageManager.shared.call_MessageListAPI(conversationId: self.objConversation.employeeConversationId, pageSize: MessagePageSize.Other.rawValue, lastMessageId: arrOldMessages.count > 0 ? arrOldMessages[0].conversationMessageId : 0 , nextOrPrevious: false) { (success, isMoreRecord) in
                self.isMoreRecord = isMoreRecord
                self.loadMessageDetails(isFirstCall: false)
            }
        }
        else{
            self.refreshControl.endRefreshing()
        }
    }
    
//    func reloadMessage(){
//        self.lastMessageId = 0
//        self.arrFinalMessages.removeAll()
//        self.arrMessages.removeAll()
//        self.tblMessage.reloadData()
//        self.loadMessageDetails(isFirstCall: true)
//    }
    
    func setMessageData(){
        self.arrFinalMessages.removeAll()
        self.arrMessages.removeAll()
        self.tblMessage.reloadData()
        self.imgNoRecords.isHidden = true
        
        self.lblRecordSound.isHidden = true
        
        self.viewAudioPlayBG.isHidden = true
        self.btnPlayAudio.isHidden = true
        self.btnPauseAudio.isHidden = true
        self.audioSlider.isHidden = true
        self.btnSendAudio.isHidden = true
        self.btnCancelAudio.isHidden = true
        self.viewAudioPlayBGHeight.constant = 0.0
        
        self.viewMessageTypeBG.isHidden = false
        self.btnAttachment.isHidden = false
        self.btnAudioRecord.isHidden = false
        self.btnConfirm.isHidden = true
        self.btnSend.isHidden = true
        self.btnCancel.isHidden = true
        self.viewMessageTypeBGHeight.constant = 56.0
        
        self.txtMessage.isHidden = false
        self.lblRecordSound.text = "00:00"
        self.lblRecordSound.isHidden = true
        
        if self.objConversation.conversationImage != ""{
            if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.objConversation.conversationImage){
                if let imgEmployeePic = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.objConversation.conversationImage){
                    self.imgConversationPic.image = imgEmployeePic
                    self.imgConversationPic.layer.cornerRadius = 5.0
                    self.imgConversationPic.layer.masksToBounds = true
                    self.imgConversationPic.contentMode = .scaleAspectFill
                }
            }
            else{
                BHAzure.loadDataFromAzure(clientSignature: self.objConversation.conversationImage) { success, error, data in
                    if success && data != nil {
                        MessageManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.objConversation.conversationImage, fileData: data!)
                        DispatchQueue.main.async {
                            self.imgConversationPic.image = UIImage(data: data!)
                            self.imgConversationPic.layer.cornerRadius = 5.0
                            self.imgConversationPic.layer.masksToBounds = true
                            self.imgConversationPic.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
        }
        else{
            self.imgConversationPic.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
            self.imgConversationPic.backgroundColor = MessageTheme.Color.white
            self.imgConversationPic.layer.cornerRadius = 5.0
            self.imgConversationPic.layer.masksToBounds = true
            self.imgConversationPic.contentMode = .scaleAspectFill
        }
        
        if MessageManager.shared.isNetConnected{
            let arrOldMessages = tblMessages.rowsFor(sql: "SELECT * FROM tblMessages WHERE employeeConversationId = '\(self.objConversation.employeeConversationId)' ORDER By messageDateTime")
            
            let arrMediaRemainingMessage = arrOldMessages.filter({$0.uploadingStatus != UploadingStatus.Uploaded.rawValue})
            if arrMediaRemainingMessage.count > 0{
                self.uploadUnsyncMediaFile(arrMessageData: arrMediaRemainingMessage)
            }
            
            MessageManager.shared.call_MessageListAPI(conversationId: self.objConversation.employeeConversationId, pageSize: MessagePageSize.Default.rawValue, lastMessageId: 0, nextOrPrevious: false) { (success, isMoreRecord) in
                self.isMoreRecord = true
                self.loadMessageDetails(isFirstCall: true)
            }
        }
        else{
            self.isMoreRecord = true
            self.loadMessageDetails(isFirstCall: true)
        }
        
        APP_DELEGATE.hubConnectionConversation.on(method: "\(self.objConversation.conversationId)", callback: { (payload: ArgumentExtractor?) in
            do{
                print("Received Message Response.")
                let response = try payload?.getArgument(type: Arguments.self)
                if let dictMessage = response?.message as? Message{
                    _ = tblMessages().deleteMessage(mobilePrimaryKey: dictMessage.mobilePrimaryKey ?? "")
                    
                    let objMessage = tblMessages()
                    objMessage.conversationMessageId = dictMessage.conversationMessageId ?? 0
                    objMessage.conversationId = dictMessage.conversationId ?? ""
                    objMessage.employeeConversationId = dictMessage.employeeConversationId ?? 0
                    objMessage.messageTypeId = dictMessage.messageTypeId ?? 1
                    objMessage.messageContent = dictMessage.messageContent ?? ""
                    objMessage.messageAttachment = dictMessage.messageAttachment ?? ""
                    objMessage.messageDateTime = dictMessage.messageDateTime ?? 0
                    objMessage.replyMessageId = dictMessage.replyMessageId ?? 0
                    objMessage.forwardMessageId = dictMessage.forwardMessageId ?? 0
                    objMessage.senderEmployeeId = dictMessage.senderEmployeeId ?? 0
                    objMessage.mobilePrimaryKey = dictMessage.mobilePrimaryKey ?? ""
                    objMessage.addedBy = dictMessage.addedBy ?? 0
                    objMessage.addedOn = dictMessage.addedOn ?? 0
                    objMessage.isDeleted = dictMessage.isDeleted ?? false
                    objMessage.isSyncData = true
                    objMessage.isUpdatedData = false
                    objMessage.messageDate = MessageManager.shared.getCurrentTimeStampMMDDYYYYFrom2(strDate: MessageManager.shared.dateFormatterCurrentMMDDYYYY().string(from: MessageManager.shared.getCurrentZoneDate(timestamp:  objMessage.messageDateTime)))
                    
                    let arrEmployeeData = tblEmployee.rowsFor(sql: "SELECT * FROM tblEmployees where employeeId = '\(dictMessage.senderEmployeeId ?? 0)'")
                    if arrEmployeeData.count > 0{
                        objMessage.firstName = arrEmployeeData[0].firstName
                        objMessage.middleName = arrEmployeeData[0].middleName
                        objMessage.lastName = arrEmployeeData[0].lastName
                        objMessage.photo = ""//arrEmployeeData[0].photo
                    }
                    
                    _ = objMessage.save()
                    
                    self.loadMessageDetails(isFirstCall: false)
                }
                
                if let arrReceipts = response?.receipts as? [Receipts]{
                    for eleReceipt in arrReceipts{
                        let objReceipts = tblMessageReceipts()
                        objReceipts.conversationMessageId = eleReceipt.conversationMessageId ?? 0
                        objReceipts.employeeId = eleReceipt.employeeId ?? 0
                        objReceipts.isDelivered = eleReceipt.isDelivered ?? false
                        objReceipts.isReceived = eleReceipt.isReceived ?? false
                        objReceipts.isRead = eleReceipt.isRead ?? false
                        objReceipts.addedOn = eleReceipt.addedOn ?? 0
                        
                        _ = objReceipts.save()
                    }
                }
            }
            catch{
                print(error)
            }
        })
    }
    
    // MARK: 
    // MARK: SHOW HIDE Loader METHODS
    fileprivate func hideLoader(objView : UIView) {
        DispatchQueue.main.async {
            if self.viewSpinner != nil {
                IPLoader.hideRemoveLoaderFromView(removableView: self.viewSpinner!, mainView: objView)
            }
        }
    }
    
    fileprivate func showLoader(objView : UIView) {
        // Client Signature Upload Logic
        DispatchQueue.main.async {
            self.viewSpinner = IPLoader.showLoaderWithBG(viewObj: objView, boolShow: true, enableInteraction: false)!
        }
    }
    
    // MARK: - 
    // MARK: - BUTTON ACTION METHODS
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        
        APP_DELEGATE.hubConnectionConversation.stop()
        
        APP_DELEGATE.setupCommunicationListener()
        
        _ = tblMessages().updateDownloadingFlagForFullConversation(isDownloading: 0, employeeConversationId: self.objConversation.employeeConversationId)
        
        self.navigationController?.popWithAnimation()
    }
    
    @IBAction func btnViewProfileClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let objMessageProfileVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageProfileVC") as! MessageProfileVC
        objMessageProfileVC.profileType = self.objConversation.isGroup ? ProfileType.Group.rawValue : ProfileType.Other.rawValue
        objMessageProfileVC.objConversation = self.objConversation
        objMessageProfileVC.setRedirectionHandler = {(isCancel, employeeConversationId, conversationData) in
            if !isCancel{
                APP_DELEGATE.hubConnectionConversation.stop()
                APP_DELEGATE.setupCommunicationListener()
                
                self.objConversation = conversationData
                self.setMessageData()
            }
        }
        self.navigationController?.pushWithAnimation(viewController: objMessageProfileVC)
    }
    
    @IBAction func btnMenuClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let arrMenuName : [String] = self.objConversation.isGroup ? ["\("lblGroupInfo".localize)", "\("lblLeaveGroup".localize)"] : ["\("lblProfile".localize)"] //"\("lblLeaveChat".localize)"
        
        let arrMenuImage : [UIImage] = [#imageLiteral(resourceName: "imgInfo"), #imageLiteral(resourceName: "imgLeave")]
        
        let config = BIConfiguration()
        config.backgoundTintColor = MessageTheme.Color.white
        config.borderColor = MessageTheme.Color.lightGray
        config.globalShadow = true
        config.shadowAlpha = 0.3
        config.menuWidth = MessageConstant.is_Device._iPhone ? 150 : 200
        config.menuSeparatorColor = MessageTheme.Color.lightGray
        config.menuRowHeight = 50
        config.cornerRadius = 6
        config.textFont = UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_20) ?? UIFont.systemFont(ofSize: 14)
        config.textColor = MessageTheme.Color.black
        
        BIPopOverMenu.showForSender(sender: sender,
                                    with: arrMenuName,
                                    menuImageArray: arrMenuImage,
                                    popOverPosition: .automatic,
                                    config: config,
                                    done: { (selectedIndex) in
            if selectedIndex == 0{
                let objMessageProfileVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageProfileVC") as! MessageProfileVC
                objMessageProfileVC.profileType = self.objConversation.isGroup ? ProfileType.Group.rawValue : ProfileType.Other.rawValue
                objMessageProfileVC.objConversation = self.objConversation
                objMessageProfileVC.setRedirectionHandler = {(isCancel, employeeConversationId, conversationData) in
                    if !isCancel{
                        APP_DELEGATE.hubConnectionConversation.stop()
                        APP_DELEGATE.setupCommunicationListener()
                        
                        self.objConversation = conversationData
                        self.setMessageData()
                    }
                }
                self.navigationController?.pushWithAnimation(viewController: objMessageProfileVC)
            }
            else if selectedIndex == 1{
                DispatchQueue.main.async {
                    _ = BHAlertVC.init(title:"", message: "lblLeaveChatValidation".localize, rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                        if actionType == .right {
                            if MessageManager.shared.isNetConnected{
                                MessageManager.shared.call_LeaveConvesationAPI(employeeConversationId: self.objConversation.employeeConversationId, showLoader: true) { isSuccess in
                                    if isSuccess{
                                        _ = tblConversationList().deleteConversation(employeeConversationId: self.objConversation.employeeConversationId)
                                        _ = tblMessages().deleteMessage(employeeConversationId: self.objConversation.employeeConversationId)
                                        
                                        DispatchQueue.main.async {
                                            self.navigationController?.popWithAnimation()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        cancel: {
            print("cancel")
        })
    }
    
    @IBAction func btnSendClick(_ sender: Any) {
        self.view.endEditing(true)
        
        self.btnConfirm.isHidden = true
        self.btnSend.isHidden = true
        self.btnCancel.isHidden = true
        self.btnAttachment.isHidden = false
        self.btnAudioRecord.isHidden = false
        self.txtMessage.isHidden = false
        self.lblRecordSound.isHidden = true
        
        if self.isRecording{
            recorder!.stop()
            
            self.isRecording = false
            if timerAudio?.isValid == true{
                timerAudio?.invalidate()
            }
            timerAudio = nil
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
            } catch let error as NSError {
                print("could not make session inactive")
                print(error.localizedDescription)
            }
            recorder = nil
        }
        else{
            let strMessage = self.txtMessage.text!.trimmingCharacters(in: .whitespaces)
            if strMessage.count > 0 {
                self.saveMessage(messageTypeId: MessageType.Text.rawValue, messageContent: strMessage, messageAttachment: "", replyMessageId: 0, forwardMessageId: 0, uploadingStatus: UploadingStatus.Uploaded.rawValue, mobilePrimaryKey: "")
            }
            else{
                MessageManager.shared.openCustomValidationAlertView(alertMessage: "KeylblMessageValidation".localize)
                return
            }
        }
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.view.endEditing(true)
        
        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.strRecordedAudioFileName){
            MessageManager.shared.deleteFileFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.strRecordedAudioFileName)
        }
        
        self.lblRecordSound.text = "00:00"
        
        self.btnConfirm.isHidden = true
        self.btnSend.isHidden = true
        self.btnCancel.isHidden = true
        self.btnAttachment.isHidden = false
        self.btnAudioRecord.isHidden = false
        
        self.lblRecordSound.isHidden = true
        self.txtMessage.isHidden = false
        if self.isRecording{
            self.isRecording = false
            if timerAudio?.isValid == true{
                timerAudio?.invalidate()
            }
            timerAudio = nil
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
            } catch let error as NSError {
//                print("could not make session inactive")
                print(error.localizedDescription)
            }
            recorder = nil
        }
    }
    
    @IBAction func btnAttachmentClick(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let objMessageAttachmentPickerVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageAttachmentPickerVC") as! MessageAttachmentPickerVC
        objMessageAttachmentPickerVC.modalPresentationStyle = .overCurrentContext
        objMessageAttachmentPickerVC.strTitle = "KeylblMessageAttachment".localize
        objMessageAttachmentPickerVC.setAttachmentHandler = {(index, isCancel) in
            if !isCancel{
                MessageManager().delay(delay: 0.5) {
                    if index == 1{
                        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
                        if authorizationStatus == .notDetermined{
                            PHPhotoLibrary.requestAuthorization({ (status) in
                                if (status == .authorized) {
                                    self.openImagePicker()
                                }
                            })
                        }
                        else if authorizationStatus == .authorized{
                            self.openImagePicker()
                        }
                        else{
                            DispatchQueue.main.async {
                                _ = BHAlertVC.init(title:"keyAlert".localize, message: "KeyPhotoPermissionMessage".localize, rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                                    if actionType == .right {
                                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                    }
                                }
                            }
                        }
                    }
                    else if index == 2{
                        PhotosUtility.shared.openCamera(self) { (image, responseURL, mediaType) in
                            if mediaType == "public.movie"{
                                _ = responseURL
                                let asset = AVURLAsset.init(url: responseURL! as URL)

                                DispatchQueue.main.async {
                                    let objVideoCropperVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "VideoCropperVC2") as! VideoCropperVC2
                                    objVideoCropperVC.conversationId = self.objConversation.conversationId
                                    objVideoCropperVC.strMessage = self.txtMessage.text ?? ""
                                    objVideoCropperVC.responseURL = responseURL! as URL
                                    objVideoCropperVC.asset = asset
                                    if #available(iOS 13.0, *) {
                                        objVideoCropperVC.modalPresentationStyle = .fullScreen
                                    }
                                    objVideoCropperVC.setVideoCropHandler = {(strUploadedFileName, message, isCancel) in
                                        if !isCancel{
                                            if let videoData = MessageManager.shared.getFileDataFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName){
                                                
                                                let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "mp4")
                                                
                                                MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName, fileData: videoData)
                                                
                                                let mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
                                                
                                                self.saveMediaMessage(messageTypeId: MessageType.Video.rawValue, messageContent: message, messageAttachment: strUploadedFileName, mobilePrimaryKey: mobilePrimaryKey, attachmentData: videoData)
                                            }
                                        }
                                    }
                                    MessageManager().delay(delay: 0.5, closure: {
                                        self.present(objVideoCropperVC, animated: true, completion: nil)
                                    })
                                }
                            }
                            else{
                                guard let image = image else { return }
    
                                let cropperViewController = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "CropperViewController") as! CropperViewController
                                cropperViewController.image = image
                                cropperViewController.isFromMessage = true
                                cropperViewController.strMessage = self.txtMessage.text ?? ""
                                if #available(iOS 13.0, *) {
                                    cropperViewController.modalPresentationStyle = .fullScreen
                                }
                                cropperViewController.setImageCropHandler = {(croppedImage, message, isCancel) in
                                    if !isCancel{
                                        let finalImage = croppedImage.fixOrientation().compress(to: 5000)
                                        let arrFileName = self.strImageName.components(separatedBy: ".")
                                        if arrFileName.count > 0{
                                            let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "jpg")
                                            
                                            MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName, fileData: finalImage.pngData()!)
                                            
                                            let mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
                                            
                                            self.saveMediaMessage(messageTypeId: MessageType.Image.rawValue, messageContent: message, messageAttachment: strUploadedFileName, mobilePrimaryKey: mobilePrimaryKey, attachmentData: finalImage.pngData()!)
                                        }
                                    }
                                }
                                MessageManager().delay(delay: 0.5, closure: {
                                    self.present(cropperViewController, animated: true, completion: nil)
                                })
                            }
                        }
                    }
                    else if index == 3{
                        self.openDocumentPicker()
                    }
                }
            }
        }
        self.navigationController?.present(objMessageAttachmentPickerVC, animated: false, completion: nil)
    }
    
    @IBAction func btnAudioRecordClick(_ sender: Any) {
        self.view.endEditing(true)
        
        self.btnConfirm.isHidden = false
        self.btnSend.isHidden = true
        self.btnCancel.isHidden = false
        self.btnAttachment.isHidden = true
        self.btnAudioRecord.isHidden = true
        
        self.txtMessage.isHidden = true
        self.lblRecordSound.isHidden = false
        
        self.intTimimg = 0
        self.intSeconds = 0
        self.intMinutes = 0
        self.intHours = 0
        //Start Recording
        if recorder == nil {
//            print("recording. recorder nil")
            isRecording = true
            recordWithPermission(true)
            return
        }
        
        isRecording = true
    }
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        if self.isRecording{
            recorder!.stop()
            
            self.isRecording = false
            if timerAudio?.isValid == true{
                timerAudio?.invalidate()
            }
            timerAudio = nil
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
            } catch let error as NSError {
                print("could not make session inactive")
                print(error.localizedDescription)
            }
            recorder = nil
        }
        
        self.view.endEditing(true)
        
        self.viewMessageTypeBG.isHidden = true
        self.txtMessage.isHidden = true
        self.btnAttachment.isHidden = true
        self.btnAudioRecord.isHidden = true
        self.btnConfirm.isHidden = true
        self.btnSend.isHidden = true
        self.btnCancel.isHidden = true
        self.viewMessageTypeBGHeight.constant = 0.0
        
        self.viewAudioPlayBG.isHidden = false
        self.btnPlayAudio.isHidden = false
        self.btnPauseAudio.isHidden = true
        self.audioSlider.isHidden = false
        self.btnSendAudio.isHidden = false
        self.btnCancelAudio.isHidden = false
        self.viewAudioPlayBGHeight.constant = 56.0
    }
    
    @IBAction func btnPlayRecordedAudioClick(_ sender: Any) {
        self.view.endEditing(true)
        do {
            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(self.recordedAudioFilePath.lastPathComponent)")
            
            player = try AVAudioPlayer(contentsOf: fileURL)
            guard let player = player else { return }
            
            if player.prepareToPlay() {
                self.btnPlayAudio.isHidden = true
                self.btnPauseAudio.isHidden = false
                player.delegate = self
                player.play()
                if timerAudioPlayer != nil {
                    timerAudioPlayer?.invalidate()
                }
                self.timerAudioPlayer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.displayAudioProgress), userInfo: nil, repeats: true)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func btnPauseRecordedAudioClick(_ sender: Any) {
        self.view.endEditing(true)
        self.btnPlayAudio.isHidden = false
        self.btnPauseAudio.isHidden = true
        
        self.stopPlayingAudio()
    }
    
    @IBAction func btnSendAudioClick(_ sender: Any) {
        self.view.endEditing(true)
        let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\("\(self.objConversation.conversationId)")/\(self.recordedAudioFilePath.lastPathComponent)")
        let audioData = try? Data(contentsOf: fileURL)
        if audioData != nil{
            if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.strRecordedAudioFileName){
                MessageManager.shared.deleteFileFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.strRecordedAudioFileName)
            }
            
            if self.recordedAudioFilePath.lastPathComponent != ""{
                MessageManager.shared.deleteFileFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.recordedAudioFilePath.lastPathComponent)
            }
            if self.recordedAudioUrl.lastPathComponent != ""{
                MessageManager.shared.deleteFileFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.recordedAudioUrl.lastPathComponent)
            }
            
            let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "wav")
            
            MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName, fileData: audioData!)
            
            let mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
            
            self.saveMediaMessage(messageTypeId: MessageType.Voice_Audio.rawValue, messageContent: "", messageAttachment: strUploadedFileName, mobilePrimaryKey: mobilePrimaryKey, attachmentData: audioData!)
            
            DispatchQueue.main.async {
                self.viewAudioPlayBG.isHidden = true
                self.btnPlayAudio.isHidden = true
                self.btnPauseAudio.isHidden = true
                self.audioSlider.isHidden = true
                self.btnSendAudio.isHidden = true
                self.btnCancelAudio.isHidden = true
                self.viewAudioPlayBGHeight.constant = 0.0
                
                self.viewMessageTypeBG.isHidden = false
                self.txtMessage.isHidden = false
                self.btnAttachment.isHidden = false
                self.btnAudioRecord.isHidden = false
                self.btnConfirm.isHidden = true
                self.btnSend.isHidden = true
                self.btnCancel.isHidden = true
                self.viewMessageTypeBGHeight.constant = 56.0
                
                self.txtMessage.isHidden = false
                self.lblRecordSound.text = "00:00"
                self.lblRecordSound.isHidden = true
            }
        }
    }
    
    @IBAction func btnCancelAudioClick(_ sender: Any) {
        self.view.endEditing(true)
        
        self.stopPlayingAudio()
        
        DispatchQueue.main.async {
            if self.recordedAudioFilePath != nil{
                if self.recordedAudioFilePath.lastPathComponent != ""{
                    MessageManager.shared.deleteFileFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.recordedAudioFilePath.lastPathComponent)
                }
            }
            
            if self.recordedAudioUrl != nil{
                if self.recordedAudioUrl.lastPathComponent != ""{
                    MessageManager.shared.deleteFileFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.recordedAudioUrl.lastPathComponent)
                }
            }
            
            self.recordedAudioFilePath = nil
            self.recordedAudioUrl = nil
            
            self.viewAudioPlayBG.isHidden = true
            self.btnPlayAudio.isHidden = true
            self.btnPauseAudio.isHidden = true
            self.audioSlider.isHidden = true
            self.btnSendAudio.isHidden = true
            self.btnCancelAudio.isHidden = true
            self.viewAudioPlayBGHeight.constant = 0.0
            
            self.viewMessageTypeBG.isHidden = false
            self.btnAttachment.isHidden = false
            self.btnAudioRecord.isHidden = false
            self.btnConfirm.isHidden = true
            self.btnSend.isHidden = true
            self.btnCancel.isHidden = true
            self.viewMessageTypeBGHeight.constant = 56.0
            
            self.txtMessage.isHidden = false
            self.lblRecordSound.text = "00:00"
            self.lblRecordSound.isHidden = true
        }
    }
    
    @IBAction func btnDismissOptionPopupClick(_ sender: Any) {
        self.view.endEditing(true)
        self.dismissOptionView()
    }
    
    func dismissOptionView(){
        self.view.endEditing(true)

        self.selectedSyncSection = -1
        self.selectedSyncRow = -1
        
        self.viewOptionPopupTop.constant = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (completed) -> Void in
            self.viewOptionPopupBG.isHidden = true
            self.viewOptionPopup.isHidden = true
        }
    }
    
    //MARK:- KEYBOARD OBSERVER METHODS
    @objc final func keyboardWillShow(notification: Notification) {
        self.moveToolbar(up: true, notification: notification)
    }
    
    @objc final func keyboardWillHide(notification: Notification) {
        self.moveToolbar(up: false, notification: notification)
    }
    
    final func moveToolbar(up: Bool, notification: Notification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        self.view.layoutIfNeeded()
        let tabbarHeight : CGFloat = 0.0
        let animationDuration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardHeight = up ? (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height - tabbarHeight : 0
        
        // Animation
        self.viewMessageBottom.constant = keyboardHeight + (UIDevice.hasNotch ? 0.0 : 10.0)
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: 
    // MARK: SAVE MEDIA MESSAGE METHODS
    func uploadUnsyncMediaFile(arrMessageData : [tblMessages]){
        if arrMessageData.count > 0{
            if arrMessageData[0].messageAttachment != ""{
                if let attachmentData = MessageManager.shared.getFileDataFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: arrMessageData[0].messageAttachment){
                    BHAzure.uploadAttachmentDataToAzure(mobilePrimaryKey: arrMessageData[0].mobilePrimaryKey, containerName: "\(MessageManager.shared.timiroCode)/\(DirectoryFolder.Communication.rawValue)", strFileName: arrMessageData[0].messageAttachment, fileData: attachmentData, resourceId: Int(self.objConversation.employeeConversationId), strResourceType: "MessageAttachment", completion: {
                        (success, mobilePrimaryKey)  in
                        if success{
                            DispatchQueue.main.async {
                                self.uploadOldMessageStatusAndReload(messageTypeId: arrMessageData[0].messageTypeId, messageContent: arrMessageData[0].messageContent, messageAttachment: arrMessageData[0].messageAttachment, mobilePrimaryKey: arrMessageData[0].mobilePrimaryKey, uploadingStatus: UploadingStatus.Uploaded.rawValue, messageDate: arrMessageData[0].messageDate)
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                self.uploadOldMessageStatusAndReload(messageTypeId: arrMessageData[0].messageTypeId, messageContent: arrMessageData[0].messageContent, messageAttachment: arrMessageData[0].messageAttachment, mobilePrimaryKey: arrMessageData[0].mobilePrimaryKey, uploadingStatus: UploadingStatus.Failed.rawValue, messageDate: arrMessageData[0].messageDate)
                            }
                        }
                    })
                }
            }
        }
    }
    
    func uploadOldMessageStatusAndReload(messageTypeId : Int, messageContent : String, messageAttachment : String, mobilePrimaryKey : String, uploadingStatus : Int, messageDate : Int64){
        let arrAllMessages = tblMessages.rowsFor(sql: "SELECT * FROM tblMessages WHERE employeeConversationId = '\(self.objConversation.employeeConversationId)' ORDER By messageDateTime")
        
        let arrMediaRemainingMessage = arrAllMessages.filter({$0.uploadingStatus != UploadingStatus.Uploaded.rawValue})
        if arrMediaRemainingMessage.count > 0{
            self.uploadUnsyncMediaFile(arrMessageData: arrMediaRemainingMessage)
        }
        
        self.saveMessage(messageTypeId: messageTypeId, messageContent: messageContent, messageAttachment: messageAttachment, replyMessageId: 0, forwardMessageId: 0, uploadingStatus: uploadingStatus, mobilePrimaryKey : mobilePrimaryKey)
        
        let existSectionData = self.arrFinalMessages.filter({$0.sectionDate == messageDate})
        if existSectionData.count > 0{
            for (indexSection, eleSectionData) in self.arrFinalMessages.enumerated(){
                if eleSectionData.sectionDate == messageDate{
                    for (indexRow, eleMessageData) in eleSectionData.arrMessage.enumerated(){
                        if eleMessageData.mobilePrimaryKey == mobilePrimaryKey{
                            eleMessageData.uploadingStatus = uploadingStatus
                            
                            let indexPath = IndexPath(row: indexRow, section: indexSection)
                            self.tblMessage.reloadRows(at: [indexPath], with: .none)
                            
                            break
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 
    // MARK: SAVE MEDIA MESSAGE METHODS
    func saveMediaMessage(messageTypeId : Int, messageContent : String, messageAttachment : String, mobilePrimaryKey : String, attachmentData : Data){
        let objMessageData = tblMessages()
        objMessageData.conversationMessageId = 0
        objMessageData.conversationId = self.objConversation.conversationId
        objMessageData.employeeConversationId = self.objConversation.employeeConversationId
        objMessageData.messageTypeId = messageTypeId
        objMessageData.messageContent = messageContent
        objMessageData.messageAttachment = messageAttachment
        objMessageData.messageDateTime = MessageManager.shared.getCurrentUTCTimeStamp()
        objMessageData.replyMessageId = 0
        objMessageData.forwardMessageId = 0
        objMessageData.senderEmployeeId = Int64(MessageManager.shared.employeeId) ?? 0
        objMessageData.mobilePrimaryKey = mobilePrimaryKey
        objMessageData.addedBy = Int64(MessageManager.shared.employeeId) ?? 0
        objMessageData.addedOn = 0
        objMessageData.isDeleted = false
        objMessageData.isSyncData = false
        objMessageData.isUpdatedData = false
        objMessageData.uploadingStatus = UploadingStatus.Uploading.rawValue
        objMessageData.messageDate = MessageManager.shared.getCurrentTimeStampMMDDYYYYFrom2(strDate: MessageManager.shared.dateFormatterCurrentMMDDYYYY().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: objMessageData.messageDateTime)))
        
        _ = objMessageData.save()
        
        let existSectionData = self.arrFinalMessages.filter({$0.sectionDate == objMessageData.messageDate})
        if existSectionData.count > 0{
            for (indexSection, eleSectionData) in self.arrFinalMessages.enumerated(){
                if eleSectionData.sectionDate == objMessageData.messageDate{
                    eleSectionData.arrMessage.append(objMessageData)
                    
                    let indexSet = IndexSet(integer: indexSection)
                    self.tblMessage.reloadSections(indexSet, with: .automatic)
                    break
                }
            }
        }
        else{
            var arrMessages : [tblMessages] = []
            arrMessages.append(objMessageData)
            let messageSectionData = ShareMessage(strDate: MessageManager.shared.dateFormatterEEEDDMMM().string(from: MessageManager.shared.getDateTime(timestamp: objMessageData.messageDate)), sectionDate: objMessageData.messageDate, arrMessage: arrMessages)
            
            self.arrFinalMessages.append(messageSectionData)
            
            self.tblMessage.reloadData()
        }
        
        BHAzure.uploadAttachmentDataToAzure(mobilePrimaryKey: mobilePrimaryKey, containerName: "\(MessageManager.shared.timiroCode)/\(DirectoryFolder.Communication.rawValue)", strFileName: messageAttachment, fileData: attachmentData, resourceId: Int(self.objConversation.employeeConversationId), strResourceType: "MessageAttachment", completion: {
            (success, mobilePrimaryKey)  in
            if success{
                DispatchQueue.main.async {
                    self.uploadStatusAndReload(messageTypeId: messageTypeId, messageContent: messageContent, messageAttachment: messageAttachment, mobilePrimaryKey: mobilePrimaryKey, uploadingStatus: UploadingStatus.Uploaded.rawValue, messageDate: objMessageData.messageDate)
                }
            }
            else{
                DispatchQueue.main.async {
                    self.uploadStatusAndReload(messageTypeId: messageTypeId, messageContent: messageContent, messageAttachment: messageAttachment, mobilePrimaryKey: mobilePrimaryKey, uploadingStatus: UploadingStatus.Failed.rawValue, messageDate: objMessageData.messageDate)
                }
            }
        })
    }
    
    func uploadStatusAndReload(messageTypeId : Int, messageContent : String, messageAttachment : String, mobilePrimaryKey : String, uploadingStatus : Int, messageDate : Int64){
        self.saveMessage(messageTypeId: messageTypeId, messageContent: messageContent, messageAttachment: messageAttachment, replyMessageId: 0, forwardMessageId: 0, uploadingStatus: uploadingStatus, mobilePrimaryKey : mobilePrimaryKey)
        
        let existSectionData = self.arrFinalMessages.filter({$0.sectionDate == messageDate})
        if existSectionData.count > 0{
            for (indexSection, eleSectionData) in self.arrFinalMessages.enumerated(){
                if eleSectionData.sectionDate == messageDate{
                    for (indexRow, eleMessageData) in eleSectionData.arrMessage.enumerated(){
                        if eleMessageData.mobilePrimaryKey == mobilePrimaryKey{
                            eleMessageData.uploadingStatus = uploadingStatus
                            
                            let indexPath = IndexPath(row: indexRow, section: indexSection)
                            self.tblMessage.reloadRows(at: [indexPath], with: .none)
                            
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: 
    // MARK: SAVE MESSAGE METHODS
    func saveMessage(messageTypeId : Int, messageContent : String, messageAttachment : String, replyMessageId : Int64, forwardMessageId : Int64, uploadingStatus : Int, mobilePrimaryKey : String){
        
        let arrExistMessageData = tblMessages.rowsFor(sql: "SELECT * from tblMessages where mobilePrimaryKey = '\(mobilePrimaryKey)'")
        if mobilePrimaryKey != "" && arrExistMessageData.count > 0{
            _ = tblMessages().updateUploadingStatusForMessage(uploadingStatus: uploadingStatus, employeeConversationId: arrExistMessageData[0].employeeConversationId, conversationMessageId: arrExistMessageData[0].conversationMessageId, mobilePrimaryKey: arrExistMessageData[0].mobilePrimaryKey)
            
            let existSectionData = self.arrFinalMessages.filter({$0.sectionDate == arrExistMessageData[0].messageDate})
            if existSectionData.count > 0{
                for (indexSection, eleSectionData) in self.arrFinalMessages.enumerated(){
                    if eleSectionData.sectionDate == arrExistMessageData[0].messageDate{
                        let indexSet = IndexSet(integer: indexSection)
                        self.tblMessage.reloadSections(indexSet, with: .automatic)
                        break
                    }
                }
            }
        }
        else{
            let objMessage = tblMessages()
            objMessage.conversationMessageId = 0
            objMessage.conversationId = self.objConversation.conversationId
            objMessage.employeeConversationId = self.objConversation.employeeConversationId
            objMessage.messageTypeId = messageTypeId
            objMessage.messageContent = messageContent
             objMessage.messageAttachment = messageAttachment
            objMessage.messageDateTime = MessageManager.shared.getCurrentUTCTimeStamp()
            objMessage.replyMessageId = replyMessageId
            objMessage.forwardMessageId = forwardMessageId
            objMessage.senderEmployeeId = Int64(MessageManager.shared.employeeId) ?? 0
            objMessage.mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
            objMessage.addedBy = Int64(MessageManager.shared.employeeId) ?? 0
            objMessage.addedOn = 0
            objMessage.isDeleted = false
            objMessage.isSyncData = false
            objMessage.isUpdatedData = false
            objMessage.uploadingStatus = uploadingStatus
            objMessage.messageDate = MessageManager.shared.getCurrentTimeStampMMDDYYYYFrom2(strDate: MessageManager.shared.dateFormatterCurrentMMDDYYYY().string(from: MessageManager.shared.getCurrentZoneDate(timestamp:  objMessage.messageDateTime)))
            
            _ = objMessage.save()
        }
        
        //===== Submit Read Message ======
        //================================
        self.readMessageOperation()
        //================================
        
        if MessageManager.shared.isNetConnected{
            let arrMessagesData = tblMessages.rowsFor(sql: "SELECT * FROM tblMessages where uploadingStatus = '\(UploadingStatus.Uploaded.rawValue)' AND (isSyncData = '\(0)' OR isUpdatedData = '\(1)')")
            if arrMessagesData.count > 0{
                MessageManager.shared.call_MessagesDataSubmitAPI(arrMessagesData: arrMessagesData, showLoader: false, mobilePrimaryKey: "") { _ in
                    self.resetMessageUI()
                }
            }
        }
        else{
            self.resetMessageUI()
        }
    }
    
    func resetMessageUI(){
        self.strImageName = ""
        self.txtMessage.text = ""
        
        self.btnConfirm.isHidden = true
        self.btnSend.isHidden = true
        self.btnCancel.isHidden = true
        self.btnAttachment.isHidden = false
        self.btnAudioRecord.isHidden = false
        
        self.txtMessage.isHidden = false
        self.lblRecordSound.text = "00:00"
        self.lblRecordSound.isHidden = true
        
        self.intTimimg = 0
        self.intSeconds = 0
        self.intMinutes = 0
        self.intHours = 0
        
        self.isRecording = false
        self.loadMessageDetails(isFirstCall: false)
    }
    
    func loadMessageDetails(isFirstCall : Bool) {
        self.txtMessage.resignFirstResponder()
        
        self.arrMessages = tblMessages.rowsFor(sql: "\(tblMessages().strMessageQuery()) WHERE employeeConversationId = '\(self.objConversation.employeeConversationId)' ORDER By messageDateTime")
        
        var arrAllMessageDate : [Int64] = []
        for messageData in self.arrMessages.sorted(by: {$0.messageDate < $1.messageDate}){
            arrAllMessageDate.append(messageData.messageDate)
        }
        
        let arrUniqueMessageDate = arrAllMessageDate.unique()
        
        self.arrFinalMessages.removeAll()
        if arrUniqueMessageDate.count > 0{
            for (index, eleDate) in arrUniqueMessageDate.enumerated(){
                let arrMessageData = self.arrMessages.filter({$0.messageDate == eleDate})
                if arrMessageData.count > 0{
                    let messageSectionData = ShareMessage(strDate: MessageManager.shared.dateFormatterEEEDDMMM().string(from: MessageManager.shared.getDateTime(timestamp: eleDate)), sectionDate: eleDate, arrMessage: arrMessageData)
                    
                    self.arrFinalMessages.append(messageSectionData)
                }
                
                if index == arrUniqueMessageDate.count - 1{
                    DispatchQueue.main.async {
                        self.tblMessage.reloadData()
                        if isFirstCall{
                            MessageManager().delay(delay: 0.2) {
                                self.scrollToBottom()
                                self.refreshControl.endRefreshing()
                            }
                        }
                        else{
                            MessageManager().delay(delay: 0.2) {
                                self.refreshControl.endRefreshing()
                            }
                        }
                        self.imgNoRecords.isHidden = self.arrFinalMessages.count > 0 ? true : false
                    }
                }
            }
        }
        else{
            DispatchQueue.main.async {
                MessageManager().delay(delay: 0.2) {
                    self.refreshControl.endRefreshing()
                }
            }
            self.imgNoRecords.isHidden = self.arrFinalMessages.count > 0 ? true : false
        }
    }

    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.arrFinalMessages.count > 0{
                let sectionCount = self.arrFinalMessages.count - 1
                if self.arrFinalMessages[sectionCount].arrMessage.count > 0{
                    let rowCount = self.arrFinalMessages[sectionCount].arrMessage.count - 1
                    let indexPath = IndexPath(row: rowCount, section: sectionCount)
                    self.tblMessage.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
            }
        }
    }
    
    // MARK: - 
    // MARK: - VIEW CYCYLE END
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopPlayingAudio()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - 
// MARK: - UITABLEVIEW DELEGATE METHODS
extension MessageVC : UITableViewDelegate,UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y <= 0{
//            if self.isMoreRecord{
//                self.call_MessageListAPI(isFirstCall: false)
//            }
//        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableview = object as? UITableView {
            tableview.layer.removeAllAnimations()
            if tableview == self.tblOptionPopup {
                self.tblOptionPopupHeight.constant = self.tblOptionPopup.contentSize.height
            }
            UIView.animate(withDuration: 1.5) {
                self.updateViewConstraints()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tblOptionPopup{
            return self.arrOptionSection.count
        }
        else{
            return self.arrFinalMessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tblOptionPopup{
            if section == 0{
                return 0.0
            }
            else{
                return 4.0
            }
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.tblOptionPopup{
            return nil
        }
        else{
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MessageHeaderCell") as! MessageHeaderCell
            let backgroundView = UIView(frame: header.bounds)
            backgroundView.backgroundColor = UIColor.clear
            header.backgroundView = backgroundView
            
            header.lblTitle.text = self.arrFinalMessages[section].strDate
            
            header.viewMessageBG.layer.cornerRadius = 10.0
            header.viewMessageBG.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.50, x: 0, y: 2, blur: 10, spread: 0)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblOptionPopup{
            return self.arrOptionSection[section].arrOptionItem.count
        }
        else{
            self.imgNoRecords.isHidden = self.arrFinalMessages.count > 0 ? true : false
            return self.arrFinalMessages[section].arrMessage.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblOptionPopup{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionListCell", for: indexPath) as! OptionListCell
    
            cell.lblOption.text = self.arrOptionSection[indexPath.section].arrOptionItem[indexPath.row]
            cell.imgOption.image = self.arrOptionSection[indexPath.section].arrImgOptionItem[indexPath.row]
            
            cell.lblSeprator.isHidden = indexPath.row == self.arrOptionSection[indexPath.section].arrOptionItem.count - 1 ? true : false
            if cell.lblOption.text == "KeylblDelete".localize{
                cell.lblOption.textColor = MessageTheme.Color.defaultRed
            }
            else{
                cell.lblOption.textColor = MessageTheme.Color.black
            }
            
            cell.selectionStyle = .none
            return cell
        }
        else{
            let messageData = self.arrFinalMessages[indexPath.section].arrMessage[indexPath.row]
            if messageData.isDeleted{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SystemGeneratedCell", for: indexPath) as! SystemGeneratedCell
                cell.lblMessage.text = messageData.messageContent
                
                cell.selectionStyle = .none
                return cell
            }
            else{
                if messageData.messageTypeId == MessageType.Text.rawValue{
                    if messageData.senderEmployeeId == Int64(MessageManager.shared.employeeId){
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTextCell", for: indexPath) as! SenderTextCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? "\("lblYou".localize)" : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        cell.lblMessage.text = messageData.messageContent
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTextCell", for: indexPath) as! ReceiverTextCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? MessageManager.shared.getFullName(firstName: messageData.firstName, middleName: "", lastName: messageData.lastName) : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        cell.lblMessage.text = messageData.messageContent
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                }
                else if messageData.messageTypeId == MessageType.Image.rawValue{
                    if messageData.senderEmployeeId == Int64(MessageManager.shared.employeeId){
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderImageCell", for: indexPath) as! SenderImageCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? "\("lblYou".localize)" : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        cell.viewSyncError.isHidden = true
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment) && messageData.messageAttachment != ""{
                            cell.imgAttachment.image = MessageManager.shared.getImageFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment)
                            cell.imgAttachment.layer.cornerRadius = 10.0
                            cell.imgAttachment.layer.masksToBounds = true
                            
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.isHidden = true
                            
                            if messageData.uploadingStatus == UploadingStatus.Failed.rawValue{
                                cell.viewSyncError.isHidden = false
                            }
                            else if messageData.uploadingStatus == UploadingStatus.Uploading.rawValue{
                                cell.downloadLoader.isHidden = false
                                if !cell.downloadLoader.isHidden{
                                    cell.downloadLoader.startAnimating()
                                }
                            }
                        }
                        else{
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                            cell.imgAttachment.image = #imageLiteral(resourceName: "imgAttachmentPlaceholder")
                            cell.imgAttachment.layer.cornerRadius = 10.0
                            cell.imgAttachment.layer.masksToBounds = true
                        }
                        
                        cell.lblMessageText.text = messageData.messageContent
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        cell.btnSyncError.intSection = indexPath.section
                        cell.btnSyncError.intRow = indexPath.row
                        cell.btnSyncError.addTarget(self, action: #selector(btnSyncErrorClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverImageCell", for: indexPath) as! ReceiverImageCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? MessageManager.shared.getFullName(firstName: messageData.firstName, middleName: "", lastName: messageData.lastName) : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment) && messageData.messageAttachment != ""{
                            cell.imgAttachment.image = MessageManager.shared.getImageFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment)
                            cell.imgAttachment.layer.cornerRadius = 10.0
                            cell.imgAttachment.layer.masksToBounds = true
                            
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.isHidden = true
                        }
                        else{
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                            cell.imgAttachment.image = #imageLiteral(resourceName: "imgAttachmentPlaceholder")
                            cell.imgAttachment.layer.cornerRadius = 10.0
                            cell.imgAttachment.layer.masksToBounds = true
                        }
                        
                        cell.lblMessageText.text = messageData.messageContent
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                }
                else if messageData.messageTypeId == MessageType.Voice_Audio.rawValue{
                    if messageData.senderEmployeeId == Int64(MessageManager.shared.employeeId){
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderAudioCell", for: indexPath) as! SenderAudioCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? "\("lblYou".localize)" : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        cell.viewSyncError.isHidden = true
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment){
                            cell.viewDownloadAudio.isHidden = true
                            cell.viewPlayAudio.isHidden = true
                            
                            if messageData.uploadingStatus == UploadingStatus.Failed.rawValue{
                                cell.viewSyncError.isHidden = false
                            }
                            else if messageData.uploadingStatus == UploadingStatus.Uploading.rawValue{
                                cell.viewDownloadAudio.isHidden = false
                                if !cell.downloadLoader.isHidden{
                                    cell.downloadLoader.startAnimating()
                                }
                            }
                            else{
                                cell.viewPlayAudio.isHidden = false
                                cell.btnPauseAudio.isHidden = true
                            }
                        }
                        else{
                            cell.viewDownloadAudio.isHidden = messageData.uploadingStatus == UploadingStatus.Uploading.rawValue ? true : false
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                            cell.viewPlayAudio.isHidden = true
                        }
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        cell.btnPlayAudio.intSection = indexPath.section
                        cell.btnPlayAudio.intRow = indexPath.row
                        cell.btnPlayAudio.addTarget(self, action: #selector(btnPlayAudioClick(_:)), for: .touchUpInside)
                        
                        cell.btnPauseAudio.intSection = indexPath.section
                        cell.btnPauseAudio.intRow = indexPath.row
                        cell.btnPauseAudio.addTarget(self, action: #selector(btnPauseAudioClick(_:)), for: .touchUpInside)
                        
                        cell.btnSyncError.intSection = indexPath.section
                        cell.btnSyncError.intRow = indexPath.row
                        cell.btnSyncError.addTarget(self, action: #selector(btnSyncErrorClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverAudioCell", for: indexPath) as! ReceiverAudioCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? MessageManager.shared.getFullName(firstName: messageData.firstName, middleName: "", lastName: messageData.lastName) : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment){
                            cell.viewDownloadAudio.isHidden = true
                            cell.viewPlayAudio.isHidden = false
                            cell.btnPauseAudio.isHidden = true
                        }
                        else{
                            cell.viewDownloadAudio.isHidden = false
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                            cell.viewPlayAudio.isHidden = true
                        }
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        cell.btnPlayAudio.intSection = indexPath.section
                        cell.btnPlayAudio.intRow = indexPath.row
                        cell.btnPlayAudio.addTarget(self, action: #selector(btnPlayAudioClick(_:)), for: .touchUpInside)
                        
                        cell.btnPauseAudio.intSection = indexPath.section
                        cell.btnPauseAudio.intRow = indexPath.row
                        cell.btnPauseAudio.addTarget(self, action: #selector(btnPauseAudioClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                }
                else if messageData.messageTypeId == MessageType.Video.rawValue {
                    if messageData.senderEmployeeId == Int64(MessageManager.shared.employeeId){
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderVideoCell", for: indexPath) as! SenderVideoCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? "\("lblYou".localize)" : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        cell.viewSyncError.isHidden = true
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment) && messageData.messageAttachment != ""{
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)")
                            do {
                                cell.imgAttachment.image = fileURL.generateThumbnail()
                            } catch {
                                print("Unable to read the file")
                            }
                            
                            cell.imgAttachment.layer.cornerRadius = 5.0
                            cell.imgAttachment.layer.masksToBounds = true
                            
                            cell.btnDownload.isHidden = true
                            cell.btnPlayVideo.isHidden = true
                            cell.downloadLoader.isHidden = true
                            
                            if messageData.uploadingStatus == UploadingStatus.Failed.rawValue{
                                cell.viewSyncError.isHidden = false
                            }
                            else if messageData.uploadingStatus == UploadingStatus.Uploading.rawValue{
                                cell.downloadLoader.isHidden = false
                                if !cell.downloadLoader.isHidden{
                                    cell.downloadLoader.startAnimating()
                                }
                            }
                            else{
                                cell.btnPlayVideo.isHidden = false
                            }
                        }
                        else{
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                            cell.btnPlayVideo.isHidden = true
                            cell.imgAttachment.image = #imageLiteral(resourceName: "videoAttachmentPlaceholder")
                        }
                        
                        cell.lblMessageText.text = messageData.messageContent
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        cell.btnPlayVideo.intSection = indexPath.section
                        cell.btnPlayVideo.intRow = indexPath.row
                        cell.btnPlayVideo.addTarget(self, action: #selector(btnPlayVideoClick(_:)), for: .touchUpInside)
                        
                        cell.btnSyncError.intSection = indexPath.section
                        cell.btnSyncError.intRow = indexPath.row
                        cell.btnSyncError.addTarget(self, action: #selector(btnSyncErrorClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverVideoCell", for: indexPath) as! ReceiverVideoCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? MessageManager.shared.getFullName(firstName: messageData.firstName, middleName: "", lastName: messageData.lastName) : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment) && messageData.messageAttachment != ""{
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)")
                            do {
                                cell.imgAttachment.image = fileURL.generateThumbnail()
                            } catch {
                                print("Unable to read the file")
                            }
                            
                            cell.imgAttachment.layer.cornerRadius = 5.0
                            cell.imgAttachment.layer.masksToBounds = true
                            
                            cell.btnDownload.isHidden = true
                            cell.btnPlayVideo.isHidden = false
                            cell.downloadLoader.isHidden = true
                        }
                        else{
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                            cell.btnPlayVideo.isHidden = true
                            cell.imgAttachment.image = #imageLiteral(resourceName: "videoAttachmentPlaceholder")
                        }
                        
                        cell.lblMessageText.text = messageData.messageContent
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        cell.btnPlayVideo.intSection = indexPath.section
                        cell.btnPlayVideo.intRow = indexPath.row
                        cell.btnPlayVideo.addTarget(self, action: #selector(btnPlayVideoClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                }
                else if messageData.messageTypeId == MessageType.Document.rawValue {
                    if messageData.senderEmployeeId == Int64(MessageManager.shared.employeeId){
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SenderDocCell", for: indexPath) as! SenderDocCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? "\("lblYou".localize)" : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        cell.viewSyncError.isHidden = true
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment){
                            
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.isHidden = true
                            
                            cell.viewPageCount.isHidden = true
                            
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)")
                            do {
                                self.generateThumbnail(for: fileURL) { thumbnail in
                                    if let thumbnail = thumbnail {
                                        cell.imgDocument.image = thumbnail
                                        if let pdfData = try? Data(contentsOf: fileURL) {
                                            if let pageCount = self.getPageCount(from: pdfData) {
                                                cell.viewPageCount.isHidden = false
                                                if pageCount > 1{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPages".localize)"
                                                }
                                                else{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPage".localize)"
                                                }
                                            } else {
                                                print("Failed to get page count")
                                            }
                                        } else {
                                            print("Failed to load PDF data from file")
                                        }
                                    } else {
                                        cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                                    }
                                }
                            } catch {
                                cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                            }
                            
                            if messageData.uploadingStatus == UploadingStatus.Failed.rawValue{
                                cell.viewSyncError.isHidden = false
                            }
                            else if messageData.uploadingStatus == UploadingStatus.Uploading.rawValue{
                                cell.downloadLoader.isHidden = false
                                if !cell.downloadLoader.isHidden{
                                    cell.downloadLoader.startAnimating()
                                }
                            }
                        }
                        else{
                            cell.viewPageCount.isHidden = true
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                        }
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        cell.btnSyncError.intSection = indexPath.section
                        cell.btnSyncError.intRow = indexPath.row
                        cell.btnSyncError.addTarget(self, action: #selector(btnSyncErrorClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                    else{
                        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverDocCell", for: indexPath) as! ReceiverDocCell
                        cell.viewUserName.isHidden = self.objConversation.isGroup ? false : true
                        cell.viewMessageTime.isHidden = messageData.isTimeVisible ? false : true
                        
                        cell.lblUserName.text = self.objConversation.isGroup ? MessageManager.shared.getFullName(firstName: messageData.firstName, middleName: "", lastName: messageData.lastName) : ""
                        cell.lblMessageTime.text = MessageManager.shared.viewCurrentDateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: Int64(messageData.messageDateTime)))
                        
                        if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment){
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.isHidden = true
                            
                            cell.viewPageCount.isHidden = true
                            
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)")
                            do {
                                self.generateThumbnail(for: fileURL) { thumbnail in
                                    if let thumbnail = thumbnail {
                                        cell.imgDocument.image = thumbnail
                                        if let pdfData = try? Data(contentsOf: fileURL) {
                                            if let pageCount = self.getPageCount(from: pdfData) {
                                                cell.viewPageCount.isHidden = false
                                                if pageCount > 1{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPages".localize)"
                                                }
                                                else{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPage".localize)"
                                                }
                                            } else {
                                                print("Failed to get page count")
                                            }
                                        } else {
                                            print("Failed to load PDF data from file")
                                        }
                                    } else {
                                        cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                                    }
                                }
                            } catch {
                                cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                            }
                        }
                        else{
                            cell.viewPageCount.isHidden = true
                            cell.btnDownload.isHidden = messageData.isDownloading ? true : false
                            cell.downloadLoader.isHidden = messageData.isDownloading ? false : true
                            if !cell.downloadLoader.isHidden{
                                cell.downloadLoader.startAnimating()
                            }
                        }
                        
                        cell.btnDownload.intSection = indexPath.section
                        cell.btnDownload.intRow = indexPath.row
                        cell.btnDownload.addTarget(self, action: #selector(btnDownloadClick(_:)), for: .touchUpInside)
                        
                        let interaction = UIContextMenuInteraction(delegate: self)
                        cell.viewMessageBG.addInteraction(interaction)
                        
                        cell.delegate = self
                        cell.tag = indexPath.row
                        cell.intSection = indexPath.section
                        cell.intRow = indexPath.row
                        
                        cell.selectionStyle = .none
                        return cell
                    }
                }
                else if messageData.messageTypeId == MessageType.SystemGenerated.rawValue {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SystemGeneratedCell", for: indexPath) as! SystemGeneratedCell
                    cell.lblMessage.text = messageData.messageContent
                    
                    cell.selectionStyle = .none
                    return cell
                }
                else if messageData.messageTypeId == MessageType.Location.rawValue {
                    return UITableViewCell()
                }
                else {
                    return UITableViewCell()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblOptionPopup{
            if self.selectedSyncSection != -1 && self.selectedSyncRow != -1{
                let indexPath = IndexPath(item: self.selectedSyncRow, section: self.selectedSyncSection)
                
                self.tblMessage.beginUpdates()
                if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderImageCell {
                    cell.btnDownload.isHidden = true
                    cell.viewSyncError.isHidden = true
                    cell.downloadLoader.isHidden = false
                    cell.downloadLoader.startAnimating()
                }
                else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderVideoCell {
                    cell.btnDownload.isHidden = true
                    cell.btnPlayVideo.isHidden = true
                    cell.viewSyncError.isHidden = true
                    cell.downloadLoader.isHidden = false
                    cell.downloadLoader.startAnimating()
                }
                else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderAudioCell {
                    cell.viewDownloadAudio.isHidden = false
                    cell.btnDownload.isHidden = true
                    cell.viewPlayAudio.isHidden = true
                    cell.viewSyncError.isHidden = true
                    cell.downloadLoader.isHidden = false
                    cell.downloadLoader.startAnimating()
                }
                else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderDocCell {
                    cell.btnDownload.isHidden = true
                    cell.viewSyncError.isHidden = true
                    cell.downloadLoader.isHidden = false
                    cell.downloadLoader.startAnimating()
                }
                self.tblMessage.endUpdates()
            }
            
            self.dismissOptionView()
            
            if indexPath.section == 0 && indexPath.row == 0{
                if MessageManager.shared.checkFileExist(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.selectedMessageData.messageAttachment) && self.selectedMessageData.messageAttachment != ""{
                    if let attachmentData = MessageManager.shared.getFileDataFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.selectedMessageData.messageAttachment){
                        BHAzure.uploadAttachmentDataToAzure(mobilePrimaryKey: self.selectedMessageData.mobilePrimaryKey, containerName: "\(MessageManager.shared.timiroCode)/\(DirectoryFolder.Communication.rawValue)", strFileName: self.selectedMessageData.messageAttachment, fileData: attachmentData, resourceId: Int(self.objConversation.employeeConversationId), strResourceType: "MessageAttachment", completion: {
                            (success, mobilePrimaryKey)  in
                            if success{
                                DispatchQueue.main.async {
                                    self.saveMessage(messageTypeId: MessageType.Document.rawValue, messageContent: self.selectedMessageData.messageContent, messageAttachment: self.selectedMessageData.messageAttachment, replyMessageId: self.selectedMessageData.replyMessageId, forwardMessageId: self.selectedMessageData.forwardMessageId, uploadingStatus: UploadingStatus.Uploaded.rawValue, mobilePrimaryKey: self.selectedMessageData.mobilePrimaryKey)
                                }
                            }
                            else{
                                self.saveMessage(messageTypeId: MessageType.Document.rawValue, messageContent: self.selectedMessageData.messageContent, messageAttachment: self.selectedMessageData.messageAttachment, replyMessageId: self.selectedMessageData.replyMessageId, forwardMessageId: self.selectedMessageData.forwardMessageId, uploadingStatus: UploadingStatus.Failed.rawValue, mobilePrimaryKey: self.selectedMessageData.mobilePrimaryKey)
                            }
                        })
                    }
                }
            }
            else if indexPath.section == 0 && indexPath.row == 1{
                _ = tblMessages().deleteMessage(mobilePrimaryKey: self.selectedMessageData.mobilePrimaryKey)
                
                for (indexSection, eleSectionData) in self.arrFinalMessages.enumerated(){
                    if eleSectionData.sectionDate == self.selectedMessageData.messageDate{
                        for (indexRow, eleMessageData) in eleSectionData.arrMessage.enumerated(){
                            if eleMessageData.mobilePrimaryKey == self.selectedMessageData.mobilePrimaryKey{
                                if self.arrFinalMessages[indexSection].arrMessage.count > indexRow{
                                    self.arrFinalMessages[indexSection].arrMessage.remove(at: indexRow)
                                }
                                
                                if self.arrFinalMessages[indexSection].arrMessage.count == 0{
                                    if self.arrFinalMessages.count > indexSection{
                                        self.arrFinalMessages.remove(at: indexSection)
                                        self.tblMessage.reloadData()
                                    }
                                }
                                else{
                                    let indexSet = IndexSet(integer: indexSection)
                                    self.tblMessage.reloadSections(indexSet, with: .automatic)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc private func handleSingleTap(_ tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == UITapGestureRecognizer.State.ended {
            let tapLocation = tapGesture.location(in: self.tblMessage)
            if let tapIndexPath = self.tblMessage.indexPathForRow(at: tapLocation) {
                let messageData = self.arrFinalMessages[tapIndexPath.section].arrMessage[tapIndexPath.row]
                let objAttachmentViewVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "AttachmentViewVC") as! AttachmentViewVC
                if messageData.messageAttachment != ""{
                    if messageData.messageTypeId == MessageType.Image.rawValue {
                        if let image = MessageManager.shared.getImageFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: messageData.messageAttachment){
                            objAttachmentViewVC.strAttachmentText = messageData.messageContent
                            objAttachmentViewVC.attachmentData = image.jpegData(compressionQuality: 1.0)!
                            objAttachmentViewVC.isDocumentAttachment = false
                            objAttachmentViewVC.isPDFAttachment = false
                            objAttachmentViewVC.strDocumentAttachmentTitle = "KeylblMessageAttachment".localize
                            objAttachmentViewVC.modalPresentationStyle = .overCurrentContext
                            self.present(objAttachmentViewVC, animated: false, completion: nil)
                        }
                    }
                    else if messageData.messageTypeId == MessageType.Document.rawValue{
                        if messageData.messageAttachment != ""{
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)")
                            do {
                                let attachmentData = try Data(contentsOf: fileURL)
                                if attachmentData != nil{
                                    objAttachmentViewVC.attachmentData = attachmentData
                                    objAttachmentViewVC.isPDFAttachment = true
                                    objAttachmentViewVC.isDocumentAttachment = false
                                    objAttachmentViewVC.strDocumentAttachmentTitle = "KeylblMessageAttachment".localize
                                    objAttachmentViewVC.modalPresentationStyle = .overCurrentContext
                                    self.present(objAttachmentViewVC, animated: false, completion: nil)
                                }
                            } catch {
                                print("Unable to read the file")
                            }
                        }
                    }
                    else if messageData.messageTypeId == MessageType.Video.rawValue{
                        if messageData.messageAttachment != ""{
                            let objAttachmentViewVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "AttachmentViewVC") as! AttachmentViewVC
                            objAttachmentViewVC.isDocumentAttachment = false
                            objAttachmentViewVC.isPDFAttachment = false
                            objAttachmentViewVC.isVideoAttachment = true
                            objAttachmentViewVC.strFilePath = "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)"
                            objAttachmentViewVC.strDocumentAttachmentTitle = "KeylblMessageAttachment".localize
                            self.navigationController?.pushWithAnimation(viewController: objAttachmentViewVC)
                        }
                    }
                }
            }
        }
    }

    @objc private func handleDoubleTap(_ tapGesture: UITapGestureRecognizer) {
        print("Double Tap Click")
        if tapGesture.state == UITapGestureRecognizer.State.ended {
            let tapLocation = tapGesture.location(in: self.tblMessage)
            if let tapIndexPath = self.tblMessage.indexPathForRow(at: tapLocation) {
                let messageData = self.arrFinalMessages[tapIndexPath.section].arrMessage[tapIndexPath.row]
                if messageData.isTimeVisible{
                    messageData.isTimeVisible = false
                }
                else{
                    messageData.isTimeVisible = true
                }
                self.tblMessage.reloadRows(at: [tapIndexPath], with: .none)
            }
        }
    }
    
    //MARK:- REFRESH METHODS
    func prepareReloadData() {
        let previousContentHeight = self.tblMessage.contentSize.height
        let previousContentOffset = self.tblMessage.contentOffset.y
        DispatchQueue.main.async {
            self.tblMessage.reloadData()
        }
        let currentContentOffset = self.tblMessage.contentSize.height - previousContentHeight + previousContentOffset
        self.tblMessage.contentOffset = CGPoint(x: 0, y: currentContentOffset)
    }
   
    // MARK: 
    // MARK: BUTTON ACTION METHODS FOR TABLEVIEW CELL BUTTO
    @IBAction func btnSyncErrorClick(_ sender: BMCustomButton) {
        self.view.endEditing(true)
        
        self.selectedSyncSection = sender.intSection
        self.selectedSyncRow = sender.intRow
        
        self.selectedMessageData = self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow]
        
        self.lblPopupTitle.text = "KeylblSyncAgainTitle".localize
        
        self.arrOptionSection.removeAll()
        
        let section0 = ShareOptions()
        section0.arrOptionItem = ["\("KeylblSendAgain".localize)", "\("KeylblDelete".localize)"]
        section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgSendAgain"), #imageLiteral(resourceName: "trash")]
        section0.sectionTag = 1
        self.arrOptionSection.append(section0)
        
        self.viewOptionPopup.isHidden = false
        self.viewOptionPopupBG.isHidden = false
        self.tblOptionPopup.reloadData()
        
        self.viewOptionPopupTop.constant = -(self.viewTopOptionPopup.frame.height + self.tblOptionPopupHeight.constant + self.viewBottomOptionPopup.frame.height)
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (completed) -> Void in
            
        }
    }
    
    @IBAction func btnDownloadClick(_ sender: BMCustomButton) {
        self.view.endEditing(true)
        
        if self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment != ""{
            self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].isDownloading = true
            
            _ = tblMessages().updateDownloadingFlag(isDownloading: 1, conversationMessageId: self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].conversationMessageId)
            
            let indexPath = IndexPath(item: sender.intRow, section: sender.intSection)
            
            if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderImageCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverImageCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderVideoCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverVideoCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderDocCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverDocCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderAudioCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverAudioCell {
                cell.btnDownload.isHidden = true
                cell.downloadLoader.isHidden = false
                cell.downloadLoader.startAnimating()
            }
            
            BHAzure.loadAttachmentDataFromAzure(containerName: "\(MessageManager.shared.timiroCode)/\(DirectoryFolder.Communication.rawValue)", strFileName: self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment) { success, error, data in
                
                self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].isDownloading = false
                
                _ = tblMessages().updateDownloadingFlag(isDownloading: 0, conversationMessageId: self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].conversationMessageId)
                
                if success && data != nil{
                    DispatchQueue.main.async {
                        MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment, fileData: data!)
                        
                        if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderImageCell {
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.stopAnimating()
                            cell.downloadLoader.isHidden = true
                            if self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment != ""{
                                cell.imgAttachment.image = MessageManager.shared.getImageFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)
                                cell.imgAttachment.layer.cornerRadius = 5.0
                                cell.imgAttachment.layer.masksToBounds = true
                            }
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverImageCell {
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.stopAnimating()
                            cell.downloadLoader.isHidden = true
                            if self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment != ""{
                                cell.imgAttachment.image = MessageManager.shared.getImageFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)
                                cell.imgAttachment.layer.cornerRadius = 5.0
                                cell.imgAttachment.layer.masksToBounds = true
                            }
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderVideoCell {
                            cell.btnDownload.isHidden = true
                            cell.btnPlayVideo.isHidden = false
                            cell.downloadLoader.stopAnimating()
                            cell.downloadLoader.isHidden = true
                            if self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment != ""{
                                let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)")
                                do {
                                    cell.imgAttachment.image = fileURL.generateThumbnail()
                                } catch {
                                    print("Unable to read the file")
                                }
                                cell.imgAttachment.layer.cornerRadius = 5.0
                                cell.imgAttachment.layer.masksToBounds = true
                            }
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverVideoCell {
                            cell.btnDownload.isHidden = true
                            cell.btnPlayVideo.isHidden = false
                            cell.downloadLoader.stopAnimating()
                            cell.downloadLoader.isHidden = true
                            if self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment != ""{
                                let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)")
                                do {
                                    cell.imgAttachment.image = fileURL.generateThumbnail()
                                } catch {
                                    print("Unable to read the file")
                                }
                                cell.imgAttachment.layer.cornerRadius = 5.0
                                cell.imgAttachment.layer.masksToBounds = true
                            }
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderDocCell {
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.stopAnimating()
                            cell.downloadLoader.isHidden = true
                            
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)")
                            do {
                                self.generateThumbnail(for: fileURL) { thumbnail in
                                    if let thumbnail = thumbnail {
                                        cell.imgDocument.image = thumbnail
                                        if let pdfData = try? Data(contentsOf: fileURL) {
                                            if let pageCount = self.getPageCount(from: pdfData) {
                                                cell.viewPageCount.isHidden = false
                                                if pageCount > 1{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPages".localize)"
                                                }
                                                else{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPage".localize)"
                                                }
                                            } else {
                                                print("Failed to get page count")
                                            }
                                        } else {
                                            print("Failed to load PDF data from file")
                                        }
                                    } else {
                                        cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                                    }
                                }
                            } catch {
                                cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                            }
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverDocCell {
                            cell.btnDownload.isHidden = true
                            cell.downloadLoader.stopAnimating()
                            cell.downloadLoader.isHidden = true
                            
                            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)")
                            do {
                                self.generateThumbnail(for: fileURL) { thumbnail in
                                    if let thumbnail = thumbnail {
                                        cell.imgDocument.image = thumbnail
                                        if let pdfData = try? Data(contentsOf: fileURL) {
                                            if let pageCount = self.getPageCount(from: pdfData) {
                                                cell.viewPageCount.isHidden = false
                                                if pageCount > 1{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPages".localize)"
                                                }
                                                else{
                                                    cell.lblPageCount.text = "\(pageCount) \("lblPage".localize)"
                                                }
                                            } else {
                                                print("Failed to get page count")
                                            }
                                        } else {
                                            print("Failed to load PDF data from file")
                                        }
                                    } else {
                                        cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                                    }
                                }
                            } catch {
                                cell.imgDocument.image = #imageLiteral(resourceName: "docAttachmentPlaceholder")
                            }
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderAudioCell {
                            cell.downloadLoader.stopAnimating()
                            cell.viewDownloadAudio.isHidden = true
                            cell.viewPlayAudio.isHidden = false
                            cell.btnPauseAudio.isHidden = true
                            UIView.animate(withDuration: 0.2, animations: {
                                cell.audioSlider.setValue(0.0, animated: true)
                            })
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverAudioCell {
                            cell.downloadLoader.stopAnimating()
                            cell.viewDownloadAudio.isHidden = true
                            cell.viewPlayAudio.isHidden = false
                            cell.btnPauseAudio.isHidden = true
                            UIView.animate(withDuration: 0.2, animations: {
                                cell.audioSlider.setValue(0.0, animated: true)
                            })
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {
                        if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderImageCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverImageCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderVideoCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverVideoCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderDocCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverDocCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderAudioCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverAudioCell {
                            cell.btnDownload.isHidden = false
                            cell.downloadLoader.isHidden = true
                            cell.downloadLoader.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnPlayAudioClick(_ sender: BMCustomButton) {
        self.view.endEditing(true)
        self.selectedIndexPath = IndexPath(item: sender.intRow, section: sender.intSection)
        
        if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? SenderAudioCell {
            cell.btnPlayAudio.isHidden = true
            cell.btnPauseAudio.isHidden = false
        }
        else if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? ReceiverAudioCell {
            cell.btnPlayAudio.isHidden = true
            cell.btnPauseAudio.isHidden = false
        }
        
        do {
            let fileURL = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow].messageAttachment)")
            
            player = try AVAudioPlayer(contentsOf: fileURL)
            guard let player = player else { return }
            
            if player.prepareToPlay() {
                player.delegate = self
                player.play()
                if timerAudioPlayer != nil {
                    timerAudioPlayer?.invalidate()
                }
                self.timerAudioPlayer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.displayCellAudioProgress), userInfo: nil, repeats: true)
            }
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func btnPauseAudioClick(_ sender: BMCustomButton) {
        self.view.endEditing(true)
        self.selectedIndexPath = IndexPath(item: sender.intRow, section: sender.intSection)
        
        if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? SenderAudioCell {
            cell.btnPlayAudio.isHidden = false
            cell.btnPauseAudio.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                cell.audioSlider.setValue(0.0, animated: true)
            })
        }
        else if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? ReceiverAudioCell {
            cell.btnPlayAudio.isHidden = false
            cell.btnPauseAudio.isHidden = true
            UIView.animate(withDuration: 0.2, animations: {
                cell.audioSlider.setValue(0.0, animated: true)
            })
        }
        self.stopPlayingAudio()
    }
    
    @IBAction func btnPlayVideoClick(_ sender: BMCustomButton) {
        self.view.endEditing(true)
        let messageData = self.arrFinalMessages[sender.intSection].arrMessage[sender.intRow]
        if messageData.messageAttachment != ""{
            let objAttachmentViewVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "AttachmentViewVC") as! AttachmentViewVC
            objAttachmentViewVC.isDocumentAttachment = false
            objAttachmentViewVC.isPDFAttachment = false
            objAttachmentViewVC.isVideoAttachment = true
            objAttachmentViewVC.strFilePath = "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(messageData.messageAttachment)"
            objAttachmentViewVC.strDocumentAttachmentTitle = "KeylblMessageAttachment".localize
            self.navigationController?.pushWithAnimation(viewController: objAttachmentViewVC)
        }
    }
    
    // MARK: 
    // MARK: AUDIO RECORDING, PERMISSION, SAVE, PLAY & PAUSE METHODS
    func stopAudio() {
        if timerAudio?.isValid == true {
            timerAudio?.invalidate()
        }
        timerAudio = nil
        recorder!.stop()
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    @objc func displayAudioProgress() {
        let currentTime = player?.currentTime
        let duration = player?.duration
        let progress = currentTime!/duration!
        
        self.audioSlider.setValue(Float(progress), animated: true)
                
        if currentTime == 0 {
            if timerAudioPlayer != nil {
                timerAudioPlayer?.invalidate()
            }
        }
    }
    
    @objc func displayCellAudioProgress() {
        let currentTime = player?.currentTime
        let duration = player?.duration
        let progress = currentTime!/duration!
        
        if selectedIndexPath != nil {
            if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? SenderAudioCell {
                UIView.animate(withDuration: 0.2, animations: {
                    cell.audioSlider.setValue(Float(progress), animated: true)
                })
            }
            else if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? ReceiverAudioCell {
                UIView.animate(withDuration: 0.2, animations: {
                    cell.audioSlider.setValue(Float(progress), animated: true)
                })
            }
            
            if currentTime == 0 {
                if timerAudioPlayer != nil {
                    timerAudioPlayer?.invalidate()
                }
            }
        }
    }
    
    func stopPlayingAudio() {
        if self.player != nil {
            self.player?.stop()
            self.player = nil
        }
        
        if self.timerAudioPlayer != nil {
            self.timerAudioPlayer?.invalidate()
        }
        selectedIndexPath = nil
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func recordWithPermission(_ setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder!.record()
                    self.timerAudio = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.displayResult), userInfo: nil, repeats: true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setupRecorder() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: filePath) {
                MessageManager.shared.createDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        let strDateNow:String = String(format:"%.f", Double(Date().timeIntervalSince1970))
        let currentFileName = "MyAudio-\(strDateNow).m4a"
        self.strRecordedAudioFileName = currentFileName
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)/\(currentFileName)")
        if fileManager.fileExists(atPath: paths){
            
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey : 320000 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey : 44100.0 as AnyObject
        ]
        
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let soundFileURL = documentsPath.appendingPathComponent("\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)").appendingPathComponent(currentFileName)
            
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder!.delegate = self
            recorder!.isMeteringEnabled = true
            recorder!.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
    }
    
    @objc func displayResult() {
        self.intTimimg += 1
        
        if self.intTimimg < 61 {
            self.intSeconds = self.intTimimg % 60
            self.intMinutes = (self.intTimimg / 60) % 60
            self.intHours = self.intTimimg / 3600
        } else {
            if self.timerAudio?.isValid == true {
                self.timerAudio?.invalidate()
            }
            self.timerAudio = nil
            self.stopAudio()
        }
        self.lblRecordSound.text = String(format:"%02d:%02d",intMinutes,intSeconds)
    }
    
    func checkHeadphones() {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if currentRoute.outputs.count > 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        }
    }
    
    func askForNotifications() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.background(_:)), name:UIApplication.willResignActiveNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.foreground(_:)), name:UIApplication.willEnterForegroundNotification, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.routeChange(_:)), name:AVAudioSession.routeChangeNotification, object:nil)
    }
    
    @objc func background(_ notification:Notification) {
        print("background")
    }
    
    @objc func foreground(_ notification:Notification) {
        print("foreground")
    }
    
    @objc func routeChange(_ notification:Notification) {
        if let userInfo = notification.userInfo {
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt {
                //print("reason \(reason)")
                switch AVAudioSession.RouteChangeReason(rawValue: reason)! {
                case AVAudioSession.RouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSession.RouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSession.RouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSession.RouteChangeReason.override:
                    print("Override")
                case AVAudioSession.RouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSession.RouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSession.RouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSession.RouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")

                @unknown default: break
                    
                }
            }
        }
    }
}

// MARK: - 
// MARK: - AVAUDIO RECORDER DELEGATE METHODS
extension MessageVC : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Hello ")
        let strUrl = recorder.url
        print(strUrl)
        self.exportAudioAssets(strUrl)
        self.recorder = nil
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    func exportAudioAssets(_ audioUrl:URL){
        self.isRecording = false
        if timerAudio?.isValid == true{
            timerAudio?.invalidate()
        }
        timerAudio = nil
        
        let strDateNow:String = String(format:"%.f", Double(Date().timeIntervalSince1970))
        let currentFileName = "MyAudio_\(strDateNow).m4a"
        self.strRecordedAudioFileName = currentFileName
        
        let fullUrl = URL.init(fileURLWithPath: "\(MessageManager.shared.getDocumentDirPath())/\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)")
        let finalString = fullUrl.appendingPathComponent(currentFileName)
        self.recordedAudioFilePath = finalString
        self.recordedAudioUrl = audioUrl
        
        let avAsset = AVAsset(url: audioUrl)
        let exportSession = AVAssetExportSession.init(asset: avAsset, presetName: AVAssetExportPresetAppleM4A)
        exportSession?.outputURL = finalString
        exportSession?.outputFileType = AVFileType.m4a
        exportSession!.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithm.varispeed
        
        exportSession?.exportAsynchronously(completionHandler: { () -> Void in
            switch exportSession!.status {
                case AVAssetExportSession.Status.failed:
                print(exportSession?.error?.localizedDescription as Any)
                    break
                case AVAssetExportSession.Status.cancelled:
                    break
                case AVAssetExportSession.Status.completed:
                    DispatchQueue.main.async {
                        
                    }
                    break
                default :
                    break
            }
        })
    }
}

// MARK: - 
// MARK: - AVAUDIO PLAYER DELEGATE METHODS
extension MessageVC : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if self.selectedIndexPath != nil {
            if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? SenderAudioCell {
                cell.btnPlayAudio.isHidden = false
                cell.btnPauseAudio.isHidden = true
                UIView.animate(withDuration: 0.2, animations: {
                    cell.audioSlider.setValue(0.0, animated: true)
                })
            }
            else if let cell = self.tblMessage.cellForRow(at: self.selectedIndexPath!) as? ReceiverAudioCell {
                cell.btnPlayAudio.isHidden = false
                cell.btnPauseAudio.isHidden = true
                UIView.animate(withDuration: 0.2, animations: {
                    cell.audioSlider.setValue(0.0, animated: true)
                })
            }
        }
    }
}

// MARK: - 
// MARK: - Submit Read Message
extension MessageVC {

    func readMessageOperation(){
        
        if(MessageManager.shared.isNetConnected){
            MessageManager.shared.call_MessagesDataReadAPI(empConversationId: self.objConversation.employeeConversationId, showLoader: false) { isSuccess in
                
                MessageManager.shared.call_ReadMessagesAPI(employeeConversationId: self.objConversation.employeeConversationId, showLoader: false) { isSuccess in
                    
                }
            }
            
        }
    }
}


// MARK: - 
// MARK: - URLSESSION DOWMLOAD DELEGATE METHODS
extension MessageVC:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent("\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)").appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            print(destinationURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - 
// MARK: - TEXTFIELD DELEGATE METHODS
extension MessageVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if str.count == 0{
            self.btnConfirm.isHidden = true
            self.btnSend.isHidden = true
            self.btnCancel.isHidden = true
            self.btnAttachment.isHidden = false
            self.btnAudioRecord.isHidden = false
        }
        else{
            self.btnConfirm.isHidden = true
            self.btnSend.isHidden = false
            self.btnCancel.isHidden = true
            self.btnAttachment.isHidden = false
            self.btnAudioRecord.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.txtMessage.resignFirstResponder()
        if self.txtMessage.text == ""{
            self.btnConfirm.isHidden = true
            self.btnSend.isHidden = true
            self.btnCancel.isHidden = true
            self.btnAttachment.isHidden = false
            self.btnAudioRecord.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtMessage.resignFirstResponder()
        return true
    }
}

// MARK: 
// MARK: UIDocumentPicker Delegate Method
extension MessageVC: UIDocumentPickerDelegate {
    // MARK: 
    // MARK: IMAGE PICKER METHODS
    func openImagePicker(){
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 1
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.selection.unselectOnReachingMax = true
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        imagePicker.albumButton.tintColor = MessageTheme.Color.white
        imagePicker.cancelButton.tintColor = MessageTheme.Color.primaryTheme
        imagePicker.doneButton.tintColor = MessageTheme.Color.primaryTheme
        imagePicker.navigationBar.barTintColor = MessageTheme.Color.white
        imagePicker.settings.theme.backgroundColor = MessageTheme.Color.white
        imagePicker.settings.theme.selectionFillColor = MessageTheme.Color.primaryTheme
        imagePicker.settings.theme.selectionStrokeColor = MessageTheme.Color.white
        imagePicker.settings.theme.selectionShadowColor = MessageTheme.Color.clear
        imagePicker.settings.theme.previewTitleAttributes = [NSAttributedString.Key.font: UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_16 : MessageTheme.Size.Size_24) as Any,NSAttributedString.Key.foregroundColor: MessageTheme.Color.white]
        imagePicker.settings.theme.previewSubtitleAttributes = [NSAttributedString.Key.font: UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_12 : MessageTheme.Size.Size_18) as Any,NSAttributedString.Key.foregroundColor: MessageTheme.Color.white]
        imagePicker.settings.theme.albumTitleAttributes = [NSAttributedString.Key.font: UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_12 : MessageTheme.Size.Size_26) as Any,NSAttributedString.Key.foregroundColor: MessageTheme.Color.white]
        imagePicker.settings.list.cellsPerRow = {(verticalSize: UIUserInterfaceSizeClass, horizontalSize: UIUserInterfaceSizeClass) -> Int in
            switch (verticalSize, horizontalSize) {
            case (.compact, .regular): // iPhone5-6 portrait
                return 2
            case (.compact, .compact): // iPhone5-6 landscape
                return 2
            case (.regular, .regular): // iPad portrait/landscape
                return 3
            default:
                return 2
            }
        }
        
        self.presentImagePicker(imagePicker, select: { (asset) in
            
        }, deselect: { (asset) in
            
        }, cancel: { (assets) in
            
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            for i in 0...assets.count - 1{
                if assets[i].mediaType == .image{
                    MessageManager.shared.getUIImage(objVC: self, asset: assets[i]) { (image, strName) in
                        if image != nil{
                            self.strImageName = strName!
                            
                            let cropperViewController = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "CropperViewController") as! CropperViewController
                            cropperViewController.image = image
                            cropperViewController.isFromMessage = true
                            cropperViewController.strMessage = self.txtMessage.text ?? ""
                            if #available(iOS 13.0, *) {
                                cropperViewController.modalPresentationStyle = .fullScreen
                            }
                            cropperViewController.setImageCropHandler = {(croppedImage, message, isCancel) in
                                if !isCancel{
                                    let finalImage = croppedImage.fixOrientation().compress(to: 5000)
                                    let arrFileName = self.strImageName.components(separatedBy: ".")
                                    if arrFileName.count > 0{
                                        let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "jpg")
                                        MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName, fileData: finalImage.pngData()!)
                                        
                                        let mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
                                        
                                        self.saveMediaMessage(messageTypeId: MessageType.Image.rawValue, messageContent: message, messageAttachment: strUploadedFileName, mobilePrimaryKey: mobilePrimaryKey, attachmentData: finalImage.pngData()!)
                                    }
                                }
                            }
                            MessageManager().delay(delay: 0.5, closure: {
                                self.present(cropperViewController, animated: true, completion: nil)
                            })
                        }
                    }
                }
                else{
                    assets[0].getURL { responseURL in
                        _ = responseURL as? NSURL
                        let asset = AVURLAsset.init(url: responseURL! as URL)

                        DispatchQueue.main.async {
                            let objVideoCropperVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "VideoCropperVC2") as! VideoCropperVC2
                            objVideoCropperVC.conversationId = self.objConversation.conversationId
                            objVideoCropperVC.strMessage = self.txtMessage.text ?? ""
                            objVideoCropperVC.responseURL = responseURL
                            objVideoCropperVC.asset = asset
                            if #available(iOS 13.0, *) {
                                objVideoCropperVC.modalPresentationStyle = .fullScreen
                            }
                            objVideoCropperVC.setVideoCropHandler = {(strUploadedFileName, message, isCancel) in
                                if !isCancel{
                                    if let videoData = MessageManager.shared.getFileDataFromDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName){
                                        
                                        let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "mp4")
                                        MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName, fileData: videoData)
                                        
                                        let mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
                                        
                                        self.saveMediaMessage(messageTypeId: MessageType.Video.rawValue, messageContent: message, messageAttachment: strUploadedFileName, mobilePrimaryKey: mobilePrimaryKey, attachmentData: videoData)
                                    }
                                }
                            }
                            MessageManager().delay(delay: 0.5, closure: {
                                self.present(objVideoCropperVC, animated: true, completion: nil)
                            })
                        }
                    }
                }
            }
        })
    }
    
    func openDocumentPicker(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPicker.allowsMultipleSelection = true
        documentPicker.delegate = self
        if #available(iOS 13.0, *) {
            documentPicker.modalPresentationStyle = .fullScreen
        }
        self.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count > 0{
            DispatchQueue.main.async {
                let pdfData = try! Data(contentsOf: urls[0])
                let fileName = "\(urls[0].lastPathComponent.replace(string: " ", withString: "_"))"
                
                let strUploadedFileName = MessageManager.shared.generateImageName(strTag: "messageAttachment", strExtention: "pdf")
                
                MessageManager.shared.saveFileToDirectory(strFolderName: "\(DirectoryFolder.ChatAttachment.rawValue)/\(self.objConversation.conversationId)", strFileName: strUploadedFileName, fileData: pdfData)
                
                let mobilePrimaryKey = MessageManager.shared.generateTempRecordName(strTag: "MESSAGE")
                
                self.saveMediaMessage(messageTypeId: MessageType.Document.rawValue, messageContent: "", messageAttachment: strUploadedFileName, mobilePrimaryKey: mobilePrimaryKey, attachmentData: pdfData)
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: 
// MARK: UIDocumentPicker Delegate Method
extension MessageVC: UIContextMenuInteractionDelegate{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let locationInTableView = interaction.view?.convert(location, to: self.tblMessage)
            
        if let locationInTableView = locationInTableView,
           let indexPath = self.tblMessage.indexPathForRow(at: locationInTableView),
           let cell = self.tblMessage.cellForRow(at: indexPath) {
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
                let replyAction = UIAction(title: "lblReply".localize, image: UIImage(named: "imgReply")) { action in
                    self.handleLongPress(indexPath: indexPath, MessageActionType: MessageAction.Reply.rawValue)
                }
                let forwardAction = UIAction(title: "lblForward".localize, image: UIImage(named: "imgForward")) { action in
                    self.handleLongPress(indexPath: indexPath, MessageActionType: MessageAction.Forward.rawValue)
                }
                let copyAction = UIAction(title: "lblCopy".localize, image: UIImage(named: "imgCopy")) { action in
                    self.handleLongPress(indexPath: indexPath, MessageActionType: MessageAction.Copy.rawValue)
                }
                let editAction = UIAction(title: "lblEdit".localize, image: UIImage(named: "imgEdit")) { action in
                    self.handleLongPress(indexPath: indexPath, MessageActionType: MessageAction.Edit.rawValue)
                }
                let deleteAction = UIAction(title: "lblDelete".localize, image: UIImage(named: "trash")) { action in
                    self.handleLongPress(indexPath: indexPath, MessageActionType: MessageAction.Delete.rawValue)
                }
                
                if cell.isKind(of: SenderTextCell.self) {
                    return UIMenu(title: "", children: [replyAction, forwardAction, copyAction, editAction, deleteAction])
                }
                else{
                    return UIMenu(title: "", children: [replyAction, forwardAction, copyAction, deleteAction])
                }
            }
            
            return configuration
        }
        else{
            return nil
        }
    }
    
    func handleLongPress(indexPath : IndexPath, MessageActionType : Int){
        
        if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderTextCell {
            if MessageActionType == MessageAction.Copy.rawValue{
                UIPasteboard.general.string = cell.lblMessage.text
            }
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverTextCell {
            if MessageActionType == MessageAction.Copy.rawValue{
                UIPasteboard.general.string = cell.lblMessage.text
            }
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderImageCell {
            print("SenderImageCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverImageCell {
            print("ReceiverImageCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderVideoCell {
            print("SenderVideoCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverVideoCell {
            print("ReceiverVideoCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderDocCell {
            print("SenderDocCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverDocCell {
            print("ReceiverDocCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? SenderAudioCell {
            print("SenderAudioCell")
        }
        else if let cell = self.tblMessage.cellForRow(at: indexPath) as? ReceiverAudioCell {
            print("ReceiverAudioCell")
        }
    }
    
}

extension UITableView {
    /// Reloads a table view without losing track of what was selected.
    func reloadDataSavingSelections() {
        let selectedRows = indexPathsForSelectedRows

        reloadData()

        if let selectedRow = selectedRows {
            for indexPath in selectedRow {
                selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
}

extension UIScrollView {
    
    var pendingContentSize: CGSize {
        var tallSize = contentSize
        tallSize.height = .greatestFiniteMagnitude
        return sizeThatFits(tallSize)
    }
    
    func scrollToBottom_New(animated: Bool) {
        contentSize = pendingContentSize
        let contentRect = CGRect(origin: .zero, size: contentSize)
        let (bottomSlice, _) = contentRect.divided(atDistance: 1, from: .maxYEdge)
        guard !bottomSlice.isEmpty else { return }
        scrollRectToVisible(bottomSlice, animated: animated)
    }
}

extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

// MARK: 
// MARK: SWIPE CELL DELEGATE METHOD
extension MessageVC : MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
        var intSection = -1
        var intRow = -1
        
        if let cell = cell as? SenderTextCell {
            intSection = cell.intSection
            intRow = cell.intRow
        }
        else if let cell = cell as? SenderImageCell {
            intSection = cell.intSection
            intRow = cell.intRow
        }
        else if let cell = cell as? SenderAudioCell {
            intSection = cell.intSection
            intRow = cell.intRow
        }
        else if let cell = cell as? SenderDocCell {
            intSection = cell.intSection
            intRow = cell.intRow
        }
        
        if intSection != -1 && intRow != -1{
            if self.arrFinalMessages[intSection].arrMessage[intRow].senderEmployeeId == Int64(MessageManager.shared.employeeId){
                return true //set true for delete message feature.
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, didChange state: MGSwipeState, gestureIsActive: Bool) {
        
    }
    
    func swipeTableCellWillEndSwiping(_ cell: MGSwipeTableCell) {
        
    }
    
    func swipeTableCellWillBeginSwiping(_ cell: MGSwipeTableCell) {
        
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        swipeSettings.transition = MGSwipeTransition.clipCenter
        expansionSettings.buttonIndex = 0
        expansionSettings.fillOnTrigger = true
        expansionSettings.triggerAnimation.easingFunction = .linear
  
        if direction == MGSwipeDirection.rightToLeft {
            expansionSettings.expansionColor = MessageTheme.Color.clear
            expansionSettings.threshold = 0.1
        
            let btnDelete = MGSwipeButton(title: "keyDelete".localize , icon: #imageLiteral(resourceName: "imgCancel") , backgroundColor: MessageTheme.Color.clear) { (cell) -> Bool in
                MessageManager().delay(delay: 0.2) {
                    var intSection = -1
                    var intRow = -1
                    
                    if let cell = cell as? SenderTextCell {
                        intSection = cell.intSection
                        intRow = cell.intRow
                    }
                    else if let cell = cell as? SenderImageCell {
                        intSection = cell.intSection
                        intRow = cell.intRow
                    }
                    else if let cell = cell as? SenderAudioCell {
                        intSection = cell.intSection
                        intRow = cell.intRow
                    }
                    else if let cell = cell as? SenderDocCell {
                        intSection = cell.intSection
                        intRow = cell.intRow
                    }
                    
                    if intSection != -1 && intRow != -1{
                        _ = BHAlertVC.init(title:"", message: "keyDeleteMessageValidation".localize, rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                            if actionType == .right {
                                
                                MessageManager.shared.call_DeleteMessagesAPI(employeeConversationId: self.arrFinalMessages[intSection].arrMessage[intRow].employeeConversationId, conversationMessageId: self.arrFinalMessages[intSection].arrMessage[intRow].conversationMessageId, showLoader: true) { success in
                                    if success{
                                        self.arrFinalMessages[intSection].arrMessage[intRow].isDeleted = true
                                        
                                        _ = tblMessages().updateDeleteFlagForMessage(isDeleted: 1, employeeConversationId: self.arrFinalMessages[intSection].arrMessage[intRow].employeeConversationId, conversationMessageId: self.arrFinalMessages[intSection].arrMessage[intRow].conversationMessageId)
                                        
                                        let indexPath = IndexPath(row: intRow, section: intSection)
                                        self.tblMessage.reloadRows(at: [indexPath], with: .none)
                                    }
                                }
                            }
                        }
                    }
                }
                return true
            }
            btnDelete.tag = 655
            btnDelete.centerIconOverText(withSpacing: 10)
            return [btnDelete]
        }
        else{
            return []
        }
    }
}

// MARK: 
// MARK: PHASSET EXTENTION METHODS
extension PHAsset {
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}

// MARK: 
// MARK: VIDEO THUMBNAIL GENERATE METHODS
extension URL {
    func generateThumbnail() -> UIImage? {
        do {
            let asset = AVURLAsset(url: self)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // Swift 5.3
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)

            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
}


// MARK: 
// MARK: PDF THUMBNAIL GENERATE & PAGE COUNT METHODS
extension MessageVC {
    func generateThumbnail(for pdfURL: URL, pageNumber: Int = 1, size: CGSize = CGSize(width: 100, height: 100), completion: @escaping (UIImage?) -> Void) {
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            print("Failed to create PDFDocument")
            completion(nil)
            return
        }
        
        guard let pdfPage = pdfDocument.page(at: pageNumber - 1) else {
            print("Invalid page number")
            completion(nil)
            return
        }
        
        let pdfPageBounds = pdfPage.bounds(for: .cropBox)
        let pdfScale = min(size.width / pdfPageBounds.width, size.height / pdfPageBounds.height)
        let scaledBounds = CGRect(x: 0, y: 0, width: pdfPageBounds.width * pdfScale, height: pdfPageBounds.height * pdfScale)
        
        let renderer = UIGraphicsImageRenderer(size: scaledBounds.size)
        let thumbnail = renderer.image { context in
            UIColor.white.set()
            context.fill(scaledBounds)
            
            context.cgContext.translateBy(x: 0, y: scaledBounds.height)
            context.cgContext.scaleBy(x: 1, y: -1)
            context.cgContext.scaleBy(x: pdfScale, y: pdfScale)
            
            pdfPage.draw(with: .cropBox, to: context.cgContext)
        }
        
        completion(thumbnail)
    }
    
    func getPageCount(from pdfData: Data) -> Int? {
        guard let pdfDocument = PDFDocument(data: pdfData) else {
            print("Failed to create PDFDocument from data")
            return nil
        }
        return pdfDocument.pageCount
    }
}

extension UITableView {
    func isLastSectionAndRowVisible() -> Bool {
        guard let lastSection = self.dataSource?.numberOfSections?(in: self), lastSection > 0 else {
            return false
        }
        
        let lastIndexPath = IndexPath(row: self.numberOfRows(inSection: lastSection - 1) - 1, section: lastSection - 1)
        
        if let visibleIndexPaths = self.indexPathsForVisibleRows {
            return visibleIndexPaths.contains(lastIndexPath)
        }
        
        return false
    }
}
