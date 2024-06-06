//
//  BMPopupImageView.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 27/07/21.
//

import UIKit

enum PopupActionType {
    case cancel
}

typealias OnPopupCompletion = ((Bool, PopupActionType) -> ())?


class BMPopupImageView: UIView {
    
    static let instance = BMPopupImageView()
    
    var OnAlertHandler : ((Bool, PopupActionType) -> ())?
    
    
    @IBOutlet var parentView            : UIView!
    @IBOutlet weak var popupView        : UIView!
    @IBOutlet weak var imageScrollView  : BMImageScrollView!
    @IBOutlet weak var btnCancel        : UIButton!
    
    @IBOutlet weak var popupViewWidth   : NSLayoutConstraint!
    @IBOutlet weak var popupViewHeight  : NSLayoutConstraint!
    
    var arrayImages = [UIImage]()
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("BMPopupImageView", owner: self, options: nil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: Initial Setuup Methods
extension BMPopupImageView{
    private func commonInit() {
        
        self.popupView.layer.cornerRadius = 10
        self.parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        imageScrollView.setup()
        imageScrollView.imageScrollViewDelegate = self
       
        imageScrollView.initialOffset = .center
        imageScrollView.imageContentMode = .aspectFit
        
        
        self.btnCancel.roundCorners(radius: self.btnCancel.frame.width/2)
        

    }
    

}

// MARK: Alert Show Methods

extension BMPopupImageView{
    func showAlert(images: [UIImage],
                   width : CGFloat,
                   height : CGFloat,
                   OnComplete: OnPopupCompletion) {
        
        let popupWidth =  UIScreen.main.bounds.width - 60
        let popupHeight =  UIScreen.main.bounds.height - 60
        
        if(popupWidth < popupHeight){
            self.popupViewWidth.constant = popupWidth
            self.popupViewHeight.constant = popupWidth
        }else{
            self.popupViewWidth.constant = popupHeight
            self.popupViewHeight.constant = popupHeight
        }
        
        //self.popupViewWidth.constant = width
        //self.popupViewHeight.constant = height
        self.arrayImages = images
        imageScrollView.display(image: arrayImages[index])
        OnAlertHandler = OnComplete
        
        let window = UIApplication.shared.windows.last!
        window.addSubview(self.parentView) 
    }
}


// MARK: Action Methods

extension BMPopupImageView{
    @IBAction func clickOnCancel(_ sender: Any) {
        self.parentView.removeFromSuperview()
        OnAlertHandler!(true, .cancel)
    }
    
}
    

extension BMPopupImageView : ImageScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: BMImageScrollView) {
//        print("Did change orientation")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        print("scrollViewDidEndZooming at scale \(scale)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll at offset \(scrollView.contentOffset)")
    }
}


/*
 
 @IBAction func previousButtonTap(_ sender: AnyObject) {
     index = (index - 1 + images.count)%images.count
     imageScrollView.display(image: images[index])
 }
 
 @IBAction func nextButtonTap(_ sender: AnyObject) {
     index = (index + 1)%images.count
     imageScrollView.display(image: images[index])
 }
 
*/
