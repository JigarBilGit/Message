//
//  MoreOptionVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import Alamofire

class MessageListVC: UIViewController {

    // MARK: - 
    // MARK: IBOUTLET VARIABLE
    @IBOutlet weak var viewTopHeader: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var viewConversationBG: UIView!
    @IBOutlet weak var txtSearchConversationList: UISearchBar!
    @IBOutlet weak var tblConversation: UITableView!
    @IBOutlet weak var imgNoRecords: UIImageView!
    
    // MARK: - 
    // MARK: VARIABLE
    var arrConversationList : [tblConversationList] = []
    var arrFilteredConversationList = [tblConversationList]()
    
    //var arrEmployee : [tblClientProfile] = []
    
    // MARK: - 
    // MARK: VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblConversation.register(UINib(nibName: "ConversationListCell", bundle: nil), forCellReuseIdentifier: "ConversationListCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        self.viewTopHeader.backgroundColor = MessageTheme.Color.primaryTheme
        self.viewTopHeader.setNavigationViewCorner()
        
        self.setLanguageText()
        
        self.txtSearchConversationList.text = ""
        
        self.arrConversationList.removeAll()
        self.arrFilteredConversationList.removeAll()
        
        self.tblConversation.reloadData()
        self.imgNoRecords.isHidden = true
        
        if MessageManager.shared.isNetConnected{
            MessageManager.shared.call_ConversationListAPI(showLoader: true) { success in
                self.reloadConversationList()
            }
        }
        else{
            self.reloadConversationList()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.viewTopHeader.roundCorners([.bottomLeft, .bottomRight], radius: 30.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        self.lblTitle.text = "KeylblMessage".localize
        self.txtSearchConversationList.placeholder = "KeylblSearch".localize
    }

    func reloadConversationList(){
        self.arrConversationList = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' ORDER By messageDateTime DESC")
        self.arrFilteredConversationList = self.arrConversationList
        if self.arrFilteredConversationList.count == 0{
            self.imgNoRecords.isHidden = false
        }
        else{
            self.imgNoRecords.isHidden = true
        }
        
        self.tblConversation.reloadData()
    }
    
    // MARK: - 
    // MARK: - BUTTON ACTION METHODS
    @IBAction func btnBackClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popWithAnimation()
    }
    
    @IBAction func btnAddClick(_ sender : UIButton){
        self.view.endEditing(true)
        let width = MessageConstant.is_Device._iPhone ? 60.0 : 75.0
        
        let objPopOverOptionVC = BMPopOverImageOptionsVC()
        objPopOverOptionVC.arrImgOptions = [#imageLiteral(resourceName: "imgGroupChat"), #imageLiteral(resourceName: "imgChat")]
        objPopOverOptionVC.size = CGSize(width: width, height: 2 * width + 20)
        objPopOverOptionVC.showPopover(sourceView: sender, shouldDismissOnTap: true)
        objPopOverOptionVC.OnCmpletionHandler = { (cancel, index) in
            let arrEmployees = tblEmployees.rowsFor(sql: "SELECT * FROM tblEmployees where employeeId != '\(Int64(MessageManager.shared.employeeId) ?? 0)'")
            if index == 0 {
                DispatchQueue.main.async {
                    let objCreateGroupVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
                    objCreateGroupVC.modalPresentationStyle = .overCurrentContext
                    objCreateGroupVC.arrClient = arrEmployees
                    objCreateGroupVC.setCreateGroupHandler = {(strGroupName, strGroupImageName, employeeIds, isCancel) in
                        if !isCancel{
                            MessageManager.shared.call_CreateConvesationAPI(employeeIds: employeeIds, groupName: strGroupName, groupImage: strGroupImageName, isGroup: true, showLoader: true) { (isSuccess, employeeConversationId)  in
                                if isSuccess{
                                    let arrConversationData = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' AND employeeConversationId = '\(employeeConversationId)'")
                                    if arrConversationData.count > 0{
                                        let objMessageVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                                        objMessageVC.objConversation = arrConversationData[0]
                                        self.navigationController?.pushWithAnimation(viewController: objMessageVC)
                                    }
                                }
                            }
                        }
                    }
                    self.navigationController?.present(objCreateGroupVC, animated: false, completion: nil)
                }
            }
            else{
                DispatchQueue.main.async {
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
                            itemCheckedImage    : #imageLiteral(resourceName: "radioSelected"),
                            itemUncheckedImage  : #imageLiteral(resourceName: "radioUnselected"),
                            itemColor           : MessageTheme.Color.black,
                            itemFont            : UIFont(name: MessageTheme.Font.avenirMedium, size: MessageConstant.is_Device._iPhone ? MessageTheme.Size.Size_14 : MessageTheme.Size.Size_18)
                        )
                        
                        let employeeListPicker = EmployeeListPopupVC(with: arrEmployees, appearance: employeeListPickerAppearance) { selectedEmployee in
                            if selectedEmployee.count > 0{
                                let arrConversationList = tblConversationList.rowsFor(sql: "SELECT * FROM tblUserList as tu INNER JOIN tblConversationList as tc ON tu.employeeConversationId = tc.employeeConversationId WHERE tc.isGroup = 0 AND tu.employeeId = '\(selectedEmployee[0].employeeId)'")
                                if arrConversationList.count > 0{
                                    let objMessageVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                                    objMessageVC.objConversation = arrConversationList[0]
                                    self.navigationController?.pushWithAnimation(viewController: objMessageVC)
                                }
                                else{
                                    if MessageManager.shared.isNetConnected{
                                        MessageManager.shared.call_CreateConvesationAPI(employeeIds: [Int64(selectedEmployee[0].employeeId)], groupName: "", groupImage: "", isGroup: false, showLoader: true) { (isSuccess, employeeConversationId)  in
                                            if isSuccess{
                                                let arrConversationData = tblConversationList.rowsFor(sql: "SELECT * FROM tblConversationList where isDeleted = '\(0)' AND employeeConversationId = '\(employeeConversationId)'")
                                                if arrConversationData.count > 0{
                                                    let objMessageVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                                                    objMessageVC.objConversation = arrConversationData[0]
                                                    self.navigationController?.pushWithAnimation(viewController: objMessageVC)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } onCancel: {
            //                print("NotWorking Popup Cancelled")
                        }
                        employeeListPicker.isFromMessage = true
                        employeeListPicker.selectedClients = []
                        employeeListPicker.allowMultipleSelection = false
                        employeeListPicker.show(withAnimation: .Fade)
                    }
                }
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

// MARK: - 
// MARK: - UITABLEVIEW DELEGATE METHODS
extension MessageListVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if MessageConstant.is_Device._iPhone{
            return (UIScreen.main.bounds.size.width * 75) / 320
        }
        else{
            return (UIScreen.main.bounds.size.width * 45) / 320
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredConversationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationListCell", for: indexPath) as! ConversationListCell
        
        if self.arrFilteredConversationList[indexPath.row].conversationImage != ""{
            if MessageManager.shared.checkFileExist(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.arrFilteredConversationList[indexPath.row].conversationImage){
                if let imgEmployeePic = MessageManager.shared.getImageFromDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.arrFilteredConversationList[indexPath.row].conversationImage){
                    cell.imgProfilePic.image = imgEmployeePic
                    cell.imgProfilePic.layer.cornerRadius = 5.0
                    cell.imgProfilePic.layer.masksToBounds = true
                    cell.imgProfilePic.contentMode = .scaleAspectFill
                }
            }
            else{
                BMAzure.loadDataFromAzure(clientSignature: self.arrFilteredConversationList[indexPath.row].conversationImage) { success, error, data in
                    if success && data != nil {
                        MessageManager.shared.saveFileToDirectory(strFolderName: DirectoryFolder.ConversationList.rawValue, strFileName: self.arrFilteredConversationList[indexPath.row].conversationImage, fileData: data!)
                        DispatchQueue.main.async {
                            cell.imgProfilePic.image = UIImage(data: data!)
                            cell.imgProfilePic.layer.cornerRadius = 5.0
                            cell.imgProfilePic.layer.masksToBounds = true
                            cell.imgProfilePic.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
        }
        else{
            cell.imgProfilePic.image = UIImage(named: "imgProfilePlaceholderBlur")
            cell.imgProfilePic.layer.cornerRadius = 5.0
            cell.imgProfilePic.layer.masksToBounds = true
            cell.imgProfilePic.contentMode = .scaleAspectFill
        }
        
        cell.viewIsActive.isHidden = self.arrFilteredConversationList[indexPath.row].isConnected ? false : true
        cell.viewIsActive.layer.cornerRadius = 5.0
        cell.viewIsActive.layer.masksToBounds = true
        
        cell.lblUserName.text = self.arrFilteredConversationList[indexPath.row].conversationName
        
        var strLastMessage : String = ""
        if self.arrFilteredConversationList[indexPath.row].lastSenderEmployeeId == Int(MessageManager.shared.employeeId)!{
            strLastMessage = "\("lblYou".localize) : "
        }
        else{
            strLastMessage = "\(self.arrFilteredConversationList[indexPath.row].lastSenderFirstName) : "
        }
        
        if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.Text.rawValue{
            strLastMessage = strLastMessage + self.arrFilteredConversationList[indexPath.row].lastMessageContent
        }
        else if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.Image.rawValue{
            strLastMessage = strLastMessage + "lblImage".localize
        }
        else if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.Voice_Audio.rawValue{
            strLastMessage = strLastMessage + "lblAudio".localize
        }
        else if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.Video.rawValue{
            strLastMessage = strLastMessage + "lblVideo".localize
        }
        else if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.SystemGenerated.rawValue{
            strLastMessage = self.arrFilteredConversationList[indexPath.row].lastMessageContent
        }
        else if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.Document.rawValue{
            strLastMessage = strLastMessage + "lblDocument".localize
        }
        else if self.arrFilteredConversationList[indexPath.row].lastMessageTypeId == MessageType.Location.rawValue{
            strLastMessage = strLastMessage + "lblLocation".localize
        }
        else{
            strLastMessage = "lblSayHello".localize + " 👋"
        }
        cell.lblLastMessage.text = strLastMessage
        
        cell.lblMessageTime.text = MessageManager.shared.dateFormatterHHMMA().string(from: MessageManager.shared.getCurrentZoneDate(timestamp: self.arrFilteredConversationList[indexPath.row].messageDateTime))
        
        cell.lblUnreadMessageCount.isHidden = self.arrFilteredConversationList[indexPath.row].unreadCount != 0 ? false : true
        cell.lblUnreadMessageCount.text = "\(self.arrFilteredConversationList[indexPath.row].unreadCount)"
        cell.lblUnreadMessageCount.layer.cornerRadius = cell.lblUnreadMessageCount.frame.height / 2.0
        cell.lblUnreadMessageCount.layer.masksToBounds = true
        
        cell.viewCellBg.layer.cornerRadius = 10.0
        cell.viewCellBg.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.50, x: 0, y: 2, blur: 10, spread: 0)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = self.tblConversation.cellForRow(at: indexPath) as? ConversationListCell{
            UIView.animate(withDuration: 0.2, animations: {
                selectedCell.viewCellBg.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { (success) in
                UIView.animate(withDuration: 0.2, animations: {
                    selectedCell.viewCellBg.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (success) in
                    let objMessageVC = UIStoryboard(name: "Message", bundle: nil).instantiateViewController(withIdentifier: "MessageVC") as! MessageVC
                    objMessageVC.objConversation = self.arrFilteredConversationList[indexPath.row]
                    self.navigationController?.pushWithAnimation(viewController: objMessageVC)
                }
            }
        }        
    }
}


// MARK: UISearch Bar Methods
// MARK:
extension MessageListVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.arrFilteredConversationList = self.arrConversationList
        }else{
            self.arrFilteredConversationList = self.arrConversationList.filter({$0.conversationName.lowercased().contain(searchText.lowercased())})
        }
        self.tblConversation.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
