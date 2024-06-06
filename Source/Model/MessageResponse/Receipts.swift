
import Foundation

struct Receipts: Codable {

    var conversationMessageId : Int64?  = 0
    var employeeId            : Int64?  = 0
    var isDelivered           : Bool?   = false
    var isReceived            : Bool?   = false
    var isRead                : Bool?   = false
    var addedOn               : Int64?  = 0

    enum CodingKeys: String, CodingKey {
        case conversationMessageId = "conversationMessageId"
        case employeeId            = "employeeId"
        case isDelivered           = "isDelivered"
        case isReceived            = "isReceived"
        case isRead                = "isRead"
        case addedOn               = "addedOn"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        conversationMessageId = try values.decodeIfPresent(Int64.self  , forKey: .conversationMessageId)
        employeeId            = try values.decodeIfPresent(Int64.self  , forKey: .employeeId)
        isDelivered           = try values.decodeIfPresent(Bool.self , forKey: .isDelivered)
        isReceived            = try values.decodeIfPresent(Bool.self , forKey: .isReceived)
        isRead                = try values.decodeIfPresent(Bool.self , forKey: .isRead)
        addedOn               = try values.decodeIfPresent(Int64.self  , forKey: .addedOn)
    }

    init() {

    }
}
