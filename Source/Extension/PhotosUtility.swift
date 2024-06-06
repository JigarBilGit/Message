//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class PhotosUtility: NSObject,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK:singleton sharedInstance
    static let shared = PhotosUtility()
    
    // MARK: UIImagePicker Functionality
    
    //Camera Picker
    public typealias openCameraCallBackBlock = (_ selectedImage : UIImage?) ->Void
    public typealias openMessageCameraCallBackBlock = (_ selectedImage : UIImage?, _ selectedVideoURL : NSURL?, _ mediaType : String?) ->Void
    public var cameraCallBackBlock :openCameraCallBackBlock?
    public var cameraMessageCallBackBlock :openMessageCameraCallBackBlock?
    public var cameraController : UIViewController?
    
    var isFromMessage : Bool = false

    public func openCamera(_ controller:UIViewController, completionBlock:@escaping openMessageCameraCallBackBlock)
    {
        cameraMessageCallBackBlock = completionBlock
        cameraController = controller
        self.isFromMessage = true
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyNoCameraMessage".localize, completion: nil)
        }
        else{
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (authStatus == .authorized){
                self.openPickerWithCamera(true, true)
            }
            else if (authStatus == .notDetermined){
                print("Camera access not determined. Ask for permission.")
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if(granted)
                    {
                        self.openPickerWithCamera(true, true)
                    }
                })
            }
            else if (authStatus == .restricted){
                UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyCameraErrorMessage".localize, completion: nil)
            }
            else{
                UIAlertController.showAlert(self.cameraController!, aStrMessage: "KeyCameraPermissionMessage".localize, style: .alert, aCancelBtn: "keyCancelUpperCase".localize, aDistrutiveBtn: nil, otherButtonArr: ["keyOKUpperCase".localize], completion: { (index, strTitle) in
                    
                    if index == 0{
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                })
            }
        }
    }
    
    public func openCameraInController(_ controller:UIViewController, position : CGRect? ,completionBlock:@escaping openCameraCallBackBlock)
    {
        cameraCallBackBlock = completionBlock
        cameraController = controller
        
        UIAlertController.showActionsheetForImagePicker(cameraController!, position: position!, aStrMessage: nil) { (index, strTitle) in
            if index == 0 {
                if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                    
                    UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyNoCameraMessage".localize, completion: nil)
                }
                else{
                    
                    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                    if (authStatus == .authorized){
                        self.openPickerWithCamera(true, false)
                    }else if (authStatus == .notDetermined){
                        
                        print("Camera access not determined. Ask for permission.")
                        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                            if(granted)
                            {
                                self.openPickerWithCamera(true, false)
                            }
                        })
                    }else if (authStatus == .restricted){
                        
                        UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyCameraErrorMessage".localize, completion: nil)
                        
                    }else{
                        UIAlertController.showAlert(self.cameraController!, aStrMessage: "KeyCameraPermissionMessage".localize, style: .alert, aCancelBtn: "keyCancelUpperCase".localize, aDistrutiveBtn: nil, otherButtonArr: ["keyOKUpperCase".localize], completion: { (index, strTitle) in
                            
                            if index == 0{
                                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            }
                        })
                    }
                }
            }
        }
    }
    
    public func openCameraInControllerWithGallery(_ controller:UIViewController, position : CGRect? ,completionBlock:@escaping openCameraCallBackBlock)
    {
        cameraCallBackBlock = completionBlock
        cameraController = controller
        
        UIAlertController.showActionsheetForImagePickerWithGallery(cameraController!, position: position!, aStrMessage: nil) { (index, strTitle) in
            if index == 1{
                if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                    
                    UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyNoCameraMessage".localize, completion: nil)
                }
                else{
                    
                    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                    if (authStatus == .authorized){
                        self.openPickerWithCamera(true, false)
                    }else if (authStatus == .notDetermined){
                        
                        print("Camera access not determined. Ask for permission.")
                        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                            if(granted)
                            {
                                self.openPickerWithCamera(true, false)
                            }
                        })
                    }else if (authStatus == .restricted){
                        
                        UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyCameraErrorMessage".localize, completion: nil)
                        
                    }else{
                        
                        UIAlertController.showAlert(self.cameraController!, aStrMessage: "KeyCameraPermissionMessage".localize, style: .alert, aCancelBtn: "keyCancelUpperCase".localize, aDistrutiveBtn: nil, otherButtonArr: ["keyOKUpperCase".localize], completion: { (index, strTitle) in
                            
                            if index == 0{
                                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            }
                        })
                    }
                }
            }else if index == 0{
                
                let authorizationStatus = PHPhotoLibrary.authorizationStatus()
                
                if (authorizationStatus == .authorized) {
                    // Access has been granted.
                    self.openPickerWithCamera(false, false)
                }else if (authorizationStatus == .restricted) {
                    // Restricted access - normally won't happen.
                    
                    UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyPhotoErrorMessage".localize, completion: nil)
                    
                }else if (authorizationStatus == .notDetermined) {
                    
                    // Access has not been determined.
                    PHPhotoLibrary.requestAuthorization({ (status) in
                        if (status == .authorized) {
                            // Access has been granted.
                            self.openPickerWithCamera(false, false)
                        }else {
                            // Access has been denied.
                        }
                    })
                }else{
                    UIAlertController.showAlert(self.cameraController!, aStrMessage: "KeyPhotoPermissionMessage".localize, style: .alert, aCancelBtn: "keyCancelUpperCase".localize, aDistrutiveBtn: nil, otherButtonArr: ["keyOKUpperCase".localize], completion: { (index, strTitle) in
                        
                        if index == 0{
                            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        }
                    })
                }
            }
        }
    }
    
    public func openCameraDirect(_ controller:UIViewController, position : CGRect? ,completionBlock:@escaping openCameraCallBackBlock)
    {
        cameraCallBackBlock = completionBlock
        cameraController = controller
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyNoCameraMessage".localize, completion: nil)
        }
        else{
            
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (authStatus == .authorized){
                self.openPickerWithCamera(true, false)
            }else if (authStatus == .notDetermined){
                
                print("Camera access not determined. Ask for permission.")
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                    if(granted)
                    {
                        self.openPickerWithCamera(true, false)
                    }
                })
            }else if (authStatus == .restricted){
                
                UIAlertController.showAlertWithOkButton(self.cameraController!, aStrMessage: "KeyCameraErrorMessage".localize, completion: nil)
                
            }else{
                
                UIAlertController.showAlert(self.cameraController!, aStrMessage: "KeyCameraPermissionMessage".localize, style: .alert, aCancelBtn: "keyCancelUpperCase".localize, aDistrutiveBtn: nil, otherButtonArr: ["keyOKUpperCase".localize], completion: { (index, strTitle) in
                    
                    if index == 0{
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }
                })
            }
        }
    }
    
    public func openPickerWithCamera(_ isopenCamera : Bool, _ isFromMesage : Bool) {
        DispatchQueue.main.async {
            let captureImg = UIImagePickerController()
            captureImg.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            captureImg.allowsEditing = false
            if isopenCamera {
                captureImg.sourceType = UIImagePickerController.SourceType.camera
                if isFromMesage{
                    if #available(iOS 14.0, *) {
                        captureImg.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
                    }
                    else {
                        captureImg.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
                    }
                }
            }
            else{
                captureImg.sourceType = UIImagePickerController.SourceType.photoLibrary
            }
            self.cameraController?.present(captureImg, animated: true, completion: nil)
        }
    }
    
    // MARK: UIImagePicker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if !picker.allowsEditing {
             if self.isFromMessage{
                 if let mediaType = info[.mediaType] as? String {
                     if mediaType == kUTTypeMovie as String {
                         if (cameraMessageCallBackBlock != nil){
                             cameraMessageCallBackBlock!(nil, info[UIImagePickerController.InfoKey.mediaURL] as? NSURL, mediaType)
                         }
                     }
                     else if mediaType == kUTTypeImage as String {
                         if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                             if (cameraMessageCallBackBlock != nil){
                                 cameraMessageCallBackBlock!(img, nil, mediaType)
                             }
                         }
                     }
                 }
             }
             else{
                 if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                     if (cameraCallBackBlock != nil){
                         cameraCallBackBlock!(img)
                     }
                 }
             }
         }
         else {
             if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                 if (cameraCallBackBlock != nil){
                     cameraCallBackBlock!(img)
                 }
             }
         }
         picker.dismiss(animated: true, completion: nil)
    }    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        if (cameraCallBackBlock != nil){
            
            cameraCallBackBlock!(nil)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
