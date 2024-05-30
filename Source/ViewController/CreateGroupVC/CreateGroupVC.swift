//
//  CreateGroupVC.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import SDWebImage

class CreateGroupVC: UIViewController {
    // MARK: 
    // MARK: IBOUTLET VARIABLE
    @IBOutlet weak var viewMainBG: UIView!
    @IBOutlet weak var viewCenterBG: UIView!
    @IBOutlet weak var viewCenterBGWidth: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: BHLabel!
    
    @IBOutlet weak var viewGroupPic: UIView!
    @IBOutlet weak var imgGroupPic: UIImageView!
    @IBOutlet weak var btnGroupPic: UIButton!
    
    @IBOutlet weak var viewGroupName: UIView!
    @IBOutlet weak var txtGroupName: BHTextField!
    
    @IBOutlet weak var viewSelectedClient: UIView!
    @IBOutlet weak var collSelectedClient: UICollectionView!
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UISearchBar!
    
    @IBOutlet weak var tblClientList: UITableView!
    @IBOutlet weak var tblClientListHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnCreate: BHButton!
    @IBOutlet weak var btnCancel: BHButton!
    
    // MARK: 
    // MARK: VARIABLE
    var isImageSelected : Bool = false
    var strGroupImage : String = ""
    
    var arrClient = [tblEmployees]()
    var arrFilteredClient = [tblEmployees]()
    
    var arrSelectedClient = [tblEmployees]()
    
    var setCreateGroupHandler: ((_ strGroupName:String, _ strGroupImageName:String, _ employeeIds:[Int64], _ isCancel:Bool) -> Void)?
    
    var viewSpinner:UIView?
    
    // MARK: 
    // MARK: VIEW CYCLE START
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewCenterBGWidth.constant = MessageConstant.is_Device._iPhone ? self.view.width * 0.95 : self.view.width * 0.65
        
        self.arrFilteredClient = self.arrClient
        
        self.tblClientList.register(UINib(nibName: "ClientListCell", bundle: nil), forCellReuseIdentifier: "ClientListCell")
        self.tblClientList.estimatedRowHeight = 65.0
        self.tblClientList.rowHeight = UITableView.automaticDimension
        self.tblClientList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.collSelectedClient.register(UINib(nibName: "SelectedClientCell", bundle: nil), forCellWithReuseIdentifier: "SelectedClientCell")
        
        self.tblClientList.reloadData()
        self.collSelectedClient.reloadData()
        
        self.collSelectedClient.isHidden = self.arrSelectedClient.count > 0 ? false : true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        self.navigationController?.navigationBar.isHidden = true
    
        self.setLanguageText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.viewCenterBG.layer.cornerRadius  = 10.0
        self.viewCenterBG.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.60, x: 0, y: 2, blur: 10, spread: 0)
        
        self.setViewShadow(objView: self.viewGroupPic)
        self.setViewShadow(objView: self.viewGroupName)
        self.setViewShadow(objView: self.viewSearch)
        
        self.viewGroupPic.layer.cornerRadius = 10.0
        
        self.imgGroupPic.layer.cornerRadius = 10.0
        self.imgGroupPic.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: 
    // MARK: CUSTOM METHODS
    func setLanguageText() -> Void {
        self.lblTitle.text = "lblCreateGroup".localize
        self.txtGroupName.placeholder = "lblGroupName".localize
        
        self.btnCreate.setTitle("btnCreateUpperCase".localize, for: .normal)
        self.btnCancel.setTitle("keyCancelUpperCase".localize, for: .normal)
    }
    
    func setViewShadow(objView : UIView){
        objView.backgroundColor = MessageTheme.Color.white
        objView.layer.cornerRadius = 10.0
        objView.layer.applySketchShadow(color: UIColor(red: 167.0/255, green: 169.0/255, blue: 169.0/255, alpha: 1.0), alpha: 0.30, x: 0, y: 2, blur: 10, spread: 0)
    }
    
    // MARK: 
    // MARK: BUTTON ACTION METHODS
    @IBAction func btnGroupPicClick(_ sender: UIButton) {
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
                    self.isImageSelected = true
                    DispatchQueue.main.async {
                        self.imgGroupPic.image = croppedImage
                        self.imgGroupPic.layer.cornerRadius = 10.0
                        self.imgGroupPic.layer.masksToBounds = true
                        self.imgGroupPic.contentMode = .scaleAspectFill
                    }
                }
                else{
                    self.imgGroupPic.image = #imageLiteral(resourceName: "imgProfilePlaceholderBlur")
                    self.imgGroupPic.layer.cornerRadius = 10.0
                    self.imgGroupPic.layer.masksToBounds = true
                    self.isImageSelected = false
                }
            }
            MessageManager().delay(delay: 0.5, closure: {
                self.present(cropperViewController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func btnCreateClick(_ sender: Any) {
        self.view.endEditing(true)
        
        let strGroupName = self.txtGroupName.text!.trimmingCharacters(in: .whitespaces)
        
        guard strGroupName.count > 0 else {
            MessageManager.shared.openCustomValidationAlertView(alertMessage: "lblGroupNameValidation".localize)
            return
        }
        guard self.arrSelectedClient.count > 0 else {
            MessageManager.shared.openCustomValidationAlertView(alertMessage: "lblGroupClientValidation".localize)
            return
        }
        
        if self.isImageSelected{
            self.uploadConversationImage()
        }
        else{
            self.setCreateGroupHandler?(strGroupName, "", self.arrSelectedClient.compactMap({$0.employeeId}), false)
            self.dismiss(animated: false, completion: nil)
        }
//
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.view.endEditing(true)
        self.setCreateGroupHandler?("", "", [], true)
        self.dismiss(animated: false, completion: nil)
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
    
    // MARK: 
    // MARK: EMPLOYEE SIGNATURE METHODS
    func uploadConversationImage() {
        // Conversation Image Upload Logic
        let strGroupName = self.txtGroupName.text!.trimmingCharacters(in: .whitespaces)
        if self.imgGroupPic.image != #imageLiteral(resourceName: "imgProfilePlaceholderBlur"){
            self.showLoader()
            
            let strGroupImageName = MessageManager.shared.generateImageName(strTag: "Conversation", strExtention: "jpg")
            BHAzure.uploadImageToAzure(strImageName: strGroupImageName, imgSignature: self.imgGroupPic.image!, completion: { success, error in
                self.hideLoader()
                if success {
                    self.strGroupImage = strGroupImageName
                    DispatchQueue.main.async {
                        self.setCreateGroupHandler?(strGroupName, strGroupImageName, self.arrSelectedClient.compactMap({$0.employeeId}), false)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            })
        }
        else{
            self.setCreateGroupHandler?(strGroupName, "", self.arrSelectedClient.compactMap({$0.employeeId}), false)
            self.dismiss(animated: false, completion: nil)
        }
    }
        
    // MARK: 
    // MARK: API CALLER METHODS
    
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

// MARK: - 
// MARK: - UITABLEVIEW DELEGATE METHODS
extension CreateGroupVC : UITableViewDelegate,UITableViewDataSource {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableview = object as? UITableView {
            tableview.layer.removeAllAnimations()
            if tableview == self.tblClientList {
                if self.tblClientList.frame.height > self.view.frame.height * 0.45{
                    self.tblClientListHeight.constant = self.view.frame.height * 0.45
                }
                else{
                    self.tblClientListHeight.constant = self.tblClientList.contentSize.height
                }
            }
            UIView.animate(withDuration: 0.5) {
                self.updateViewConstraints()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredClient.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientListCell", for: indexPath) as! ClientListCell
        
        let dataModel = self.arrFilteredClient[indexPath.row]
        cell.lblTitle.text = MessageManager.shared.getFullName(firstName: dataModel.firstName, middleName: dataModel.middleName, lastName: dataModel.lastName)
        if self.arrSelectedClient.contains(dataModel){
            cell.imgSelection.image = #imageLiteral(resourceName: "imgCheckboxSelected")
        }else{
            cell.imgSelection.image = #imageLiteral(resourceName: "imgCheckbox")
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
        let client = self.arrFilteredClient[indexPath.row]
        if self.arrSelectedClient.count > 0{
            if self.arrSelectedClient.contains(obj: client){
                self.arrSelectedClient.removeAll{ $0.employeeId == client.employeeId}
            }else{
                self.arrSelectedClient.append(client)
            }
        }else{
            self.arrSelectedClient.append(client)
        }
        
        self.collSelectedClient.isHidden = self.arrSelectedClient.count > 0 ? false : true
        self.collSelectedClient.reloadData()
        
        self.tblClientList.reloadData()
    }
}

// MARK: - 
// MARK: - Collection View Delegate and Data Source Methods
extension CreateGroupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSelectedClient.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedClientCell", for: indexPath) as! SelectedClientCell
        cell.viewUserName.layer.borderWidth = 1.0
        cell.viewUserName.layer.borderColor = MessageTheme.Color.primaryTheme.cgColor
        cell.viewUserName.layer.cornerRadius = 5.0
        
        cell.lblUserName.text = MessageManager.shared.getFullName(firstName: self.arrSelectedClient[indexPath.item].firstName, middleName: self.arrSelectedClient[indexPath.item].middleName, lastName: self.arrSelectedClient[indexPath.item].lastName)
        
        cell.btnDeleteClient.tag = indexPath.item
        cell.btnDeleteClient.addTarget(self, action: #selector(btnDeleteClientClick(_:)), for: .touchUpInside)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = MessageManager.shared.getFullName(firstName: self.arrSelectedClient[indexPath.item].firstName, middleName: self.arrSelectedClient[indexPath.item].middleName, lastName: self.arrSelectedClient[indexPath.item].lastName)
        label.sizeToFit()
        return CGSize(width: label.frame.width < (collectionView.frame.size.height + 20) ? label.frame.width : collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    // MARK: 
    // MARK: BUTTON ACTION METHODS FOR COLLECTIONVIEW CELL BUTTON
    @IBAction func btnDeleteClientClick(_ sender: UIButton) {
        self.view.endEditing(true)
        let client = self.arrSelectedClient[sender.tag]
        if self.arrSelectedClient.count > 0{
            if self.arrSelectedClient.contains(obj: client){
                self.arrSelectedClient.removeAll{ $0.employeeId == client.employeeId}
            }else{
                self.arrSelectedClient.append(client)
            }
        }else{
            self.arrSelectedClient.append(client)
        }
        
        self.collSelectedClient.isHidden = self.arrSelectedClient.count > 0 ? false : true
        self.collSelectedClient.reloadData()
        
        self.tblClientList.reloadData()
    }
}

// MARK: UISearch Bar Methods
// MARK:
extension CreateGroupVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.arrFilteredClient = self.arrClient
        }else{
            self.arrFilteredClient = self.arrClient.filter({(MessageManager.shared.getFullName(firstName: $0.firstName, middleName: $0.middleName, lastName: $0.lastName)).lowercased().contains(searchText.lowercased())})
        }
        self.tblClientList.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
