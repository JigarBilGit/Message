
import Foundation

struct Users: Codable {

    var employeeConversationId : Int64?  = 0
    var employeeId             : Int64?  = 0
    var isAdmin                : Bool?   = false
    var isDeleted              : Bool?   = false
    var canAddEmployee         : Bool?   = false

    enum CodingKeys: String, CodingKey {
        case employeeConversationId = "employeeConversationId"
        case employeeId             = "employeeId"
        case isAdmin                = "isAdmin"
        case isDeleted              = "isDeleted"
        case canAddEmployee         = "canAddEmployee"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        employeeConversationId = try values.decodeIfPresent(Int64.self  , forKey: .employeeConversationId)
        employeeId            = try values.decodeIfPresent(Int64.self  , forKey: .employeeId)
        isAdmin               = try values.decodeIfPresent(Bool.self , forKey: .isAdmin)
        isDeleted             = try values.decodeIfPresent(Bool.self , forKey: .isDeleted)
        canAddEmployee        = try values.decodeIfPresent(Bool.self , forKey: .canAddEmployee)
    }

    init() {

    }
}
