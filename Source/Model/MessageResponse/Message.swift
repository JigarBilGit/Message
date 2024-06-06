
import Foundation
import Photos

struct Message: Codable {
    
    var conversationMessageId  : Int64?  = 0
    var conversationId         : String? = ""
    var employeeConversationId : Int64?  = 0
    var messageTypeId          : Int?  = 0
    var messageContent         : String? = ""
    var messageAttachment      : String? = ""
    var messageDateTime        : Int64?  = 0
    var replyMessageId         : Int64?  = 0
    var forwardMessageId       : Int64?  = 0
    var senderEmployeeId       : Int64?  = 0
    var mobilePrimaryKey       : String? = ""
    var addedBy                : Int64?  = 0
    var addedOn                : Int64?  = 0
    var isDeleted              : Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case conversationMessageId  = "conversationMessageId"
        case conversationId         = "conversationId"
        case employeeConversationId = "employeeConversationId"
        case messageTypeId          = "messageTypeId"
        case messageContent         = "messageContent"
        case messageAttachment      = "messageAttachment"
        case messageDateTime        = "messageDateTime"
        case replyMessageId         = "replyMessageId"
        case forwardMessageId       = "forwardMessageId"
        case senderEmployeeId       = "senderEmployeeId"
        case mobilePrimaryKey       = "mobilePrimaryKey"
        case addedBy                = "addedBy"
        case addedOn                = "addedOn"
        case isDeleted              = "isDeleted"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        conversationMessageId  = try values.decodeIfPresent(Int64.self , forKey: .conversationMessageId)
        conversationId         = try values.decodeIfPresent(String.self , forKey: .conversationId)
        employeeConversationId = try values.decodeIfPresent(Int64.self , forKey: .employeeConversationId)
        messageTypeId          = try values.decodeIfPresent(Int.self , forKey: .messageTypeId)
        messageAttachment      = try values.decodeIfPresent(String.self , forKey: .messageAttachment)
        messageContent         = try values.decodeIfPresent(String.self , forKey: .messageContent)
        messageDateTime        = try values.decodeIfPresent(Int64.self , forKey: .messageDateTime)
        replyMessageId         = try values.decodeIfPresent(Int64.self, forKey: .replyMessageId)
        forwardMessageId       = try values.decodeIfPresent(Int64.self, forKey: .forwardMessageId)
        senderEmployeeId       = try values.decodeIfPresent(Int64.self , forKey: .senderEmployeeId)
        mobilePrimaryKey       = try values.decodeIfPresent(String.self , forKey: .mobilePrimaryKey)
        addedBy                = try values.decodeIfPresent(Int64.self , forKey: .addedBy)
        addedOn                = try values.decodeIfPresent(Int64.self , forKey: .addedOn)
        isDeleted              = try values.decodeIfPresent(Bool.self , forKey: .isDeleted)
    }

    init() {

    }
    
    internal init(conversationId: String? = "", messageTypeId: Int? = 0, messageContent: String? = "", messageAttachment: String? = "", messageDateTime: Int64? = 0, replyMessageId: Int64? = 0, forwardMessageId: Int64? = 0, mobilePrimaryKey: String? = "") {
        self.conversationId = conversationId
        self.messageTypeId = messageTypeId
        self.messageAttachment = messageAttachment
        self.messageContent = messageContent
        self.messageDateTime = messageDateTime
        self.replyMessageId = replyMessageId
        self.forwardMessageId = forwardMessageId
        self.mobilePrimaryKey = mobilePrimaryKey
    }

}


/// Codable Model is used for "Read Message Count"

struct ReadMessage: Codable {

    var employeeConversationId : Int64?  = 0
    
    enum CodingKeys: String, CodingKey {
        case employeeConversationId = "employeeConversationId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employeeConversationId = try values.decodeIfPresent(Int64.self , forKey: .employeeConversationId)
        
    }

    init() {

    }
    
    internal init(employeeConversationId: Int64? = 0) {
        self.employeeConversationId = employeeConversationId
    }

}


extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
}
