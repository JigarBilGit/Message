
import Foundation

struct Arguments: Codable {

    var message  : Message?    = Message()
    var receipts : [Receipts]? = []

    enum CodingKeys: String, CodingKey {
        case message  = "message"
        case receipts = "receipts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        message  = try values.decodeIfPresent(Message.self , forKey: .message)
        receipts = try values.decodeIfPresent([Receipts].self , forKey: .receipts)
    }

    init() {

    }
}
