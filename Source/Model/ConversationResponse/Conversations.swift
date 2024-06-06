
import Foundation

struct Conversations: Codable {
    
    var employeeConversationId : Int64?  = 0
    var conversationId         : String? = ""
    var conversationName       : String? = ""
    var conversationImage      : String? = ""
    var lastMessageContent     : String? = ""
    var lastMessageTypeId      : Int?  = 0
    var lastSenderEmployeeId   : Int64?  = 0
    var lastSenderFirstName    : String? = ""
    var messageDateTime        : Int64?  = 0
    var isAdmin                : Bool? = false
    var canAddEmployee         : Bool? = false
    var isGroup                : Bool? = false
    var isConnected            : Bool? = false
    var lastSeen               : Int64?  = 0
    var unreadCount            : Int?  = 0
    
    enum CodingKeys: String, CodingKey {
        
        case employeeConversationId = "employeeConversationId"
        case conversationId = "conversationId"
        case conversationName = "conversationName"
        case conversationImage = "conversationImage"
        case lastMessageContent = "lastMessageContent"
        case lastMessageTypeId = "lastMessageTypeId"
        case lastSenderEmployeeId = "lastSenderEmployeeId"
        case lastSenderFirstName = "lastSenderFirstName"
        case messageDateTime = "messageDateTime"
        case isAdmin = "isAdmin"
        case canAddEmployee = "canAddEmployee"
        case isGroup = "isGroup"
        case isConnected = "isConnected"
        case lastSeen = "lastSeen"
        case unreadCount = "unreadCount"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        employeeConversationId = try values.decodeIfPresent(Int64.self, forKey: .employeeConversationId)
        conversationId = try values.decodeIfPresent(String.self, forKey: .conversationId)
        conversationName = try values.decodeIfPresent(String.self, forKey: .conversationName)
        conversationImage = try values.decodeIfPresent(String.self, forKey: .conversationImage)
        lastMessageContent = try values.decodeIfPresent(String.self, forKey: .lastMessageContent)
        lastMessageTypeId = try values.decodeIfPresent(Int.self, forKey: .lastMessageTypeId)
        lastSenderEmployeeId = try values.decodeIfPresent(Int64.self, forKey: .lastSenderEmployeeId)
        lastSenderFirstName = try values.decodeIfPresent(String.self, forKey: .lastSenderFirstName)
        messageDateTime = try values.decodeIfPresent(Int64.self, forKey: .messageDateTime)
        isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin)
        canAddEmployee = try values.decodeIfPresent(Bool.self, forKey: .canAddEmployee)
        isGroup = try values.decodeIfPresent(Bool.self, forKey: .isGroup)
        isConnected = try values.decodeIfPresent(Bool.self, forKey: .isConnected)
        lastSeen = try values.decodeIfPresent(Int64.self, forKey: .lastSeen)
        unreadCount = try values.decodeIfPresent(Int.self, forKey: .unreadCount)
    }

    init() {

    }
}
