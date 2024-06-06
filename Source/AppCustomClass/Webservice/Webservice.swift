//
//
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2021 Billiyo Mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Webservice: NSObject {
    
    static let call : Webservice = Webservice()
    
    var isPrintLogs : Bool = false
    
    // CLOSUER DECLARATION
    typealias Success = (_ responseData: Any, _ success: Bool, _ requestId: String) -> Void
    typealias Progress = (_ progress: Double) -> Void
    typealias GoogleSuccess = (_ success: Bool) -> Void
    
    typealias Failure = () -> Void
    typealias FailureData = (_ responseData: Any, _ Flag:Bool, _ requestId: String) -> Void
    
}

/**
 @METHODS:- METHODS FOR CHECK INTERNET CONNECTION
 **/

extension Webservice {
    func isNetworkAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

/**
 @METHODS:- BASIC METHODS FOR CALLING API.
**/

extension Webservice {
    
    func GET(objVC: UIViewController, filePath: String, params: [String: Any]?, enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, strAPITag : String? = "", isForCommunication : Bool? = false, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        
        let headers: HTTPHeaders = [
            "Content-Type" : "application/json",
            "Authorization" : MessageManager.shared.accessTokenWithTokenType
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        print("GET URL:- \(strPath) \nHEADER:- \(headers) \nPARAM:- \(json!)\n")
        
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
        
        AF.request(strPath, method: .get, parameters: params, encoding: URLEncoding() as ParameterEncoding,headers: headers).responseJSON { (response:AFDataResponse<Any>) in
            
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            
            var message : String = ""
            let httpStatusCode = response.response?.statusCode
            let responseRequestID = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
            
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if let dictResponse = response.value as? [String : Any] {
                    onSuccess(dictResponse, true, responseRequestID)
                }
                else if let dictResponse = response.value as? [[String : Any]] {
                    onSuccess(dictResponse, true, responseRequestID)
                }
            }
            else if httpStatusCode == 401{
                print("401 URL = \(response.request!)")
//                MessageManager.shared.pushOnLoginVC()
            }
            else {
                if MessageManager.shared.displayAPICallPopup{
                    if strAPITag != ""{
                        let _ = tblAPISyncStatus().setAPIFailStatus(apiFailStatus: 1, apiName: strAPITag!, requestId: responseRequestID, errorMessage: response.error?.localizedDescription ?? "", errorCode: "\(httpStatusCode ?? 0)")
                    }
                }
                
                print("Error URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                        do{
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    print(jsonData["message"] as? String ?? "")
                                    message = jsonData["message"] as? String ?? ""
                                    if showLoader {
                                        DispatchQueue.main.async {
                                            MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: message)
                                        }
                                    }
                                    
                                    if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }
                                }
                            }
                        }catch {
                            if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                            }
                            print("GET Json serialize error - \(strResponse) -- \(response.request!)  -- \(response.error?._code ?? 400)")
                            print(error.localizedDescription)
                        }
                    }
                    else{
                        onFailure()
                    }
                }
            }
        }
    }
    
    func POST(objVC: UIViewController, filePath: String, params: [String: Any], enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, isOffline : Bool? = false, strAPITag : String? = "", isForCommunication : Bool? = false, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {

        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        
        var request = URLRequest(url: URL(string: strPath)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(MessageManager.shared.accessTokenWithTokenType)", forHTTPHeaderField: "Authorization")
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        print("POST URL:- \(strPath) \nHEADER:- \(MessageManager.shared.accessTokenWithTokenType) \nPARAM:- \(json!)\n")
        
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.responseString { response in
            let responseRequestID = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
            
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            
            var message : String = ""
            let httpStatusCode = response.response?.statusCode
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
//                        print("Success URL = \(response.request!)")
//                        print("POST 200 Json serialize error - \(strResponse)")
                        do{
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    onSuccess(jsonData, true, responseRequestID)
                                }
                                else if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String:AnyObject]]{
                                    onSuccess(jsonData, true, responseRequestID)
                                }
                            }
                        }catch {
                            if MessageManager.shared.displayAPICallPopup{
                                if strAPITag != ""{
                                    let _ = tblAPISyncStatus().setAPIFailStatus(apiFailStatus: 1, apiName: strAPITag!, requestId: responseRequestID, errorMessage: "Json Parsing error", errorCode: "\(httpStatusCode ?? 200)")
                                }
                            }
                            
                            //print("POST 200 Json serialize error - \(strResponse)")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            else if httpStatusCode == 401{
                print("\(httpStatusCode) URL = \(response.request!)")
//                MessageManager.shared.pushOnLoginVC()
            }
            else {
                if MessageManager.shared.displayAPICallPopup{
                    if strAPITag != ""{
                        let _ = tblAPISyncStatus().setAPIFailStatus(apiFailStatus: 1, apiName: strAPITag!, requestId: responseRequestID, errorMessage: response.error?.localizedDescription ?? "", errorCode: "\(httpStatusCode ?? 0)")
                    }
                }
                
                print("Error URL = \(response.request!)")
                if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                    if response != nil{
                        if response.data != nil{
                            let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                            do{
                                if let json = strResponse.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        print(jsonData["message"] as? String ?? "")
                                        message = jsonData["message"] as? String ?? ""
                                        if showLoader {
                                            DispatchQueue.main.async {
                                                MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: message)
                                            }
                                        }
                                        onFailure()
                                        
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }
                                }
                            }
                            catch {
                                onFailure()
                                
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                print("POST Json serialize error - \(strResponse) -- \(response.request!) -- \(response.error?._code ?? 400)")
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func POSTArray(filePath: String, params: [[String: Any]], enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, isOffline : Bool? = false, isForCommunication : Bool? = false, onSuccess: @escaping (Success), onFailure: @escaping (FailureData)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        
        var request = URLRequest(url: URL(string: strPath)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(MessageManager.shared.accessTokenWithTokenType)", forHTTPHeaderField: "Authorization")
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        print("POSTArray URL:- \(strPath) \nHEADER:- \(MessageManager.shared.accessTokenWithTokenType) \nPARAM:- \(json!)\n")
        
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.responseString { response in
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            
            let requestID = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
            
            let httpStatusCode = response.response?.statusCode
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                        do{
                            
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    onSuccess(jsonData, true, requestID)
                                }
                                else if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String:AnyObject]]{
                                    onSuccess(jsonData, true, requestID)
                                }
                            }
                        }catch {
                            if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                            }
                            print("POSTArray 200 Json serialize error - \(strResponse) -- \(response.request!)")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            else if httpStatusCode == 401{
                print("401 URL = \(response.request!)")
//                MessageManager.shared.pushOnLoginVC()
            }
            else {
                print("Erro URL = \(response.request!)")
                if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                    if response != nil{
                        if response.data != nil{
                            let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                            do{
                                if let json = strResponse.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        onFailure(jsonData,false, requestID)
                                        let message = jsonData["message"] as? String ?? ""
                                        
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }
                                }
                            }catch {
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                print("POSTArray Json serialize error - \(strResponse) -- \(response.request!)  -- \(response.error?._code ?? 400)")
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                else{
                    onFailure("",false,"")
                }
            }
        }
    }
    
    func POSTAPIArray(filePath: String, params: [[String: Any]], enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, isOffline : Bool? = false, isForCommunication : Bool? = false, onSuccess: @escaping ((_ requestId : String , _ responseData: Any, _ success: Bool) -> Void), onFailure: @escaping (FailureData)) {

        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            onFailure("",false,"")
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        var request = URLRequest(url: URL(string: strPath)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(MessageManager.shared.accessTokenWithTokenType)", forHTTPHeaderField: "Authorization")
    
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("POSTArray URL:- \(strPath) \nHEADER:- \(MessageManager.shared.accessTokenWithTokenType) \nPARAM:- \(json!)\n")
    
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
    
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.responseString { response in
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            let httpStatusCode = response.response?.statusCode
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                        do{
                            
                           let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                            
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    onSuccess(requestId, jsonData, true)
                                }
                                else if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String:AnyObject]]{
                                    onSuccess(requestId, jsonData, true)
                                }
                            }
                        }catch {
                            let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                            onFailure("",false, requestId)
                            if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                            }
                            print("POSTArray 200 Json serialize error - \(strResponse) -- \(response.request!)")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            else if httpStatusCode == 401{
                print("401 URL = \(response.request!)")
                let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                onFailure("",false, requestId)
//                MessageManager.shared.pushOnLoginVC()
            } else {
                print("Erro URL = \(response.request!)")
                
                if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                    if response != nil{
                        if response.data != nil{
                            let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                            do{
                                if let json = strResponse.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                        onFailure(strResponse,false, requestId)
                                        let message = jsonData["message"] as? String ?? ""
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }else{
                                        let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                        onFailure(strResponse,false, requestId)
                                    }
                                }else{
                                    let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                    onFailure(strResponse,false, requestId)
                                }
                            }catch {
                                
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                print("POSTArray Json serialize error - \(strResponse) -- \(response.request!)  -- \(response.error?._code ?? 400)")
                                print(error.localizedDescription)
                                let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                onFailure(strResponse,false, requestId)
                            }
                        }else{
                            let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                            onFailure("\(String(describing: httpStatusCode)) :: Response Data Nil",false, requestId)
                        }
                    }else{
                        let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                        onFailure("\(String(describing: httpStatusCode)) :: Response Nil",false, requestId)
                    }
                }else{
                    let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                    onFailure("\(String(describing: httpStatusCode))",false, requestId)
                }
            }
        }
    }
    
    func DELETEArray(filePath: String, params: [[String: Any]], enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, isOffline : Bool? = false, isForCommunication : Bool? = false, onSuccess: @escaping (Success), onFailure: @escaping (FailureData)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        
        var request = URLRequest(url: URL(string: strPath)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(MessageManager.shared.accessTokenWithTokenType)", forHTTPHeaderField: "Authorization")
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        print("POSTArray URL:- \(strPath) \nHEADER:- \(MessageManager.shared.accessTokenWithTokenType) \nPARAM:- \(json!)\n")
        
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.responseString { response in
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            
            let requestID = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
            
            let httpStatusCode = response.response?.statusCode
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                        do{
                            
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    onSuccess(jsonData, true, requestID)
                                }
                                else if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String:AnyObject]]{
                                    onSuccess(jsonData, true, requestID)
                                }
                            }
                        }catch {
                            if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                            }
                            print("POSTArray 200 Json serialize error - \(strResponse) -- \(response.request!)")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            else if httpStatusCode == 401{
                print("401 URL = \(response.request!)")
//                MessageManager.shared.pushOnLoginVC()
            }
            else {
                print("Erro URL = \(response.request!)")
                if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                    if response != nil{
                        if response.data != nil{
                            let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                            do{
                                if let json = strResponse.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        onFailure(jsonData,false, requestID)
                                        let message = jsonData["message"] as? String ?? ""
                                        
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }
                                }
                            }catch {
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                print("POSTArray Json serialize error - \(strResponse) -- \(response.request!)  -- \(response.error?._code ?? 400)")
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                else{
                    onFailure("",false,"")
                }
            }
        }
    }
    
    func DELETE(filePath: String, params: [String: Any], enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, isOffline : Bool? = false, strAPITag : String? = "", isForCommunication : Bool? = false, onSuccess: @escaping (Success), onFailure: @escaping (Failure)) {
        
        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        
        var request = URLRequest(url: URL(string: strPath)!)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(MessageManager.shared.accessTokenWithTokenType)", forHTTPHeaderField: "Authorization")
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        print("POST URL:- \(strPath) \nHEADER:- \(MessageManager.shared.accessTokenWithTokenType) \nPARAM:- \(json!)\n")
        
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.responseString { response in
            let responseRequestID = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
            
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            
            var message : String = ""
            let httpStatusCode = response.response?.statusCode
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                        //print("POST 200 Json serialize error - \(strResponse)")
                        do{
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    onSuccess(jsonData, true, responseRequestID)
                                }
                                else if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String:AnyObject]]{
                                    onSuccess(jsonData, true, responseRequestID)
                                }
                            }
                        }catch {
                            if MessageManager.shared.displayAPICallPopup{
                                if strAPITag != ""{
                                    let _ = tblAPISyncStatus().setAPIFailStatus(apiFailStatus: 1, apiName: strAPITag!, requestId: responseRequestID, errorMessage: "Json Parsing error", errorCode: "\(httpStatusCode ?? 200)")
                                }
                            }
                            
                            //print("POST 200 Json serialize error - \(strResponse)")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            else if httpStatusCode == 401{
                print("\(httpStatusCode) URL = \(response.request!)")
//                MessageManager.shared.pushOnLoginVC()
            }
            else {
                if MessageManager.shared.displayAPICallPopup{
                    if strAPITag != ""{
                        let _ = tblAPISyncStatus().setAPIFailStatus(apiFailStatus: 1, apiName: strAPITag!, requestId: responseRequestID, errorMessage: response.error?.localizedDescription ?? "", errorCode: "\(httpStatusCode ?? 0)")
                    }
                }
                
                print("Error URL = \(response.request!)")
                if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                    if response != nil{
                        if response.data != nil{
                            let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                            do{
                                if let json = strResponse.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        print(jsonData["message"] as? String ?? "")
                                        message = jsonData["message"] as? String ?? ""
                                        if showLoader {
                                            DispatchQueue.main.async {
                                                MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: message)
                                            }
                                        }
                                        onFailure()
                                        
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }
                                }
                            }
                            catch {
                                onFailure()
                                
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                print("POST Json serialize error - \(strResponse) -- \(response.request!) -- \(response.error?._code ?? 400)")
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func submitAPIErrorDetail(strAPIName : String , strErrorMessage : String , strErrorCode : String , strRequestId : String){
        if MessageManager.shared.accessToken == "" {
            return
        }
            
        var paramer: [String: Any] = [:]
        paramer["apiName"] = strAPIName.replace(MessageManager.shared.APIBaseUrl, replacement: "")
        paramer["errorMessage"] = strErrorMessage
        paramer["errorStatusCode"] = strErrorCode
        paramer["requestId"] = strRequestId
        
        var arrError : [[String:Any]] = []
        arrError.append(paramer)
        
        Webservice.call.POSTArray(filePath: MessageConstant.ServiceType.api_errors_save, params: arrError, enableInteraction: true, showLoader: false, viewObj: nil, isOffline: true, onSuccess: { (result, success,requestId)  in
            if let _ = result as? [String : Any] {
                
            }
        }) {result, success, requestId  in
            
        }
    }
    
    func POSTDictionary(objVC: UIViewController, filePath: String, params: [String: Any], enableInteraction: Bool, showLoader: Bool, viewObj: UIView?, isOffline : Bool? = false, strAPITag : String? = "", isForCommunication : Bool? = false, onSuccess: @escaping ((_ requestId : String , _ responseData: Any, _ success: Bool) -> Void), onFailure: @escaping (FailureData)) {

        guard NetworkReachabilityManager()!.isReachable else {
            if showLoader {
                DispatchQueue.main.async {
                    MessageManager.shared.openCustomValidationAlertView(alertTitle: "keyError".localize, alertMessage: "ERROR_CALL".localize)
                }
            }
            return
        }
        
        let strPath = (isForCommunication! ? "\(MessageManager.shared.CommunicationAPIBaseUrl)" : "\(MessageManager.shared.APIBaseUrl)") + filePath
        var viewSpinner: UIView?
        if showLoader {
            DispatchQueue.main.async {
                viewSpinner = IPLoader.showLoaderWithBG(viewObj: viewObj!, boolShow: showLoader, enableInteraction: enableInteraction)!
            }
        }
        
        var request = URLRequest(url: URL(string: strPath)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(MessageManager.shared.accessTokenWithTokenType)", forHTTPHeaderField: "Authorization")
        
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        print("POST URL:- \(strPath) \nHEADER:- \(MessageManager.shared.accessTokenWithTokenType) \nPARAM:- \(json!)\n")
        
        let apiLog = tblAPIlogs()
        apiLog.apiURL = filePath
        apiLog.parameter = json?.replacingOccurrences(of: "\n", with: "") ?? ""
        apiLog.calledDate = "\(Date())"
        apiLog.apiCalledOn = Date().millisecondsSince1970
        _ = apiLog.save()
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.responseString { response in
            if showLoader {
                DispatchQueue.main.async {
                    IPLoader.hideRemoveLoaderFromView(removableView: viewSpinner!, mainView: viewObj!)
                }
            }
            let httpStatusCode = response.response?.statusCode
            if httpStatusCode == 200{
                //print("Success URL = \(response.request!)")
                if response != nil{
                    if response.data != nil{
                        let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                        do{
                            
                           let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                            
                            if let json = strResponse.data(using: String.Encoding.utf8){
                                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                    onSuccess(requestId, jsonData, true)
                                }
                                else if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [[String:AnyObject]]{
                                    onSuccess(requestId, jsonData, true)
                                }
                            }
                        }catch {
                            let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                            onFailure("",false, requestId)
                            if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                            }
                            print("POSTArray 200 Json serialize error - \(strResponse) -- \(response.request!)")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            else if httpStatusCode == 401{
                print("401 URL = \(response.request!)")
                let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                onFailure("",false, requestId)
//                MessageManager.shared.pushOnLoginVC()
            } else {
                print("Erro URL = \(response.request!)")
                
                if response.error?._code != NSURLErrorCancelled && response.error?._code != NSURLErrorNotConnectedToInternet && response.error?._code != NSURLErrorTimedOut && response.error?._code != NSURLErrorCannotFindHost && response.error?._code != NSURLErrorCannotConnectToHost && response.error?._code !=  NSURLErrorNetworkConnectionLost{
                    if response != nil{
                        if response.data != nil{
                            let strResponse = String(data: response.data!, encoding: String.Encoding.utf8)!
                            do{
                                if let json = strResponse.data(using: String.Encoding.utf8){
                                    if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                                        let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                        let message = jsonData["message"] as? String ?? ""
                                        onFailure(message,false, requestId)
                                        self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: message, strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                    }else{
                                        let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                        onFailure("",false, requestId)
                                    }
                                }else{
                                    let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                    onFailure("",false, requestId)
                                }
                            }catch {
                                
                                self.submitAPIErrorDetail(strAPIName: "\(response.request!)", strErrorMessage: response.error?.localizedDescription ?? "", strErrorCode: "\(response.error?._code ?? 400)", strRequestId: response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? "")
                                print("POSTArray Json serialize error - \(strResponse) -- \(response.request!)  -- \(response.error?._code ?? 400)")
                                print(error.localizedDescription)
                                let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                                onFailure("",false, requestId)
                            }
                        }else{
                            let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                            onFailure("",false, requestId)
                        }
                    }else{
                        let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                        onFailure("",false, requestId)
                    }
                }else{
                    let requestId = response.response?.allHeaderFields["Billiyo-Request-Id"] as? String ?? ""
                    onFailure("",false, requestId)
                }
            }
        }
    }
    
    
    
}


enum NSURLError: Int {
    case unknown = -1
    case cancelled = -999
    case badURL = -1000
    case timedOut = -1001
    case unsupportedURL = -1002
    case cannotFindHost = -1003
    case cannotConnectToHost = -1004
    case connectionLost = -1005
    case lookupFailed = -1006
    case HTTPTooManyRedirects = -1007
    case resourceUnavailable = -1008
    case notConnectedToInternet = -1009
    case redirectToNonExistentLocation = -1010
    case badServerResponse = -1011
    case userCancelledAuthentication = -1012
    case userAuthenticationRequired = -1013
    case zeroByteResource = -1014
    case cannotDecodeRawData = -1015
    case cannotDecodeContentData = -1016
    case cannotParseResponse = -1017
    //case NSURLErrorAppTransportSecurityRequiresSecureConnection NS_ENUM_AVAILABLE(10_11, 9_0) = -1022
    case fileDoesNotExist = -1100
    case fileIsDirectory = -1101
    case noPermissionsToReadFile = -1102
    //case NSURLErrorDataLengthExceedsMaximum NS_ENUM_AVAILABLE(10_5, 2_0) =   -1103

    // SSL errors
    case secureConnectionFailed = -1200
    case serverCertificateHasBadDate = -1201
    case serverCertificateUntrusted = -1202
    case serverCertificateHasUnknownRoot = -1203
    case serverCertificateNotYetValid = -1204
    case clientCertificateRejected = -1205
    case clientCertificateRequired = -1206
    case cannotLoadFromNetwork = -2000

    // Download and file I/O errors
    case cannotCreateFile = -3000
    case cannotOpenFile = -3001
    case cannotCloseFile = -3002
    case cannotWriteToFile = -3003
    case cannotRemoveFile = -3004
    case cannotMoveFile = -3005
    case downloadDecodingFailedMidStream = -3006
    case downloadDecodingFailedToComplete = -3007

    /*
     case NSURLErrorInternationalRoamingOff NS_ENUM_AVAILABLE(10_7, 3_0) =         -1018
     case NSURLErrorCallIsActive NS_ENUM_AVAILABLE(10_7, 3_0) =                    -1019
     case NSURLErrorDataNotAllowed NS_ENUM_AVAILABLE(10_7, 3_0) =                  -1020
     case NSURLErrorRequestBodyStreamExhausted NS_ENUM_AVAILABLE(10_7, 3_0) =      -1021

     case NSURLErrorBackgroundSessionRequiresSharedContainer NS_ENUM_AVAILABLE(10_10, 8_0) = -995
     case NSURLErrorBackgroundSessionInUseByAnotherProcess NS_ENUM_AVAILABLE(10_10, 8_0) = -996
     case NSURLErrorBackgroundSessionWasDisconnected NS_ENUM_AVAILABLE(10_10, 8_0)= -997
     */
}
