//
//  EmployeeListPopupVC.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 11/08/21.
//

import UIKit

enum EmployeeListPopupAnimation:String{
    case FromBottom
    case Fade
}

enum EmployeeListPopupCheckMarkPosition:String{
    case Left
    case Right
}

struct EmployeeListPopupAppearanceManager{
    
    var pickerTitle : String?
    var titleFont : UIFont?
    var titleTextColor : UIColor?
    var titleBackground : UIColor?
    
    var searchBarFont : UIFont?
    var searchBarPlaceholder : String?
    
    var closeButtonTitle : String?
    var closeButtonColor : UIColor?
    var closeButtonFont : UIFont?
    
    var doneButtonTitle : String?
    var doneButtonColor : UIColor?
    var doneButtonFont : UIFont?
    
    var checkMarkPosition : EmployeeListPopupCheckMarkPosition?
    var itemCheckedImage : UIImage?
    var itemUncheckedImage : UIImage?
    var itemColor : UIColor?
    var itemFont : UIFont?
    
}

class EmployeeListPopupVC: UIViewController {
    
    // MARK: - Constants
    let animationDuration = 0.3
    let shadowAmount:CGFloat = 0.6
    let shadowColor = UIColor.black
    
    // MARK: - IBOutlets
   // @IBOutlet var tapToDismissGesture: UITapGestureRecognizer!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tblListView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    // MARK: - Constraints
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    // MARK: - Properties
    var isFromMessage : Bool = false
    var arrayClient = [tblEmployees]()
    var arrayFilterClient = [tblEmployees]()
    
    var selectedClients = [tblEmployees]()
    
    var allowMultipleSelection = false
    //var tapToDismiss = true
    var animation = EmployeeListPopupAnimation.FromBottom
    var appearanceManager : EmployeeListPopupAppearanceManager?
    
    var completionHandler : ((_ selectedClient:[tblEmployees])->Void)?
    var cancelHandler : (()->Void)?
    
    // MARK: - Init
    
    init (
        with items : [tblEmployees],
        selectedClient : [tblEmployees]? = nil,
        appearance : EmployeeListPopupAppearanceManager?,
        onCompletion : @escaping (_ selectedClient:[tblEmployees]) -> Void,
        onCancel : @escaping () -> Void
    ){
        
        super.init(nibName: "EmployeeListPopupVC", bundle: nil)
        
        if(selectedClient != nil){
            self.selectedClients = selectedClient!
        }
        
        self.arrayClient = items
        self.arrayFilterClient = items
        
        self.appearanceManager = appearance
        
        self.completionHandler = onCompletion
        self.cancelHandler = onCancel
        
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:
// MARK: Initial Value Assign Methods
// MARK:
extension EmployeeListPopupVC{
    func initialValueAssigning(){
        
        if let appearance = self.appearanceManager{
            if let pTitle = appearance.pickerTitle{
                self.titleLabel.text = pTitle
            }
            
            if let tFont = appearance.titleFont{
                self.titleLabel.font = tFont
            }
            
            if let tBGColor = appearance.titleBackground{
                self.titleLabel.backgroundColor = tBGColor
            }
            
            if let tColor = appearance.titleTextColor{
                self.titleLabel.textColor = tColor
            }
            
            if let sFont = appearance.searchBarFont{
                if let textFieldInsideSearchBar = txtSearch.value(forKey: "searchField") as? UITextField{
                    textFieldInsideSearchBar.resignFirstResponder()
                    textFieldInsideSearchBar.font = sFont
                    if let backgroundview = textFieldInsideSearchBar.subviews.first {
                        backgroundview.layer.borderWidth = 0.5
                        backgroundview.layer.borderColor = MessageTheme.Color.primaryTheme.cgColor
                        backgroundview.backgroundColor = MessageTheme.Color.clear
                        backgroundview.layer.cornerRadius = backgroundview.frame.height / 2.0
                        backgroundview.clipsToBounds = true
                    }
                }
            }
            
            if let sPlaceholder = appearance.searchBarPlaceholder{
                self.txtSearch.placeholder = sPlaceholder
            }
            
            if let cBtnTitle = appearance.closeButtonTitle{
                self.btnClose.setTitle(cBtnTitle, for: .normal)
            }
            
            if let cBtnColor = appearance.closeButtonColor{
                self.btnClose.setTitleColor(cBtnColor, for: .normal)
            }
            
            if let cBtnFont = appearance.closeButtonFont{
                self.btnClose.titleLabel?.font = cBtnFont
            }
            
            if let dBtnTitle = appearance.doneButtonTitle{
                self.btnDone.setTitle(dBtnTitle, for: .normal)
            }
            
            if let dBtnColor = appearance.doneButtonColor{
                self.btnDone.setTitleColor(dBtnColor, for: .normal)
            }
            
            if let dBtnFont = appearance.doneButtonFont{
                self.btnDone.titleLabel?.font = dBtnFont
            }
            
            if !self.allowMultipleSelection{
                self.btnDone.isHidden = true
            }
            else{
                self.btnDone.isHidden = false
            }
        }
    }
}
// MARK:
// MARK: View Controller Life Cycle Methods
// MARK:

extension EmployeeListPopupVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerAndObserver()
        self.setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: animationDuration, animations: {
            self.shadowView.backgroundColor = self.shadowColor.withAlphaComponent(self.shadowAmount)
            
            if self.animation == .Fade{
                self.containerView.alpha = 1
            }
        })
    }
}

// MARK:
// MARK: UIView Setup Methods
// MARK:

extension EmployeeListPopupVC{
    
    
    func registerAndObserver(){
        self.tblListView.register(UINib.init(nibName: "ClientListCell", bundle: nil), forCellReuseIdentifier: "ClientListCell")
        self.tblListView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.tblListView.delegate = self
        self.tblListView.dataSource = self
    }
    
    func setupLayout(){
        
        if animation == .Fade{
            containerView.alpha = 0
        }
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
        
        if self.selectedClients.count == 0 {
            selectedClients = []
        }
        
        //tapToDismissGesture.isEnabled = tapToDismiss
        
        self.initialValueAssigning()
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        switch (deviceIdiom) {
        case .pad:
            self.viewWidth.constant = UIScreen.main.bounds.width * 0.65
        case .phone:
            self.viewWidth.constant = UIScreen.main.bounds.width * 0.85
        case .tv: break
            //print("tvOS style UI")
        default: break
           // print("Unspecified UI idiom")
        }
    }
}

// MARK:
// MARK: Picker Show and Close Methods
// MARK:

extension EmployeeListPopupVC{
    
    func show(withAnimation animationType:EmployeeListPopupAnimation){
        self.animation = animationType
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: false, completion: nil)
        }
    }
    
    func closePicker(){
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        
//        UIView.animate(withDuration: animationDuration, animations: {
//            self.shadowView.backgroundColor = .clear
//            
//            if self.animation == .Fade{
//                self.containerView.alpha = 0
//            }
//            
//        }) { (completed) in
//            
//        }
    }
}

// MARK:
// MARK: Button Action Methods
// MARK:
extension EmployeeListPopupVC{
    
    @IBAction func clickedOnClose(_ sender: Any) {
        self.cancelHandler?()
        self.closePicker()
    }
    
    @IBAction func clickedOnDone(_ sender: Any) {
        let client = selectedClients
        self.completionHandler?(client)
        self.closePicker()
    }
    
}

// MARK: UISearch Bar Methods
// MARK:

extension EmployeeListPopupVC : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            self.arrayFilterClient = self.arrayClient
        }else{
            self.arrayFilterClient = self.arrayClient.filter{
                $0.firstName.lowercased().contains(searchText.lowercased()) ||
                $0.middleName.lowercased().contains(searchText.lowercased()) ||
                $0.lastName.lowercased().contains(searchText.lowercased())
            }
        }
        self.tblListView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

// MARK: UITable View Datasource and Delegate Methods
// MARK:

extension EmployeeListPopupVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientListCell", for: indexPath) as! ClientListCell
        let client = self.arrayFilterClient[indexPath.row]
        cell.lblTitle.text = MessageManager.shared.getFullName(firstName: client.firstName,
                                                           middleName:  client.middleName,
                                                           lastName: client.lastName)
                
        var chkImage:UIImage? = nil
        var unChkImage:UIImage? = nil
        
        if let appearance = self.appearanceManager{
            if let itFont = appearance.itemFont{
                cell.lblTitle.font = itFont
            }
            if let itColor = appearance.itemColor{
                cell.lblTitle.textColor = itColor
            }
            
            if let itCheckedImage = appearance.itemCheckedImage{
                chkImage = itCheckedImage
            }
            
            if let itUncheckedImage = appearance.itemUncheckedImage{
                unChkImage = itUncheckedImage
            }
        }
        
        if selectedClients.count > 0{
            let arrSelectedClientIds = selectedClients.compactMap({$0.employeeId})
            if arrSelectedClientIds.contains(obj: client.employeeId){
                cell.imgSelection.image = chkImage
            }
            else{
                cell.imgSelection.image = unChkImage
            }
        }
        else{
            cell.imgSelection.image = unChkImage
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayFilterClient.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowMultipleSelection == false {
            selectedClients = [tblEmployees]()
        }
        
        let client = self.arrayFilterClient[indexPath.row]
        if selectedClients.count > 0{
            if selectedClients[0].employeeId == client.employeeId{
                selectedClients.removeAll{ $0.employeeId == client.employeeId }
            }else{
                selectedClients.append(client)
            }
        }else{
            selectedClients.append(client)
        }
        
        var cellsToReload = [IndexPath]()
        if allowMultipleSelection == false {
            cellsToReload = tableView.indexPathsForVisibleRows!
            //RELOAD ALL VISIBLE CELLS SO THAT PREVIOUSLY SELECTED CELL GETS DE-SELECTED
        }else{
            cellsToReload = [indexPath]
            //SELECT OR DE-SELECT CURRENT CELL (NO NEED TO RELOAD OTHER CELLS)
        }
        tableView.reloadRows(at: cellsToReload, with: .none)
        
        if !self.allowMultipleSelection{
            MessageManager().delay(delay: 0.5) {
                if self.selectedClients.count > 0{
                    let client = self.selectedClients
                    self.completionHandler?(client)
                    self.closePicker()
                }
            }
        }
    }
}

// MARK: Observer Methods
// MARK:

extension EmployeeListPopupVC{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableview = object as? UITableView {
            tableview.layer.removeAllAnimations()
            
            self.tableViewHeight.constant = self.tblListView.contentSize.height
            if self.tblListView.contentSize.height > self.view.frame.height * 0.5{
                self.tableViewHeight.constant = self.view.frame.height * 0.5
            }
            else{
                self.tableViewHeight.constant = self.tblListView.contentSize.height
            }
            UIView.animate(withDuration: 0.5) {
                self.updateViewConstraints()
            }
        }
    }
}
