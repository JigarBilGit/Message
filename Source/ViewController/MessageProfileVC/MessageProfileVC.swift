//
//  EmployeeProfileVC.swift
//  BilliyoCommunication
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2022 Billiyo Mac. All rights reserved.
//

import UIKit
import SDWebImage
import CropViewController

enum ProfileType : String{
    case Other = "Other"
    case Group = "Group"
}

class ShareOptions : NSObject {
    var sectionTag : Int = 0
    var arrOptionItem : [String] = []
    var arrImgOptionItem : [UIImage] = []
}

class MessageProfileVC: UIViewController {
    // MARK: - 
    // MARK: - IBOUTLET VARIABLE
    @IBOutlet weak var viewMainBG: UIView!
    @IBOutlet weak var viewTopBG: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgEmployeePic: UIImageView!
    @IBOutlet weak var btnEditProfile: UIButton!
    @IBOutlet weak var lblName: BMLabel!
    @IBOutlet weak var lblDescription: BMLabel!
        
    @IBOutlet weak var viewBottomInfoBG: UIView!
    
    @IBOutlet weak var viewProfileInfo: UIView!
    @IBOutlet weak var lblProfile1: BMLabel!
    @IBOutlet weak var lblUserName: BMLabel!
    @IBOutlet weak var lblUserNameValue: BMLabel!
    @IBOutlet weak var lblEmail: BMLabel!
    @IBOutlet weak var lblEmailValue: BMLabel!
    @IBOutlet weak var lblJobTitle: BMLabel!
    @IBOutlet weak var lblJobTitleValue: BMLabel!
    @IBOutlet weak var lblContactNumber: BMLabel!
    @IBOutlet weak var lblContactNumberValue: BMLabel!
    
    @IBOutlet weak var viewOtherProfileInfo: UIView!
    @IBOutlet weak var lblProfile2: BMLabel!
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var lblFullName: BMLabel!
    @IBOutlet weak var lblFullNameValue: BMLabel!
    @IBOutlet weak var viewTelephone: UIView!
    @IBOutlet weak var lblTelephone: BMLabel!
    @IBOutlet weak var lblTelephoneValue: BMLabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblMessage: BMLabel!
    @IBOutlet weak var lblMessageValue: BMLabel!
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var viewGroupInfo: UIView!
    @IBOutlet weak var lblGroupInfo: BMLabel!
    @IBOutlet weak var lblUsers: BMLabel!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewGroupUserList: UIView!
    @IBOutlet weak var tblGroupUserList: UITableView!
    @IBOutlet weak var tblGroupUserListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewAllUserListBG: UIView!
    @IBOutlet weak var viewAllUserList: UIView!
    @IBOutlet weak var btnBackUserList: UIButton!
    @IBOutlet weak var txtSearchUserList: UISearchBar!
    @IBOutlet weak var tblAllUserList: UITableView!
    
    @IBOutlet weak var viewOptionPopupBG: UIView!
    @IBOutlet weak var btnDismissOptionPopup: UIButton!
    @IBOutlet weak var viewTopOptionPopup: UIView!
    @IBOutlet weak var imgSelectedEmployeePic: UIImageView!
    @IBOutlet weak var lblSelectedEmployeeName: BMLabel!
    @IBOutlet weak var btnDismissOptionPopup2: UIButton!
    @IBOutlet weak var viewOptionPopup: UIView!
    @IBOutlet weak var tblOptionPopup: UITableView!
    @IBOutlet weak var tblOptionPopupHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBottomOptionPopup: UIView!
    @IBOutlet weak var viewOptionPopupTop: NSLayoutConstraint!
    
    @IBOutlet weak var viewMainBGPopup: UIView!
    @IBOutlet weak var viewTopBGPopup: UIView!
    @IBOutlet weak var btnBackPopup: UIButton!
    @IBOutlet weak var imgEmployeePicPopup: UIImageView!
    @IBOutlet weak var lblNamePopup: BMLabel!
    @IBOutlet weak var lblDescriptionPopup: BMLabel!
    
    @IBOutlet weak var viewBottomInfoBGPopup: UIView!
    
    @IBOutlet weak var viewOtherProfileInfoPopup: UIView!
    @IBOutlet weak var lblProfile2Popup: BMLabel!
    @IBOutlet weak var viewFullNamePopup: UIView!
    @IBOutlet weak var lblFullNamePopup: BMLabel!
    @IBOutlet weak var lblFullNameValuePopup: BMLabel!
    @IBOutlet weak var viewTelephonePopup: UIView!
    @IBOutlet weak var lblTelephonePopup: BMLabel!
    @IBOutlet weak var lblTelephoneValuePopup: BMLabel!
    @IBOutlet weak var viewMessagePopup: UIView!
    @IBOutlet weak var lblMessagePopup: BMLabel!
    @IBOutlet weak var lblMessageValuePopup: BMLabel!
    @IBOutlet weak var btnMessagePopup: UIButton!
    
    // MARK: - 
    // MARK: - VARIABLE
    var viewSpinner:UIView?
    var employeeId : Int64 = 0
    
    var profileType : String = "Other"
    
    var objConversation = tblConversationList()
    
    var participantsCount : Int = 0
    
    var arrUserList : [ShareGroupUserList] = []
    
    var isSelfAdmin : Bool = false
    
    var setRedirectionHandler: ((_ isCancel:Bool, _ employeeConversationId:Int64, _ conversation:tblConversationList) -> Void)?
    
    var arrAllUserList = [tblUserList]()
    var arrFilteredUserList = [tblUserList]()
    
    var isSelectedEmployeeAdmin : Bool = false
    var selectedEmployeeId : Int64 = 0
    var selectedEmployeeName : String = ""
    var selectedUserTag : Int!
    var arrOptionSection : [ShareOptions] = []
    
    var selectedOtherEmployeeId : Int64 = 0
    
    // MARK: - 
    // MARK: - VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgEmployeePic.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
        self.imgEmployeePic.layer.cornerRadius = 15.0
        self.imgEmployeePic.layer.masksToBounds = true
        self.imgEmployeePic.contentMode = .scaleAspectFill
        
        self.imgEmployeePicPopup.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
        self.imgEmployeePicPopup.layer.cornerRadius = 15.0
        self.imgEmployeePicPopup.layer.masksToBounds = true
        self.imgEmployeePicPopup.contentMode = .scaleAspectFill
        
        self.tblAllUserList.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "UserListCell")
        
        self.tblOptionPopup.register(UINib(nibName: "OptionListCell", bundle: nil), forCellReuseIdentifier: "OptionListCell")
        self.tblOptionPopup.estimatedRowHeight = 60.0
        self.tblOptionPopup.rowHeight = UITableView.automaticDimension
        self.tblOptionPopup.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.tblOptionPopup.layer.cornerRadius = 10.0
        self.tblOptionPopup.layer.masksToBounds = true
        
        self.setScreenData()
        
        self.viewAllUserListBG.isHidden = true
        self.viewMainBGPopup.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.navigationController?.navigationBar.isHidden = true
        
        self.setLanguageText()
        self.setGradientBackground()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewBottomInfoBG.roundCorners([.topLeft, .topRight], radius: 30.0)
        self.viewTopOptionPopup.roundCorners([.topLeft, .topRight], radius: 30.0)
        
        self.viewBottomInfoBGPopup.roundCorners([.topLeft, .topRight], radius: 30.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewBottomInfoBG.roundCorners([.topLeft, .topRight], radius: 30.0)
        self.viewTopOptionPopup.roundCorners([.topLeft, .topRight], radius: 30.0)
        
        self.viewBottomInfoBGPopup.roundCorners([.topLeft, .topRight], radius: 30.0)
    }

    // MARK: - 
    // MARK: - CUSTOM METHODS
    func setLanguageText() -> Void {
        self.lblProfile1.text = "lblProfile".localize
        self.lblUserName.text = "lblUserName".localize
        self.lblEmail.text = "lblEmail".localize
        self.lblJobTitle.text = "lblJobTitle".localize
        self.lblContactNumber.text = "lblContactNumber".localize
        
        self.lblProfile2.text = "lblProfile".localize
        self.lblFullName.text = "lblFullName".localize
        self.lblTelephone.text = "lblTelephone".localize
        self.lblMessage.text = "lblMessage".localize
        
        self.lblFullNamePopup.text = "lblFullName".localize
        self.lblTelephonePopup.text = "lblTelephone".localize
        self.lblMessagePopup.text = "lblMessage".localize
        self.lblMessageValuePopup.text = "lblTapToMessage".localize
        
        self.lblGroupInfo.text = "lblGroupInfo".localize
        
        if self.profileType == ProfileType.Group.rawValue{
            self.lblDescription.text = "\("lblGroup".localize) - \(self.participantsCount) \("lblParticipants".localize)"
        }
        else{
            self.lblDescription.text = ""
        }
        
        self.txtSearchUserList.placeholder = "KeylblSearch".localize
    }
    
    func setGradientBackground() {
        let colorTop = MessageTheme.Color.white.cgColor
        let colorBottom = MessageTheme.Color.primaryTheme.cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer.frame = self.view.bounds
                
        self.viewTopBG.layer.insertSublayer(gradientLayer, at:0)
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.colors = [colorTop, colorBottom]
        gradientLayer2.locations = [0.0, 0.25, 0.5, 0.75, 1.0]
        gradientLayer2.frame = self.view.bounds
        self.viewTopBGPopup.layer.insertSublayer(gradientLayer2, at:0)
    }
    
    func setViewShadow(objView : UIView){
        objView.backgroundColor = MessageTheme.Color.white
        objView.layer.cornerRadius = 10.0
        objView.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.30, x: 0, y: 2, blur: 10, spread: 0)
    }
    
    func setScreenData(){
        if self.profileType == ProfileType.Other.rawValue{
            self.btnEditProfile.isHidden = true
            
            self.viewProfileInfo.isHidden = true
            self.viewOtherProfileInfo.isHidden = false
            self.viewGroupInfo.isHidden = true
            
            let arrOtherUserData = tblUserList.rowsFor(sql: "SELECT * FROM tblUserList where employeeConversationId = '\(self.objConversation.employeeConversationId)' AND employeeId != '\(Int64(MessageManager.shared.employeeId) ?? 0)'")
            if arrOtherUserData.count > 0{
                let arrEmployeeData = tblEmployees.rowsFor(sql: "SELECT * FROM tblEmployees where employeeId = '\(arrOtherUserData[0].employeeId)'")
                if arrEmployeeData.count > 0{
                    self.lblName.text = MessageManager.shared.getFullName(firstName: arrEmployeeData[0].firstName, middleName: "", lastName: arrEmployeeData[0].lastName)
                    
                    self.lblFullNameValue.text = MessageManager.shared.getFullName(firstName: arrEmployeeData[0].firstName, middleName: arrEmployeeData[0].middleName, lastName: arrEmployeeData[0].lastName)
                    self.lblTelephoneValue.text = arrEmployeeData[0].telephone
                    if arrEmployeeData[0].photo != ""{
                        self.setProfilePic(strPicName: arrEmployeeData[0].photo)
                    }
                }
                self.lblMessageValue.text = "lblTapToMessage".localize
            }
        }
        else{
            self.tblGroupUserList.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: "UserListCell")
            self.tblGroupUserList.estimatedRowHeight = 65.0
            self.tblGroupUserList.rowHeight = UITableView.automaticDimension
            self.tblGroupUserList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
            
            self.viewProfileInfo.isHidden = true
            self.viewOtherProfileInfo.isHidden = true
            self.viewGroupInfo.isHidden = false
            
            let arrAllUserData = tblUserList.rowsFor(sql: "SELECT * FROM tblUserList where employeeConversationId = '\(self.objConversation.employeeConversationId)' AND isDeleted = '\(0)'")
            let arrTopUserData = tblUserList.rowsFor(sql: "\(tblUserList().strUserListQuery()) where tu.employeeConversationId = '\(self.objConversation.employeeConversationId)' AND tu.employeeId != '\(Int64(MessageManager.shared.employeeId) ?? 0)' AND tu.isDeleted = '\(0)' ORDER BY tu.isAdmin DESC, te.firstName ASC LIMIT 5 OFFSET 0")
            let arrOtherUserData = arrAllUserData.filter({$0.employeeId != Int64(MessageManager.shared.employeeId) && !$0.isDeleted})
            let arrSelfUserData = arrAllUserData.filter({$0.employeeId == Int64(MessageManager.shared.employeeId) && !$0.isDeleted})
            if arrSelfUserData.count > 0{
                self.isSelfAdmin = arrSelfUserData[0].isAdmin
            }
            
            self.btnEditProfile.isHidden = self.isSelfAdmin ? false : true
            
            self.participantsCount = arrAllUserData.count
            self.lblName.text = self.objConversation.conversationName
            
            if self.objConversation.conversationImage != ""{
                self.setProfilePic(strPicName: self.objConversation.conversationImage)
            }
            
            self.arrUserList.removeAll()
            if self.isSelfAdmin{
                let user0 = ShareGroupUserList(userId: 0, userName: "lblAddParticipants".localize, userPhoto: "", isGroupAdmin: false, userTag: UserTypeTag.AddParticipants.rawValue, name: "")
                self.arrUserList.append(user0)
            }
            
            let user1 = ShareGroupUserList(userId: Int64(MessageManager.shared.employeeId), userName: "lblYou".localize, userPhoto: MessageManager.shared.photo, isGroupAdmin: self.isSelfAdmin ? true : false, userTag: UserTypeTag.Own.rawValue, name: MessageManager.shared.getFullName(firstName: MessageManager.shared.firstName, middleName: MessageManager.shared.middleName, lastName: MessageManager.shared.lastName))
            self.arrUserList.append(user1)
            
            for eleUserData in arrTopUserData{
                let userData = ShareGroupUserList(userId: eleUserData.employeeId, userName: MessageManager.shared.getFullName(firstName: eleUserData.firstName, middleName: "", lastName: eleUserData.lastName), userPhoto: eleUserData.profilePicture, isGroupAdmin: eleUserData.isAdmin, userTag: UserTypeTag.Other.rawValue, name: MessageManager.shared.getFullName(firstName: eleUserData.firstName, middleName: eleUserData.middleName, lastName: eleUserData.lastName))
                self.arrUserList.append(userData)
            }
            
            if arrOtherUserData.count > 5{
                let user1 = ShareGroupUserList(userId: 0, userName: "\("lblViewAll".localize) (\(arrAllUserData.count - (arrTopUserData.count + 1)) \("lblMore".localize))", userPhoto: "", isGroupAdmin: false, userTag: UserTypeTag.ViewAll.rawValue, name: "")
                self.arrUserList.append(user1)
            }
            
            let user2 = ShareGroupUserList(userId: 0, userName: MessageManager.shared.getFullName(firstName: "lblLeaveGroup".localize, middleName: "", lastName: ""), userPhoto: "", isGroupAdmin: false, userTag: UserTypeTag.LeaveGroup.rawValue)
            self.arrUserList.append(user2)
            
            self.tblGroupUserList.reloadData()
            
            self.txtSearchUserList.text = ""
            self.arrAllUserList = tblUserList.rowsFor(sql: "\(tblUserList().strUserListQuery()) where tu.employeeConversationId = '\(self.objConversation.employeeConversationId)' AND tu.employeeId != '\(Int64(MessageManager.shared.employeeId) ?? 0)' AND tu.isDeleted = '\(0)' ORDER BY tu.isAdmin DESC, te.firstName ASC")
            if arrSelfUserData.count > 0{
                self.arrAllUserList.insert(arrSelfUserData[0], at: 0)
            }
            self.arrFilteredUserList = self.arrAllUserList
        }
        
        self.viewOptionPopupBG.isHidden = true
        self.viewOptionPopup.isHidden = true
    }
    
    func setProfilePic(strPicName : String){
        if strPicName != ""{
            if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: strPicName){
                if let imgEmployeePic = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: strPicName){
                    self.imgEmployeePic.image = imgEmployeePic
                    self.imgEmployeePic.layer.cornerRadius = 15.0
                    self.imgEmployeePic.layer.masksToBounds = true
                    self.imgEmployeePic.contentMode = .scaleAspectFill
                }
            }
            else{
                BMAzure.loadDataFromAzure(clientSignature: strPicName) { success, error, data in
                    if success && data != nil {
                        MessageManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: strPicName, fileData: data!)
                        DispatchQueue.main.async {
                            self.imgEmployeePic.image = UIImage(data: data!)
                            self.imgEmployeePic.layer.cornerRadius = 15.0
                            self.imgEmployeePic.layer.masksToBounds = true
                            self.imgEmployeePic.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
        }
    }
    
    func setOtherEmployeeProfileInfo(){
        let arrEmployees = tblEmployees.rowsFor(sql: "SELECT * FROM tblEmployees where employeeId = '\(self.selectedOtherEmployeeId)'")
        if arrEmployees.count > 0{
            self.lblFullNameValuePopup.text = MessageManager.shared.getFullName(firstName: arrEmployees[0].firstName, middleName: arrEmployees[0].middleName, lastName: arrEmployees[0].lastName)
            self.lblTelephoneValuePopup.text = arrEmployees[0].telephone
            
            if arrEmployees[0].photo != ""{
                if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: arrEmployees[0].photo){
                    if let imgEmployeePic = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: arrEmployees[0].photo){
                        self.imgEmployeePicPopup.image = imgEmployeePic
                        self.imgEmployeePicPopup.layer.cornerRadius = 15.0
                        self.imgEmployeePicPopup.layer.masksToBounds = true
                        self.imgEmployeePicPopup.contentMode = .scaleAspectFill
                    }
                }
                else{
                    BMAzure.loadDataFromAzure(clientSignature: arrEmployees[0].photo) { success, error, data in
                        if success && data != nil {
                            MessageManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: arrEmployees[0].photo, fileData: data!)
                            DispatchQueue.main.async {
                                self.imgEmployeePicPopup.image = UIImage(data: data!)
                                self.imgEmployeePicPopup.layer.cornerRadius = 15.0
                                self.imgEmployeePicPopup.layer.masksToBounds = true
                                self.imgEmployeePicPopup.contentMode = .scaleAspectFill
                            }
                        }
                    }
                }
            }
        }
        self.lblNamePopup.text = self.selectedEmployeeName
        self.lblDescriptionPopup.text = ""

        self.viewMessagePopup.isHidden = self.profileType == ProfileType.Group.rawValue ? false : true
    }
    
    // MARK: - 
    // MARK: - BUTTON ACTION METHODS
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popWithAnimation()
    }
    
    @IBAction func btnEditProfileClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let objEditGroupInfoPopupVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "EditGroupInfoPopupVC") as! EditGroupInfoPopupVC
        objEditGroupInfoPopupVC.employeeConversationId = self.objConversation.employeeConversationId
        objEditGroupInfoPopupVC.strGroupName = self.objConversation.conversationName
        objEditGroupInfoPopupVC.strGroupImageName = self.objConversation.conversationImage
        objEditGroupInfoPopupVC.modalPresentationStyle = .overCurrentContext
        objEditGroupInfoPopupVC.setGroupInfoConfirmHandler = {(strGroupName, strGroupImage, isConfirm) in
            if isConfirm{
                self.lblName.text = strGroupName
                self.objConversation.conversationName = strGroupName
                
                self.objConversation.conversationImage = strGroupImage
                if self.objConversation.conversationImage != ""{
                    self.setProfilePic(strPicName: self.objConversation.conversationImage)
                }
            }
        }
        self.navigationController?.present(objEditGroupInfoPopupVC, animated: false, completion: nil)
    }
    
    @IBAction func btnSearchClick(_ sender: Any) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 1.0, animations: {
            self.viewAllUserListBG.isHidden = false
            self.tblAllUserList.reloadData()
        })
    }
    
    @IBAction func btnBackUserListClick(_ sender: Any) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: {
            self.viewAllUserListBG.isHidden = true
        })
    }
    
    @IBAction func btnDismissOptionPopupClick(_ sender: Any) {
        self.view.endEditing(true)
        self.dismissOptionView()
    }
    
    func dismissOptionView(){
        self.view.endEditing(true)

        self.viewOptionPopupTop.constant = 0.0
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (completed) -> Void in
            self.viewOptionPopupBG.isHidden = true
            
            self.isSelectedEmployeeAdmin = false
            self.selectedEmployeeId = 0
            self.selectedEmployeeName = ""
            self.lblSelectedEmployeeName.text = ""
            self.selectedUserTag = UserTypeTag.None.rawValue
        }
    }
    
    @IBAction func btnBackPopupClick(_ sender: Any) {
        self.view.endEditing(true)
        
        self.selectedOtherEmployeeId = 0
        
        self.viewMainBGPopup.isHidden = true
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (completed) -> Void in
            self.lblNamePopup.text = ""
            self.lblFullNameValuePopup.text = ""
            self.lblTelephoneValuePopup.text = ""
        }
    }
    
    // MARK: - 
    // MARK: - SHOW HIDE Loader METHODS
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
    // MARK: - API CALLER METHODS
    func call_UploadEmployeeProfilePicAPI(strImageName : String, image : UIImage) {
        var paramer: [String: Any] = [:]
        paramer["profilePicture"] = strImageName
        
//        Webservice.call.POST(objVC: self, filePath: APIConstant.Request.upload_Employee_profile_picture, params: paramer, enableInteraction: false, showLoader: true, viewObj: self.view, onSuccess: { (result, success) in
//            if let _ = result as? [String : Any] {
//                DispatchQueue.main.async {
//                    self.imgEmployeePic.image = image
//                    self.imgEmployeePic.layer.cornerRadius = self.imgEmployeePic.frame.height / 2.0
//                    self.imgEmployeePic.layer.masksToBounds = true
//                    self.imgEmployeePic.contentMode = .scaleAspectFill
//
//                    AJAlertController.initialization().showAlertWithOkButton(vc: self, aStrTitle: "KeylblSuccess".localize, aStrMessage: "Profile picture uploaded successfully.") { (index, title) in
//                        if index == 0{
//                            
//                        }
//                    }
//                }
//            }
//        }) {
//            Log.console("Error \(self.description)")
//        } onMasterkeyError: {success in
//            if success{
//                DispatchQueue.main.async {
//                    self.call_UploadEmployeeProfilePicAPI(strImageName: strImageName, image: image)
//                }
//            }
//        }
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
// MARK: - UITABLEVIEW DELEGATE METHODS
extension MessageProfileVC : UITableViewDelegate,UITableViewDataSource {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableview = object as? UITableView {
            tableview.layer.removeAllAnimations()
            if tableview == self.tblGroupUserList {
                self.tblGroupUserListHeight.constant = self.tblGroupUserList.contentSize.height
            }
            else if tableview == self.tblOptionPopup {
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.0
        }
        else{
            return 4.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tblOptionPopup{
            return UITableView.automaticDimension
        }
        else{
            return MessageConstant.is_Device._iPhone ? 60.0 : 75.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblAllUserList{
            return self.arrFilteredUserList.count
        }
        else if tableView == self.tblOptionPopup{
            return self.arrOptionSection[section].arrOptionItem.count
        }
        else{
            return self.arrUserList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblAllUserList{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
            
            cell.imgProfilePic.isHidden = false
            cell.imgProfilePic.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
            if self.arrFilteredUserList[indexPath.row].employeeId == Int64(MessageManager.shared.employeeId){
                cell.lblUserName.text = "lblYou".localize
            }
            else{
                cell.lblUserName.text = MessageManager.shared.getFullName(firstName: self.arrFilteredUserList[indexPath.row].firstName, middleName: self.arrFilteredUserList[indexPath.row].middleName, lastName: self.arrFilteredUserList[indexPath.row].lastName)
            }
            cell.lblIsAdmin.text = "lblGroupAdmin".localize
            cell.viewIsAdmin.isHidden = self.arrFilteredUserList[indexPath.row].isAdmin ? false : true
            
            cell.selectionStyle = .none
            return cell
        }
        else if tableView == self.tblOptionPopup{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionListCell", for: indexPath) as! OptionListCell
    
            cell.lblOption.text = self.arrOptionSection[indexPath.section].arrOptionItem[indexPath.row]
            cell.imgOption.image = self.arrOptionSection[indexPath.section].arrImgOptionItem[indexPath.row]
            
            cell.lblSeprator.isHidden = indexPath.row == self.arrOptionSection[indexPath.section].arrOptionItem.count - 1 ? true : false
            cell.lblOption.textColor = self.arrOptionSection[indexPath.section].sectionTag == 1 ? MessageTheme.Color.defaultRed : MessageTheme.Color.black
            
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
            
            cell.imgProfilePic.isHidden = false
            if self.arrUserList[indexPath.row].userTag == UserTypeTag.AddParticipants.rawValue{
                cell.imgProfilePic.image = #imageLiteral(resourceName: "imgAddParticipants2")
                cell.imgProfilePic.layer.cornerRadius = 5.0
                cell.lblUserName.textColor = MessageTheme.Color.black
            }
            else if self.arrUserList[indexPath.row].userTag == UserTypeTag.Own.rawValue || self.arrUserList[indexPath.row].userTag == UserTypeTag.Other.rawValue {
                cell.imgProfilePic.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
                cell.imgProfilePic.layer.cornerRadius = 5.0
                cell.imgProfilePic.layer.masksToBounds = true
                cell.imgProfilePic.contentMode = .scaleAspectFill
                
                if self.arrUserList[indexPath.row].userPhoto != ""{
                    if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.arrUserList[indexPath.row].userPhoto){
                        let image = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.arrUserList[indexPath.row].userPhoto)
                        if image != nil{
                            cell.imgProfilePic.image = image
                            cell.imgProfilePic.layer.cornerRadius = 5.0
                            cell.imgProfilePic.layer.masksToBounds = true
                            cell.imgProfilePic.contentMode = .scaleAspectFill
                        }
                    }
                    else if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ProfilePicture.rawValue, strFileName: self.arrUserList[indexPath.row].userPhoto){
                        let image = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ProfilePicture.rawValue, strFileName: self.arrUserList[indexPath.row].userPhoto)
                        if image != nil{
                            cell.imgProfilePic.image = image
                            cell.imgProfilePic.layer.cornerRadius = 5.0
                            cell.imgProfilePic.layer.masksToBounds = true
                            cell.imgProfilePic.contentMode = .scaleAspectFill
                        }
                    }
                }
                cell.lblUserName.textColor = MessageTheme.Color.black
            }
            else if self.arrUserList[indexPath.row].userTag == UserTypeTag.ViewAll.rawValue{
                cell.imgProfilePic.isHidden = true
                cell.lblUserName.textColor = MessageTheme.Color.primaryTheme
            }
            else{
                cell.imgProfilePic.image = #imageLiteral(resourceName: "imgLeave")
                cell.lblUserName.textColor = MessageTheme.Color.defaultRed
            }
        
            cell.lblUserName.text = self.arrUserList[indexPath.row].userName
            
            cell.lblIsAdmin.text = "lblGroupAdmin".localize
            cell.viewIsAdmin.isHidden = self.arrUserList[indexPath.row].isGroupAdmin ? false : true
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if tableView == self.tblAllUserList{
            self.arrOptionSection.removeAll()
            
            if self.arrFilteredUserList[indexPath.row].employeeId == Int64(MessageManager.shared.employeeId){
                if self.isSelfAdmin{
                    self.isSelectedEmployeeAdmin = self.arrFilteredUserList[indexPath.row].isAdmin
                    self.selectedEmployeeId = self.arrFilteredUserList[indexPath.row].employeeId
                    self.selectedEmployeeName = MessageManager.shared.getFullName(firstName: self.arrFilteredUserList[indexPath.row].firstName, middleName: "", lastName: self.arrFilteredUserList[indexPath.row].lastName)
                    self.lblSelectedEmployeeName.text = self.selectedEmployeeName
                    
                    self.selectedUserTag = UserTypeTag.Own.rawValue
                    
                    let section0 = ShareOptions()
                    section0.arrOptionItem = ["\("lblResignAsAdmin".localize)"]
                    section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgDismissAdmin")]
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
            }
            else {
                let strName = MessageManager.shared.getFullName(firstName: self.arrFilteredUserList[indexPath.row].firstName, middleName: "", lastName: self.arrFilteredUserList[indexPath.row].lastName)
                if self.isSelfAdmin {
                    if  self.arrFilteredUserList[indexPath.row].isAdmin{
                        let section0 = ShareOptions()
                        section0.arrOptionItem = ["\("lblMessage".localize) \(strName)", "\("lblView".localize) \(strName)"]
                        section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgToMessage"), #imageLiteral(resourceName: "imgViewAccountInfo")]
                        section0.sectionTag = 0
                        self.arrOptionSection.append(section0)
                        
                        let section1 = ShareOptions()
                        section1.arrOptionItem = ["lblDismissAsAdmin".localize, "\("lblRemove".localize) \(strName)"]
                        section1.arrImgOptionItem = [#imageLiteral(resourceName: "imgDismissAdmin"), #imageLiteral(resourceName: "imgLeftGroup")]
                        section1.sectionTag = 1
                        self.arrOptionSection.append(section1)
                    }
                    else{
                        let section0 = ShareOptions()
                        section0.arrOptionItem = ["\("lblMessage".localize) \(strName)", "\("lblView".localize) \(strName)", "lblMakeGroupAdmin".localize]
                        section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgToMessage"), #imageLiteral(resourceName: "imgViewAccountInfo"), #imageLiteral(resourceName: "imgMakeAdmin")]
                        section0.sectionTag = 0
                        self.arrOptionSection.append(section0)
                        
                        let section1 = ShareOptions()
                        section1.arrOptionItem = ["\("lblRemove".localize) \(strName)"]
                        section1.arrImgOptionItem = [#imageLiteral(resourceName: "imgLeftGroup")]
                        section1.sectionTag = 1
                        self.arrOptionSection.append(section1)
                    }
                }
                else{
                    let section0 = ShareOptions()
                    section0.arrOptionItem = ["\("lblMessage".localize) \(strName)", "\("lblView".localize) \(strName)"]
                    section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgToMessage"), #imageLiteral(resourceName: "imgViewAccountInfo")]
                    section0.sectionTag = 0
                    self.arrOptionSection.append(section0)
                }
            
                self.isSelectedEmployeeAdmin = self.arrFilteredUserList[indexPath.row].isAdmin
                self.selectedEmployeeId = self.arrFilteredUserList[indexPath.row].employeeId
                self.selectedEmployeeName = MessageManager.shared.getFullName(firstName: self.arrFilteredUserList[indexPath.row].firstName, middleName: "", lastName: self.arrFilteredUserList[indexPath.row].lastName)
                self.lblSelectedEmployeeName.text = self.selectedEmployeeName
                
                self.selectedUserTag = UserTypeTag.Other.rawValue
                
                self.viewOptionPopup.isHidden = false
                self.viewOptionPopupBG.isHidden = false
                self.tblOptionPopup.reloadData()
                
                self.viewOptionPopupTop.constant = -(self.viewTopOptionPopup.frame.height + self.tblOptionPopupHeight.constant + self.viewBottomOptionPopup.frame.height)
                UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }) { (completed) -> Void in
                    
                }
            }
        }
        else if tableView == self.tblGroupUserList{
            if self.arrUserList[indexPath.row].userTag == UserTypeTag.AddParticipants.rawValue{
                let arrEmployees = tblEmployees.rowsFor(sql: "SELECT * FROM tblEmployees where employeeId != '\(Int64(MessageManager.shared.employeeId) ?? 0)'")
                if arrEmployees.count > 0{
                    let employeeListPickerAppearance = EmployeeListPopupAppearanceManager.init(
                        pickerTitle         : "lblSelectEmployeeForChat".localize,
                        titleFont           : UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_17 : MessageTheme.Size.Size_25),
                        titleTextColor      : MessageTheme.Color.black,
                        titleBackground     : MessageTheme.Color.clear,
                        searchBarFont       : UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_20),
                        searchBarPlaceholder: "keySearch".localize,
                        closeButtonTitle    : "keyCancelUpperCase".localize,
                        closeButtonColor    : MessageTheme.Color.buttonRed,
                        closeButtonFont     : UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_17 : MessageTheme.Size.Size_25),
                        doneButtonTitle     : "keyOKUpperCase".localize,
                        doneButtonColor     : MessageTheme.Color.buttonBlue,
                        doneButtonFont      : UIFont(name: MessageTheme.Font.avenirHeavy, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_17 : MessageTheme.Size.Size_25),
                        checkMarkPosition   : .Left,
                        itemCheckedImage    : #imageLiteral(resourceName: "imgCheckboxSelected"),
                        itemUncheckedImage  : #imageLiteral(resourceName: "imgCheckbox"),
                        itemColor           : MessageTheme.Color.black,
                        itemFont            : UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_18)
                    )
                    
                    let employeeListPicker = EmployeeListPopupVC(with: arrEmployees, appearance: employeeListPickerAppearance) { selectedEmployee in
                        if selectedEmployee.count > 0{
                            if MessageManager.shared.isNetConnected{
                                let arrEmployeeIds = selectedEmployee.compactMap({Int64($0.employeeId)})
                                MessageManager.shared.call_ConversationAddEmployeeAPI(employeeConversationId: self.objConversation.employeeConversationId, employeeIds: arrEmployeeIds, showLoader: true) { isSuccess in
                                    MessageManager.shared.call_ConversationListAPI(showLoader: true) { isSuccess in
                                        self.setScreenData()
                                    }
                                }
                            }
                        }
                    } onCancel: {
        //                print("NotWorking Popup Cancelled")
                    }
                    employeeListPicker.isFromMessage = true
                    employeeListPicker.selectedClients = []
                    employeeListPicker.allowMultipleSelection = true
                    employeeListPicker.show(withAnimation: .Fade)
                }
            }
            else if self.arrUserList[indexPath.row].userTag == UserTypeTag.ViewAll.rawValue{
                UIView.animate(withDuration: 1.0, animations: {
                    self.viewAllUserListBG.isHidden = false
                    self.tblAllUserList.reloadData()
                })
            }
            else if self.arrUserList[indexPath.row].userTag == UserTypeTag.LeaveGroup.rawValue{
                DispatchQueue.main.async {
                    _ = BMAlertVC.init(title:  "keyAlert".localize, message: "lblLeaveChatValidation".localize, rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                        if actionType == .right {
                            if MessageManager.shared.isNetConnected{
                                MessageManager.shared.call_LeaveConvesationAPI(employeeConversationId: self.objConversation.employeeConversationId, showLoader: true) { isSuccess in
                                    if isSuccess{
                                        _ = tblConversationList().deleteConversation(employeeConversationId: self.objConversation.employeeConversationId)
                                        _ = tblMessages().deleteMessage(employeeConversationId: self.objConversation.employeeConversationId)

                                        DispatchQueue.main.async {
                                            self.navigationController?.popToRootWithAnimation()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if self.arrUserList[indexPath.row].userTag == UserTypeTag.Own.rawValue{
                self.arrOptionSection.removeAll()
                
                if self.isSelfAdmin{
                    self.isSelectedEmployeeAdmin = self.arrUserList[indexPath.row].isGroupAdmin
                    self.selectedEmployeeId = self.arrUserList[indexPath.row].userId
                    self.selectedEmployeeName = self.arrUserList[indexPath.row].userName
                    self.lblSelectedEmployeeName.text = self.selectedEmployeeName == "lblYou".localize ? MessageManager.shared.getFullName(firstName: MessageManager.shared.firstName, middleName: MessageManager.shared.middleName, lastName: MessageManager.shared.lastName) : self.selectedEmployeeName
                    
                    self.selectedUserTag = UserTypeTag.Own.rawValue
                    
                    let section0 = ShareOptions()
                    section0.arrOptionItem = ["\("lblResignAsAdmin".localize)"]
                    section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgDismissAdmin")]
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
            }
            else if self.arrUserList[indexPath.row].userTag == UserTypeTag.Other.rawValue{
                self.arrOptionSection.removeAll()
                
                let strName = self.arrUserList[indexPath.row].name ?? ""
                if self.isSelfAdmin {
                    if self.arrUserList[indexPath.row].isGroupAdmin{
                        let section0 = ShareOptions()
                        section0.arrOptionItem = ["\("lblMessage".localize) \(strName)", "\("lblView".localize) \(strName)"]
                        section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgToMessage"), #imageLiteral(resourceName: "imgViewAccountInfo")]
                        section0.sectionTag = 0
                        self.arrOptionSection.append(section0)
                        
                        let section1 = ShareOptions()
                        section1.arrOptionItem = ["lblDismissAsAdmin".localize, "\("lblRemove".localize) \(strName)"]
                        section1.arrImgOptionItem = [#imageLiteral(resourceName: "imgDismissAdmin"), #imageLiteral(resourceName: "imgLeftGroup")]
                        section1.sectionTag = 1
                        self.arrOptionSection.append(section1)
                    }
                    else{
                        let section0 = ShareOptions()
                        section0.arrOptionItem = ["\("lblMessage".localize) \(strName)", "\("lblView".localize) \(strName)", "lblMakeGroupAdmin".localize]
                        section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgToMessage"), #imageLiteral(resourceName: "imgViewAccountInfo"), #imageLiteral(resourceName: "imgMakeAdmin")]
                        section0.sectionTag = 0
                        self.arrOptionSection.append(section0)
                        
                        let section1 = ShareOptions()
                        section1.arrOptionItem = ["\("lblRemove".localize) \(strName)"]
                        section1.arrImgOptionItem = [#imageLiteral(resourceName: "imgLeftGroup")]
                        section1.sectionTag = 1
                        self.arrOptionSection.append(section1)
                    }
                }
                else{
                    let section0 = ShareOptions()
                    section0.arrOptionItem = ["\("lblMessage".localize) \(strName)", "\("lblView".localize) \(strName)"]
                    section0.arrImgOptionItem = [#imageLiteral(resourceName: "imgToMessage"), #imageLiteral(resourceName: "imgViewAccountInfo")]
                    section0.sectionTag = 0
                    self.arrOptionSection.append(section0)
                }
                
                self.isSelectedEmployeeAdmin = self.arrUserList[indexPath.row].isGroupAdmin
                self.selectedEmployeeId = self.arrUserList[indexPath.row].userId
                self.selectedEmployeeName = self.arrUserList[indexPath.row].userName
                self.lblSelectedEmployeeName.text = self.selectedEmployeeName
                
                self.selectedUserTag = UserTypeTag.Other.rawValue
                
                self.viewOptionPopup.isHidden = false
                self.viewOptionPopupBG.isHidden = false
                self.tblOptionPopup.reloadData()
                
                self.viewOptionPopupTop.constant = -(self.viewTopOptionPopup.frame.height + self.tblOptionPopupHeight.constant + self.viewBottomOptionPopup.frame.height)
                UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                }) { (completed) -> Void in

                }
            }
        }
        else{
            if self.selectedUserTag == UserTypeTag.Own.rawValue{
                if self.isSelfAdmin{
                    DispatchQueue.main.async {
                        _ = BMAlertVC.init(title: "keyAlert".localize, message: "\("lblResignAsAdmin".localize)?", rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                            if actionType == .right {
                                self.dismissOptionView()
                                if MessageManager.shared.isNetConnected{
                                    MessageManager.shared.call_RemoveAdminAPI(employeeConversationId: self.objConversation.employeeConversationId, employeeId: self.selectedEmployeeId, showLoader: true) { isSuccess in
                                        if isSuccess{
                                            _ = tblUserList().setAdminState(isAdmin: 0, employeeId: self.selectedEmployeeId, employeeConversationId: self.objConversation.employeeConversationId)

                                            self.setScreenData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if self.selectedUserTag == UserTypeTag.Other.rawValue{
                if indexPath.row == 0{
                    if indexPath.section == 0{
                        let arrConversationList = tblConversationList.rowsFor(sql: "SELECT * FROM tblUserList as tu INNER JOIN tblConversationList as tc ON tu.employeeConversationId = tc.employeeConversationId WHERE tc.isGroup = 0 AND tu.employeeId = '\(self.selectedEmployeeId)'")
                        if arrConversationList.count > 0{
                            self.dismissOptionView()
                            self.setRedirectionHandler?(false, arrConversationList[0].employeeConversationId, arrConversationList[0])
                            self.navigationController?.popWithAnimation()
                        }
                        else{
                            self.dismissOptionView()
                            if MessageManager.shared.isNetConnected{
                                MessageManager.shared.call_CreateConvesationAPI(employeeIds: [self.selectedEmployeeId], groupName: "", groupImage: "", isGroup: false, showLoader: true) { (isSuccess, employeeConversationId)  in
                                    if isSuccess{
                                        let arrConversationData = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' AND employeeConversationId = '\(employeeConversationId)'")
                                        if arrConversationData.count > 0{
                                            self.setRedirectionHandler?(false, arrConversationData[0].employeeConversationId, arrConversationData[0])
                                            self.navigationController?.popWithAnimation()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else{
                        if self.isSelectedEmployeeAdmin{
                            DispatchQueue.main.async {
                                _ = BMAlertVC.init(title: "keyAlert".localize, message: "\("lblDismiss".localize) \(self.selectedEmployeeName) \("lblAsGroupAdmin".localize)", rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                                    if actionType == .right {
                                        self.dismissOptionView()
                                        if MessageManager.shared.isNetConnected{
                                            MessageManager.shared.call_RemoveAdminAPI(employeeConversationId: self.objConversation.employeeConversationId, employeeId: self.selectedEmployeeId, showLoader: true) { isSuccess in
                                                if isSuccess{
                                                    _ = tblUserList().setAdminState(isAdmin: 0, employeeId: self.selectedEmployeeId, employeeConversationId: self.objConversation.employeeConversationId)

                                                    self.setScreenData()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                _ = BMAlertVC.init(title: "keyAlert".localize, message: "\("lblRemove".localize) \(self.selectedEmployeeName) \("lblFrom".localize) \(self.objConversation.conversationName) \("lblGroup2".localize)", rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                                    if actionType == .right {
                                        self.dismissOptionView()
                                        if MessageManager.shared.isNetConnected{
                                            MessageManager.shared.call_ConversationRemoveEmployeeAPI(employeeConversationId: self.objConversation.employeeConversationId, employeeIds: [self.selectedEmployeeId], showLoader: true) { isSuccess in
                                                if isSuccess{
                                                    _ = tblUserList().setDeletedState(isDeleted: 1, employeeId: self.selectedEmployeeId, employeeConversationId: self.objConversation.employeeConversationId)

                                                    self.setScreenData()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if indexPath.row == 1{
                    if indexPath.section == 0{
                        self.viewOptionPopupBG.isHidden = true
                        
                        self.selectedOtherEmployeeId = self.selectedEmployeeId
                        
                        self.setOtherEmployeeProfileInfo()
                        self.dismissOptionView()
                        self.viewMainBGPopup.isHidden = false
                        
                        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
                            self.view.layoutIfNeeded()
                        }) { (completed) -> Void in
                            
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            _ = BMAlertVC.init(title: "keyAlert".localize, message: "\("lblRemove".localize) \(self.selectedEmployeeName) \("lblFrom".localize) \(self.objConversation.conversationName) \("lblGroup2".localize)", rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                                if actionType == .right {
                                    self.dismissOptionView()
                                    if MessageManager.shared.isNetConnected{
                                        MessageManager.shared.call_ConversationRemoveEmployeeAPI(employeeConversationId: self.objConversation.employeeConversationId, employeeIds: [self.selectedEmployeeId], showLoader: true) { isSuccess in
                                            if isSuccess{

                                                _ = tblUserList().setDeletedState(isDeleted: 1, employeeId: self.selectedEmployeeId, employeeConversationId: self.objConversation.employeeConversationId)

                                                self.setScreenData()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if indexPath.row == 2{
                    DispatchQueue.main.async {
                        _ = BMAlertVC.init(title: "keyAlert".localize, message: "\("lblMake".localize) \(self.selectedEmployeeName) \("lblGroupAdmin".localize)", rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "keyCancelUpperCase".localize) { success, actionType in
                            if actionType == .right {
                                self.dismissOptionView()
                                if MessageManager.shared.isNetConnected{
                                    MessageManager.shared.call_MakeAdminAPI(employeeConversationId: self.objConversation.employeeConversationId, employeeId: self.selectedEmployeeId, showLoader: true) { isSuccess in
                                        if isSuccess{
                                            _ = tblUserList().setAdminState(isAdmin: 1, employeeId: self.selectedEmployeeId, employeeConversationId: self.objConversation.employeeConversationId)

                                            self.setScreenData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 
    // MARK: OTHER PROFILE BUTTON  METHODS
    @IBAction func btnMessageClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popWithAnimation()
    }
    
    @IBAction func btnMessagePopupClick(_ sender: Any) {
        self.view.endEditing(true)
        let arrConversationList = tblConversationList.rowsFor(sql: "SELECT * FROM tblUserList as tu INNER JOIN tblConversationList as tc ON tu.employeeConversationId = tc.employeeConversationId WHERE tc.isGroup = 0 AND tu.employeeId = '\(self.selectedOtherEmployeeId)'")
        if arrConversationList.count > 0{
            self.dismissOptionView()
            self.setRedirectionHandler?(false, arrConversationList[0].employeeConversationId, arrConversationList[0])
            self.navigationController?.popWithAnimation()
        }
        else{
            self.dismissOptionView()
            if MessageManager.shared.isNetConnected{
                MessageManager.shared.call_CreateConvesationAPI(employeeIds: [self.selectedEmployeeId], groupName: "", groupImage: "", isGroup: false, showLoader: true) { (isSuccess, employeeConversationId)  in
                    if isSuccess{
                        let arrConversationData = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' AND employeeConversationId = '\(employeeConversationId)'")
                        if arrConversationData.count > 0{
                            self.setRedirectionHandler?(false, arrConversationData[0].employeeConversationId, arrConversationData[0])
                            self.navigationController?.popWithAnimation()
                        }
                    }
                }
            }
        }
    }
}

// MARK: 
// MARK: CROPVIEWCONTROLLER DELEGATE METHODS
extension MessageProfileVC : CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: {
            let strProfilePicName = MessageManager.shared.generateImageName(strTag: "Employee", strExtention: "jpg")
            if MessageManager.shared.isNetConnected{
                self.showLoader()
                BMAzure.uploadImageToAzure(strImageName: strProfilePicName, imgSignature: image) { (success, error) in
                    self.hideLoader()
                    if success {
                        MessageManager().delay(delay: 0.2) {
                            DispatchQueue.main.async {
                                self.call_UploadEmployeeProfilePicAPI(strImageName: strProfilePicName, image: image)
                            }
                        }
                    }
                }
            }
            else{
                self.imgEmployeePic.image = image
                self.imgEmployeePic.layer.cornerRadius = self.imgEmployeePic.height / 2.0
                self.imgEmployeePic.layer.masksToBounds = true
                self.imgEmployeePic.contentMode = .scaleAspectFill

                _ = BMAlertVC.init(title:"keySuccess".localize, message: "Profile picture uploaded successfully.", rightButtonTitle: "keyOKUpperCase".localize, leftButtonTitle: "") { success, actionType in
                    if actionType == .right {
                        let uploadImageData = tblSyncImage()
                        uploadImageData.primaryId = "\(self.employeeId)"
                        uploadImageData.secondaryId = "\(self.employeeId)"
                        uploadImageData.imageName = strProfilePicName
                        uploadImageData.imageType = SyncImageType.employeeProfilePic.rawValue
                        uploadImageData.isSync = 0
                        
                        let _ = uploadImageData.save()
                    }
                }
            }
        })
    }
}

// MARK: UISearch Bar Methods
// MARK:
extension MessageProfileVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.arrFilteredUserList = self.arrAllUserList
        }else{
            self.arrFilteredUserList = self.arrAllUserList.filter({(MessageManager.shared.getFullName(firstName: $0.firstName, middleName: $0.middleName, lastName: $0.lastName)).lowercased().contains(searchText.lowercased())})
        }
        self.tblAllUserList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
