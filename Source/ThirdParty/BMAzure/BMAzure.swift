//
//  BMAzure.swift
//  BilliyoClinicalHealth
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import UIKit
import AZSClient

class BMAzure: NSObject {
    public class func loadDataFromAzure(clientSignature : String, completion: @escaping(_ success : Bool, _ error : NSError?, _ data: Data?) -> Void){
        
//        print("downloadSuperVisorSignatureFromAzure : Container : \(AppManager.shared.timiroCode) Client Signature : \(clientSignature)")
        
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()
            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: MessageManager.shared.timiroCode)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: clientSignature)
            blockBlob.downloadToData { (error, data) in
                if error != nil {
                    completion(false, error as NSError?, data)
                }else{
                    if let data = data {
                        completion(true, nil, data)
                    }
                }
            }
        } catch  {
            print(error)
        }
    }
    
    public class func uploadImageToAzure(strImageName : String, imgSignature : UIImage, completion: @escaping( _ scuccess: Bool, _ error : NSError?) -> Void){
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()
            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: MessageManager.shared.timiroCode)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: strImageName)
            
            blockBlob.upload(from: imgSignature.compressedData()!, completionHandler: {(error) in
                if error != nil {
//                    print("Error :\(error?.localizedDescription ?? "")")
                    completion(false, error as NSError?)
                }else{
                    completion(true, nil)
                }
            })
        } catch  {
            completion(false, error as NSError)
        }
    }
    
    public class func uploadDataToAzure(objVC: UIViewController, strFileName : String, fileData : Data, completion: @escaping( _ scuccess: Bool) -> Void){
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()
            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: MessageManager.shared.timiroCode)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: strFileName)
            
            blockBlob.upload(from: fileData, completionHandler: {(error) in
                if error != nil {
//                    print("Error :\(error?.localizedDescription ?? "")")
                    completion(false)
                }else{
                    completion(true)
                }
            })
        } catch  {

            print(error)
        }
    }
    
    public class func uploadZipDataToAzure(strFileName : String, fileData : Data, completion: @escaping( _ scuccess: Bool) -> Void){
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()

            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: "\(MessageManager.shared.timiroCode)/AppBackup")
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: strFileName)
            
            blockBlob.upload(from: fileData, completionHandler: {(error) in
                if error != nil {
//                    print("Error :\(error?.localizedDescription ?? "")")
                    completion(false)
                }else{
                    completion(true)
                }
            })
        } catch  {

            print(error)
        }
    }
    
    public class func loadAttachmentDataFromAzure(containerName : String, strFileName : String, completion: @escaping(_ success : Bool, _ error : NSError?, _ data: Data?) -> Void){
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()

            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: containerName)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: strFileName)
            blockBlob.downloadToData { (error, data) in
                if error != nil {
                    completion(false, error as NSError?, nil)
                    print("Error :\(error?.localizedDescription ?? "")")
                }else{
                    if let data = data {
                        completion(true, nil, data)
                    }
                }
            }
        } catch  {
            print(error)
        }
    }
    
    public class func uploadAttachmentDataToAzure(mobilePrimaryKey : String, containerName : String, strFileName : String, fileData : Data, resourceId : Int, strResourceType : String, completion: @escaping(_ scuccess: Bool, _ mobilePrimaryKey: String) -> Void){
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()
            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: containerName)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: strFileName)
            
            blockBlob.upload(from: fileData, completionHandler: {(error) in
                if error != nil {
//                    print("Error :\(error?.localizedDescription ?? "")")
                    DispatchQueue.main.async {
//                        APP_DELEGATE.call_UploadContentOnAzure(resourceId: resourceId, strDocumentFile: fileData.base64EncodedString(), strErrorMessage: error?.localizedDescription ?? "", strResourceType: strResourceType, strResourceName: strFileName) { Success in
//                            if Success{
//                                completion(true, mobilePrimaryKey)
//                            }
//                            else{
//                                completion(false, mobilePrimaryKey)
//                            }
//                        }
                    }
                }else{
                    completion(true, mobilePrimaryKey)
                }
            })
        } catch  {
            print(error)
        }
    }
    
    public class func checkBlobExist(strImageName: String, completion: @escaping( _ scuccess: Bool) -> Void){
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()
            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: MessageManager.shared.timiroCode)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: strImageName)
            
            blockBlob.exists(completionHandler: { (error, isExist) in
                if error != nil {
                    completion(false)
                }else{
                    completion(isExist)
                }
            })
        } catch  {
            print(error)
        }
    }
    
    
    
    public class func loadDataFromAzure(directoryPath path : String, file fileName: String,completion: @escaping(_ success : Bool, _ error : NSError?, _ data: Data?) -> Void){
        
        do {
            let account = try AZSCloudStorageAccount(fromConnectionString: MessageManager.shared.AzureConnectionString)
            let blobClient : AZSCloudBlobClient = account.getBlobClient()
            let blobContainer : AZSCloudBlobContainer = blobClient.containerReference(fromName: path)
            let blockBlob : AZSCloudBlockBlob = blobContainer.blockBlobReference(fromName: fileName)
            blockBlob.downloadToData { (error, data) in
                if error != nil {
                    completion(false, error as NSError?, data)
                }else{
                    if let data = data {
                        completion(true, nil, data)
                    }else{
                        completion(false, error as NSError?, nil)
                    }
                }
            }
        } catch  {
            print(error)
            completion(false, error as NSError?, nil)
        }
    }
}
