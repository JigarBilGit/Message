//
//  BMAlertVC.swift
//  BilliyoClinicalPDN
//
//  Created by Billiyo Health on 27/10/22.
//

import UIKit

enum AlertActionType {
    case right
    case left
}

typealias OnAlertCompletion = ((Bool, AlertActionType) -> ())?

class BMAlertVC: UIViewController {
    
    // MARK: - Constants
    let animationDuration = 0.3
    let shadowAmount:CGFloat = 0.6
    let shadowColor = UIColor.black
    
    // MARK: - IBOutlets
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblTitle     : BMLabel!
    @IBOutlet weak var lblMessage   : BMLabel!
    @IBOutlet weak var btnRight     : BMButton!
    @IBOutlet weak var btnLeft      : BMButton!
    
    
    var strTitle : String = ""
    var strMessage : String = ""
    var rightButtonTitle : String = ""
    var leftButtonTitle : String = ""
    var attributedMessage : NSAttributedString = NSAttributedString()
    // MARK: - Constraints
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    
    var OnAlertHandler : ((Bool, AlertActionType) -> ())?
    
    // MARK: - Init
    
    init (title: String,
          message: String,
          rightButtonTitle:String,
          leftButtonTitle:String? = "",
          OnComplete: OnAlertCompletion){
        
        super.init(nibName: "BMAlertVC", bundle: nil)
                
        self.strTitle = title
        self.strMessage = message
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonTitle = leftButtonTitle ?? ""

        OnAlertHandler = OnComplete
        
        self.modalPresentationStyle = .overCurrentContext
        
        self.show()
    }
    
    init (title: String,
          attributedMessage: NSAttributedString,
          rightButtonTitle:String,
          leftButtonTitle:String? = "",
          OnComplete: OnAlertCompletion){
        
        super.init(nibName: "BMAlertVC", bundle: nil)
                
        self.strTitle = title
        self.attributedMessage = attributedMessage
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonTitle = leftButtonTitle ?? ""

        OnAlertHandler = OnComplete
        
        self.modalPresentationStyle = .overCurrentContext

        self.show()
    }
    
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK:
// MARK: View Controller Life Cycle Methods
// MARK:

extension BMAlertVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK:
// MARK: UIView Setup Methods
// MARK:

extension BMAlertVC{

    func setupLayout(){
                
        self.containerView.alpha = 1
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 5
        
        self.lblTitle.text = self.strTitle
        self.lblMessage.text = self.strMessage
        
        if self.strMessage != ""{
            self.lblMessage.text = self.strMessage
        }
        else{
            self.lblMessage.attributedText = self.attributedMessage
        }
        
        if(self.leftButtonTitle == ""){
             self.btnLeft.isHidden = true
             self.btnLeft.setTitle("", for: .normal)
         }else{
             self.btnLeft.isHidden = false
             self.btnLeft.setTitle(self.leftButtonTitle, for: .normal)
         }
         
        self.btnRight.setTitle(self.rightButtonTitle, for: .normal)
    
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

extension BMAlertVC{
    
    func show(){
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(self, animated: false, completion: nil)
        }
    }
    
    func closePicker(actionType : AlertActionType){
        
        if actionType == .right {
            self.presentingViewController?.dismiss(animated: false, completion: {
                self.OnAlertHandler!(true, .right)
            })
        }
        else{
            self.presentingViewController?.dismiss(animated: false, completion: {
                self.OnAlertHandler!(true, .left)
            })
        }
    }
}

// MARK: Action Methods

extension BMAlertVC{
    @IBAction func clickOnRightButton(_ sender: Any) {
        self.closePicker(actionType: .right)
    }
    
    @IBAction func clickOnLeftButton(_ sender: Any) {
        self.closePicker(actionType: .left)
    }
}
