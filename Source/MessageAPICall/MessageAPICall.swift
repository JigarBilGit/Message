//
//  MessageAPICall.swift
//  BilliyoCommunication
//
//
//  Created by Jigar Patel.
//  Copyright (c) 2023 Billiyo Mac. All rights reserved.
// 

import Alamofire
import SwiftSignalRClient

// MARK: 
// MARK: HUBCONNECTION DELEGATE METHODS
extension AppDelegate : HubConnectionDelegate {
    func setupCommunicationListener() {
        if let livechatURL = URL(string: "\(kretriveUserData().SignalRConnectionUrl ?? signalR.url)\(AppManager.shared.accessToken)") {
            self.hubConnectionConversation = HubConnectionBuilder(url: livechatURL)
                .withAutoReconnect()
                .withLogging(minLogLevel: .error)
                .withHubConnectionOptions(configureHubConnectionOptions: {options in options.keepAliveInterval = 10.0 })
                .withHubConnectionDelegate(delegate: self)
                .withPermittedTransportTypes(.webSockets)
                .withJSONHubProtocol()
                .withHttpConnectionOptions(configureHttpOptions: { httpConnectionOptions in
                    if #available(iOS 13.0, *) {
                        httpConnectionOptions.skipNegotiation = true
                    } else {
                        // Fallback on earlier versions
                    }
                })
                .build()
        }
        
        self.hubConnectionConversation.start()
        self.hubConnectionConversation.on(method: "CONVERSATION", callback: { (payload: ArgumentExtractor?) in
            do{
                print("Received Conversation Response.")
                let response = try payload?.getArgument(type: ConvesationArguments.self)
                if let dictConversations = response?.conversations as? Conversations{
                    var conversationData : [String : Any] = [:]
                    
                    conversationData["employeeConversationId"] = dictConversations.employeeConversationId ?? 0
                    conversationData["conversationId"] = dictConversations.conversationId ?? ""
                    conversationData["conversationName"] = dictConversations.conversationName ?? ""
                    conversationData["conversationImage"] = dictConversations.conversationImage ?? ""
                    conversationData["lastMessageContent"] = dictConversations.lastMessageContent ?? ""
                    conversationData["lastMessageTypeId"] = dictConversations.lastMessageTypeId ?? 0
                    conversationData["lastSenderEmployeeId"] = dictConversations.lastSenderEmployeeId ?? 0
                    conversationData["lastSenderFirstName"] = dictConversations.lastSenderFirstName ?? ""
                    conversationData["messageDateTime"] = dictConversations.messageDateTime ?? 0
                    conversationData["isAdmin"] = dictConversations.isAdmin ?? false
                    conversationData["canAddEmployee"] = dictConversations.canAddEmployee ?? false
                    conversationData["isGroup"] = dictConversations.isGroup ?? false
                    conversationData["isConnected"] = dictConversations.isConnected ?? false
                    conversationData["lastSeen"] = dictConversations.lastSeen ?? 0
                    conversationData["unreadCount"] = dictConversations.unreadCount ?? 0
                    
                    tblConversationList().insertORUpdateConversationList(arrConversationListData: [conversationData], completion: { success in
                        self.reloadConversationListTab()
                        
                        //==== Reload dashboard message count =====
                        //==========================================
                        self.reloadConversationCountOnDashBoard()
                        //==========================================
                        
                        
                    })
                }
                
                if let arrUsers = response?.users as? [Users]{
                    for eleUsers in arrUsers{
                        var userData : [String : Any] = [:]
                        
                        userData["employeeConversationId"] = eleUsers.employeeConversationId ?? 0
                        userData["employeeId"] = eleUsers.employeeId ?? 0
                        userData["isAdmin"] = eleUsers.isAdmin ?? false
                        userData["isDeleted"] = eleUsers.isDeleted ?? false
                        userData["canAddEmployee"] = eleUsers.canAddEmployee ?? false
                        
                        tblUserList().insertORUpdateUserList(arrUserListData: [userData]) { success in
                            
                        }
                    }
                }
            }
            catch{
                print(error)
            }
        })
    }
    
    func reloadConversationListTab(){
        DispatchQueue.main.async {
            for vc in APP_DELEGATE.rootNavigationVC!.viewControllers{
                if vc as? MessageListVC != nil {
                    if vc.isKind(of: MessageListVC.self) {
                        let objMessageListVC = vc as! MessageListVC
                        objMessageListVC.reloadConversationList()
                    }
                }
                else if vc as? TabBarVC != nil {
                    let objTabVC = vc as! TabBarVC
                    if objTabVC.viewControllers!.last!.isKind(of: MessageListVC.self) {
                        let innerVC = objTabVC.viewControllers!.last!
                        if innerVC.isKind(of: MessageListVC.self) {
                            let objMessageListVC = innerVC as! MessageListVC
                            objMessageListVC.reloadConversationList()
                        }
                    }
                }
            }
        }
    }
    
    func reloadConversationCountOnDashBoard(){
        
        tblConversationList().getUnreadMessageConversationCount { unReadConversationCount in
            DispatchQueue.main.async {
                
                if let topController = UIApplication.topViewController(), topController.isKind(of: DashboardVC.self) {
                    if let objDashboardVC = topController as? DashboardVC{
                        objDashboardVC.lblMessagesCount.text = "\(unReadConversationCount)"
                    }
                }
            }
            
        }
    }
    
    func connectionDidOpen(hubConnection: SwiftSignalRClient.HubConnection) {
        print("--------------------- \nConnection opened successfully.\n---------------------")
    }

    func connectionDidFailToOpen(error: Error) {
        print("--------------------- \nConnection failed to open: \(error.localizedDescription)\n---------------------")
    }

    func connectionDidClose(error: Error?) {
        if let error = error {
            print("--------------------- \nConnection closed with error: \(error.localizedDescription)\n---------------------")
        } else {
            print("--------------------- \nConnection closed gracefully.\n---------------------")
        }
    }

    func connectionWillReconnect(error: Error) {
        print("--------------------- \nConnection will attempt to reconnect: \(error.localizedDescription)\n---------------------")
    }

    func connectionDidReconnect() {
        print("--------------------- \nConnection successfully reconnected.\n---------------------")
    }

    func connectionDidReceiveData(connection: SwiftSignalRClient.Connection, data: Data) {
        print("--------------------- \nConnection successfully reconnected(Connection).\n---------------------")
    }

    func connectionDidReceiveData(hubConnection: HubConnection, data: Any) {
        print("--------------------- \nConnection successfully reconnected(HubConnection).\n---------------------")
    }
}
